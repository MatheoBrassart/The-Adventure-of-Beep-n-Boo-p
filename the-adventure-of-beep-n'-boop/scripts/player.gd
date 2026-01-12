extends CharacterBody2D

class_name Player

@onready var ui_general = get_tree().get_first_node_in_group("UIGeneral")
@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")
@onready var dialogueSystem = get_tree().get_first_node_in_group("DialogueSystem")

# Animations
@onready var animatedSpriteBeep: AnimatedSprite2D = $SpriteBeep
@onready var animatedSpriteBoop: AnimatedSprite2D = $SpriteBoop
@onready var rightSprite: AnimatedSprite2D = $SpriteBeep
@onready var animatedSpriteChangeMoi: AnimatedSprite2D = $SpriteChangeMoi

# Timers and Raycasts
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var ray_cast_2d_hanging_top_checker: RayCast2D = $RayCast2DHangingTopChecker

# Base movement variables
var MAX_SPEED = 300.0
var OVER_MAX_SPEED = 0
var CURRENT_ACCELERATION = 0
var GROUND_ACCELERATION_SETTER = 50
var AIR_ACCELERATION_SETTER = 30
var DECCELERATION_DIRECTION = 0
const JUMP_VELOCITY = -625.0
const GRAVITY_MULTIPLIER = 1.5
const MAX_FREEFALLING_SPEED = 800

# Hanging-related variables
var VIGNES_SHAPECAST_CHECKER = null
var NEAR_VIGNES: bool = false
var CAN_HANG_AFTER_JUMP = true
var HANGING: bool = false
var MAX_HANGING_SPEED: float = 150.0

# Left or right or up or down movement, depending on which key is pressed
var direction_x = Input.get_axis("move_left", "move_right")
var direction_xANDy = Input.get_vector("move_left", "move_right", "move_up", "move_down")

# Variable that defines which character is currently active. 0 = Beep, 1 = Boop
@export var CURRENT_ACTIVE_CHARACTER = 0

# Variable that activates when the player hits a ressort
var HIT_RESSORT = false

# Dialogue and cutscenes-related variables
var CURRENT_ACTIVE_DIALOGUE = "0"
var HAS_TO_PLAY_DIALOGUE: bool = false

var LEVEL_TO_LEAD_TO: String = "0"

# Defines when the player can or can't move, during dialogues and cutscenes
var CAN_MOVE: bool = true

# Variable used to fix the crash problem when the player enters multiple death hitboxes at the same time
var multiHitboxDeathFixer = 0

# Defines at which location the player should spawn/respawn
var RESPAWNERS_POSITIONS_NUMBER = 0


func _ready() -> void:
	
	# Check at which location the player should spawn/respawn and which character should the player be respawned as
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
	if HANGING == false:
		if not is_on_floor():
			velocity += get_gravity() * GRAVITY_MULTIPLIER * delta
			if not HIT_RESSORT == true:
				CURRENT_ACCELERATION = AIR_ACCELERATION_SETTER
		else:
			CURRENT_ACCELERATION = GROUND_ACCELERATION_SETTER
			HIT_RESSORT = false
			CAN_HANG_AFTER_JUMP = true
	
	# Makes the player unable to fall faster than MAX_FREEFALLING_SPEED
	if velocity.y > MAX_FREEFALLING_SPEED:
		velocity.y = MAX_FREEFALLING_SPEED
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and CAN_MOVE == true:
		if HANGING == true:
			HANGING = false
			velocity.y = JUMP_VELOCITY
			# If player is moving up while jumping, can't hang again until release moving up
			if Input.is_action_pressed("move_up"):
				CAN_HANG_AFTER_JUMP = false
		else:
			jump_buffer_timer.start()
	
	if (is_on_floor() || !coyote_timer.is_stopped()) and !jump_buffer_timer.is_stopped():
		velocity.y = JUMP_VELOCITY
		coyote_timer.stop()
	
	# If player is moving up while jumping, can't hang again until release moving up
	if Input.is_action_just_released("move_up") and CAN_MOVE == true:
		if NEAR_VIGNES == true:
			CAN_HANG_AFTER_JUMP = true
	
	
	# Handle direction changes related to the player's current velocity for animations
	if Input.is_action_just_pressed("move_right"):
		DECCELERATION_DIRECTION = 1
	
	if Input.is_action_just_pressed("move_left"):
		DECCELERATION_DIRECTION = -1
	
	
	var was_on_floor = is_on_floor()
	
	
	# Checks if the player is near Vignes
	if shape_cast_2d.is_colliding() == true:
		VIGNES_SHAPECAST_CHECKER = shape_cast_2d.get_collider(0)
		if !VIGNES_SHAPECAST_CHECKER == null:
			if VIGNES_SHAPECAST_CHECKER.is_in_group("Vignes"):
				NEAR_VIGNES = true
			else:
				NEAR_VIGNES = false
				HANGING = false
				CAN_HANG_AFTER_JUMP = true
		else:
			NEAR_VIGNES = false
			HANGING = false
			CAN_HANG_AFTER_JUMP = true
	else:
		NEAR_VIGNES = false
		HANGING = false
		CAN_HANG_AFTER_JUMP = true
	
	# If the player is near vignes and moves up, hang onto them
	if Input.is_action_pressed("move_up") and CAN_MOVE == true:
		if NEAR_VIGNES == true and CAN_HANG_AFTER_JUMP == true:
			HANGING = true
	
	
	# Checks if the player is currently going over MAX_SPEED. If yes, sets the speed as OVER_MAX_SPEED and slow down
	if velocity.x > MAX_SPEED:
		if velocity.x > MAX_SPEED * 2:
			OVER_MAX_SPEED = MAX_SPEED * 2
		else:
			OVER_MAX_SPEED = velocity.x
		velocity.x -= CURRENT_ACCELERATION
	else:
		OVER_MAX_SPEED = 0
	
	# Handle left/right inputs and movement
	handle_input()
	move_and_slide()
	
	if was_on_floor and !is_on_floor() and !Input.is_action_just_pressed("jump"):
		coyote_timer.start()
	
	
	#Flip the sprite depending on which direction the player is going
	if direction_x > 0:
		animatedSpriteBeep.flip_h = false
		animatedSpriteBoop.flip_h = false
		animatedSpriteChangeMoi.flip_h = false
	elif direction_x < 0:
		animatedSpriteBeep.flip_h = true
		animatedSpriteBoop.flip_h = true
		animatedSpriteChangeMoi.flip_h = true
	
	#Play animations
	if CAN_MOVE == false:
		rightSprite.play("idle")
	
	if is_on_floor():
		if direction_x == 0:
			rightSprite.play("idle")
		else:
			rightSprite.play("run")
	else:
		if velocity.y < 0:
			rightSprite.play("jump")
		else:
			rightSprite.play("fall")


func handle_input() -> void:
	
	# Get inputed directions and moves the player accordingly
	if CAN_MOVE == true:
		direction_x = Input.get_axis("move_left", "move_right")
		direction_xANDy = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		direction_x = 0
		direction_xANDy = 0
	
	if HANGING == false:
		# Moves the player when they're not hanging
		if direction_x == 0:
			velocity.x = move_toward(velocity.x, 0, CURRENT_ACCELERATION)
		else:
			if OVER_MAX_SPEED > 0:
				velocity.x = move_toward(velocity.x, OVER_MAX_SPEED * direction_x, CURRENT_ACCELERATION)
			else:
				velocity.x = move_toward(velocity.x, MAX_SPEED * direction_x, CURRENT_ACCELERATION)
	else:
		# Moves the player when they're hanging
		velocity = direction_xANDy * MAX_HANGING_SPEED
		if velocity.y < 0:
			# Stops the player from moving over the top of the vignes
			if ray_cast_2d_hanging_top_checker.is_colliding() == false:
				velocity.y = 0


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


func hit_ressort(is_side: bool):
	
	# Reduces the acceleration of the player when a side ressort is hit
	HIT_RESSORT = true
	if is_side == true:
		CURRENT_ACCELERATION = 10
	else:
		CURRENT_ACCELERATION = 20


func check_respawn_informations():
	
	# Gets to which position the player should respawn in GameInformations, then teleports them
	if gameInformations.WHERE_TO_RESPAWN_PLAYER > 0:
		var respawners_positions = get_tree().get_nodes_in_group("PlayerSpawn1")
		RESPAWNERS_POSITIONS_NUMBER = 0
		for i in respawners_positions:
			RESPAWNERS_POSITIONS_NUMBER += 1
			print(RESPAWNERS_POSITIONS_NUMBER)
			if RESPAWNERS_POSITIONS_NUMBER == gameInformations.WHERE_TO_RESPAWN_PLAYER:
				position = i.position
				pass
		
	
	# Gets the last active character, and respawn the player as them
	if gameInformations.WHICH_CHARACTER_TO_RESPAWN == 1:
		CURRENT_ACTIVE_CHARACTER = 1


func check_cutscene_informations():
	
	if get_tree().get_current_scene().get_name() == "atelier_a_1":
		if gameInformations.CUTSCENE_BeepReveil == false:
			CURRENT_ACTIVE_DIALOGUE = "BeepReveil"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("BeepReveil", 0)
	
	if get_tree().get_current_scene().get_name() == "atelier_a_8" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_BoopReveil == false:
			CURRENT_ACTIVE_DIALOGUE = "BoopReveil"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("PlaceholderBoopReveil", 0)
	
	if get_tree().get_current_scene().get_name() == "atelier_b_9" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_PremierEnregistrement == false:
			CURRENT_ACTIVE_DIALOGUE = "PremierEnregistrement"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("PlaceholderPremierEnregistrement", 0)
	
	if get_tree().get_current_scene().get_name() == "atelier_b_13" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_SortieAtelier == false:
			CURRENT_ACTIVE_DIALOGUE = "SortieAtelier"
			CAN_MOVE = false
			if CURRENT_ACTIVE_CHARACTER == 0:
				dialogueSystem.play_dialogue("SortieAtelierVBeep", 0)
			else:
				dialogueSystem.play_dialogue("SortieAtelierVBoop", 0)
	
	if get_tree().get_current_scene().get_name() == "villeenruine_a_1" and HAS_TO_PLAY_DIALOGUE == true:
		if gameInformations.CUTSCENE_ArriveeVilleEnRuine == false:
			CURRENT_ACTIVE_DIALOGUE = "ArriveeVilleEnRuine"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("ArriveeVilleEnRuine", 0)
	
	if get_tree().get_current_scene().get_name() == "villeenruine_a_8" and HAS_TO_PLAY_DIALOGUE == true:
			CURRENT_ACTIVE_DIALOGUE = "FinDemo2"
			CAN_MOVE = false
			dialogueSystem.play_dialogue("FinDemo2", 0)

func finished_dialogue():
	
	if CURRENT_ACTIVE_DIALOGUE == "BeepReveil":
		gameInformations.CUTSCENE_BeepReveil = true
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
		var ordiTuto = get_tree().get_first_node_in_group("OrdiTuto")
		ordiTuto.animation_player.play("tutoApparition")
		ordiTuto.animation.play("move")
	
	if CURRENT_ACTIVE_DIALOGUE == "BoopReveil":
		gameInformations.CUTSCENE_BoopReveil = true
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
	
	if CURRENT_ACTIVE_DIALOGUE == "SortieAtelier":
		gameInformations.CUTSCENE_PremierEnregistrement = true
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
		gameInformations.COMPLETEDLEVELS_LIST.atelier.b = true
		ui_general.activate_black_transition_nolevelswitch("WorldMenu", "a")
	
	if CURRENT_ACTIVE_DIALOGUE == "ArriveeVilleEnRuine":
		gameInformations.CUTSCENE_ArriveeVilleEnRuine = true
		CAN_MOVE = true
		HAS_TO_PLAY_DIALOGUE = false
	
	if CURRENT_ACTIVE_DIALOGUE == "FinDemo2":
		get_tree().quit()


func switch_level():
	
	get_tree().change_scene_to_file.call_deferred(LEVEL_TO_LEAD_TO)
	ui_general.deactivate_black_transition(self)
