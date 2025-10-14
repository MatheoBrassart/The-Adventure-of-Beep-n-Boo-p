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
@onready var spriteBoop: Sprite2D = $SpriteBoop

# Variable that activates when the player hits a ressort
var HIT_RESSORT = false

# Get the global game informations scene
@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

# Variable used to fix the crash problem when the player enters multiple death hitboxes at the same time
var multiHitboxDeathFixer = 0


func _ready() -> void:
	
	# Check at which location the player should spawn/respawn and which character should the player be respawn as
	check_respawn_informations()
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if CURRENT_ACTIVE_CHARACTER == 0:
		animatedSpriteBeep.show()
		spriteBoop.hide()
	else:
		spriteBoop.show()
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
	elif direction < 0:
		animatedSpriteBeep.flip_h = true
	
	#Play animations
	if is_on_floor():
		if direction == 0:
			animatedSpriteBeep.play("idle")
		else:animatedSpriteBeep.play("run")
			
	else:
		if velocity.y < 0:
			animatedSpriteBeep.play("jump")
		else:
			animatedSpriteBeep.play("fall")


func handle_input() -> void:
	
	# Get direction and moves the player accordingly
	direction = Input.get_axis("move_left", "move_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION)


func switch_character():
	
	# Checks which character is currently active, and switch to the other one
	if CURRENT_ACTIVE_CHARACTER == 0:
		switch_to_boop()
	else:
		switch_to_beep()


func switch_to_beep():
	
	CURRENT_ACTIVE_CHARACTER = 0
	animatedSpriteBeep.show()
	spriteBoop.hide()


func switch_to_boop():
	
	CURRENT_ACTIVE_CHARACTER = 1
	spriteBoop.show()
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
