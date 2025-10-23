extends CharacterBody2D

class_name Player

# Base movement stats
var MAX_SPEED = 300.0
var ACCELERATION = 50
var DECCELERATION_DIRECTION = 0
const JUMP_VELOCITY = -625.0
const GRAVITY_MULTIPLIER = 1.5

# Left or right movement, depending on which key is pressed
var direction = Input.get_axis("move_left", "move_right")

# Variable that defines which character is currently active. 0 = Beep, 1 = Boop
@export var CURRENT_ACTIVE_CHARACTER = 0

# Animations
@onready var animatedSpriteBeep: AnimatedSprite2D = $SpriteBeep
@onready var animatedSpriteBoop: AnimatedSprite2D = $SpriteBoop
@onready var rightSprite: AnimatedSprite2D = $SpriteBeep
@onready var animatedSpriteChangeMoi: AnimatedSprite2D = $SpriteChangeMoi

# Variable that activates when the player hits a ressort
var HIT_RESSORT = false

# Get the global game informations scene
@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")
# Get the global dialogue system scene and dialogue-related variables
@onready var dialogueSystem = get_tree().get_first_node_in_group("DialogueSystem")
var CURRENT_ACTIVE_DIALOGUE = "0"
var HAS_TO_PLAY_DIALOGUE: bool = false

# Variable used to fix the crash problem when the player enters multiple death hitboxes at the same time
var multiHitboxDeathFixer = 0

# Defines when the player can or can't move
var CAN_MOVE: bool = true


func _ready() -> void:
	
	# Check at which location the player should spawn/respawn and which character should the player be respawn as
	check_respawn_informations()
	
	# Check if a cutscene should be played
	check_cutscene_informations()
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if CURRENT_ACTIVE_CHARACTER == 0:
		animatedSpriteBeep.show()
		rightSprite = animatedSpriteBeep
		animatedSpriteBoop.hide()
	else:
		animatedSpriteBoop.show()
		rightSprite = animatedSpriteBoop
		animatedSpriteBeep.hide()


func _physics_process(delta: float) -> void:
	
	# Add the gravity and reduces acceleration when in the air
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta
		if not HIT_RESSORT == true:
			ACCELERATION = 20
	else:
		ACCELERATION = 50
		HIT_RESSORT = false
	
	# If the player can't move, stop all input possibilities
	if CAN_MOVE == false:
		rightSprite.play("idle")
		return
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle direction changes related to the player's current velocity
	if Input.is_action_just_pressed("move_right"):
		DECCELERATION_DIRECTION = 1
	
	if Input.is_action_just_pressed("move_left"):
		DECCELERATION_DIRECTION = -1
	
	# Handle left/right inputs and movement
	handle_input()
	move_and_slide()
	
	#Flip the sprite
	if direction > 0:
		animatedSpriteBeep.flip_h = false
		animatedSpriteBoop.flip_h = false
		animatedSpriteChangeMoi.flip_h = false
	elif direction < 0:
		animatedSpriteBeep.flip_h = true
		animatedSpriteBoop.flip_h = true
		animatedSpriteChangeMoi.flip_h = true
	
	#Play animations
	if is_on_floor():
		if direction == 0:
			rightSprite.play("idle")
		else:rightSprite.play("run")
			
	else:
		if velocity.y < 0:
			rightSprite.play("jump")
		else:
			rightSprite.play("fall")


func handle_input() -> void:
	
	# Get direction and moves the player accordingly
	direction = Input.get_axis("move_left", "move_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION)


func switch_character():
	
	if CAN_MOVE == false:
		return
	
	animatedSpriteChangeMoi.visible = true
	animatedSpriteChangeMoi.play("active")
	# Checks which character is currently active, and switch to the other one
	if CURRENT_ACTIVE_CHARACTER == 0:
		switch_to_boop()
	else:
		switch_to_beep()


func switch_to_beep():
	
	CURRENT_ACTIVE_CHARACTER = 0
	animatedSpriteBeep.show()
	rightSprite = animatedSpriteBeep
	animatedSpriteBoop.hide()


func switch_to_boop():
	
	CURRENT_ACTIVE_CHARACTER = 1
	animatedSpriteBoop.show()
	rightSprite = animatedSpriteBoop
	animatedSpriteBeep.hide()


func player_death():
	
	multiHitboxDeathFixer += 1
	if multiHitboxDeathFixer == 1:
		get_tree().reload_current_scene()


func hit_ressort():
	
	# Reduces the acceleration of the player when a ressort is hit
	HIT_RESSORT = true
	ACCELERATION = 10


func check_respawn_informations():
	
	# Gets to which position the player should respawn in GameInformations, then teleports them
	if gameInformations.WHERE_TO_RESPAWN_PLAYER == 1:
		position = get_tree().get_first_node_in_group("PlayerSpawn1").position
	
	# Gets the last active character, and respawn the player as them
	if gameInformations.WHICH_CHARACTER_TO_RESPAWN == 1:
		CURRENT_ACTIVE_CHARACTER = 1


func check_cutscene_informations():
	
	if get_tree().get_current_scene().get_name() == "atelier_a_1":
		if gameInformations.CUTSCENE_BeepReveil == false:
			gameInformations.CUTSCENE_BeepReveil = true
			CURRENT_ACTIVE_DIALOGUE = "BeepReveil"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("BeepReveil", 0)
	
	if get_tree().get_current_scene().get_name() == "atelier_a_8" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_BoopReveil == false:
			gameInformations.CUTSCENE_BoopReveil = true
			CURRENT_ACTIVE_DIALOGUE = "BoopReveil"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("PlaceholderBoopReveil", 0)
	
	if get_tree().get_current_scene().get_name() == "atelier_b_9" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_PremierEnregistrement == false:
			gameInformations.CUTSCENE_PremierEnregistrement = true
			CURRENT_ACTIVE_DIALOGUE = "PremierEnregistrement"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("PlaceholderPremierEnregistrement", 0)

func finished_dialogue():
	
	if CURRENT_ACTIVE_DIALOGUE == "BeepReveil":
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
	
	if CURRENT_ACTIVE_DIALOGUE == "BoopReveil":
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
	
	if CURRENT_ACTIVE_DIALOGUE == "PremierEnregistrement":
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
