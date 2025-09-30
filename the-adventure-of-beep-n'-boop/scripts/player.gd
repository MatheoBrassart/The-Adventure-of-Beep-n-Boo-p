extends CharacterBody2D

class_name Player

const MAX_SPEED = 300.0
var CURRENT_SPEED = 0
var ACCELERATION = 50
var DECCELERATION = 60
var DECCELERATION_DIRECTION = 0

var direction = Input.get_axis("move_left", "move_right")

const JUMP_VELOCITY = -600.0
const GRAVITY_MULTIPLIER = 1.5

# Variable that defines which character is currently active. 0 = Beep, 1 = Boop
@export var CURRENT_ACTIVE_CHARACTER = 0

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animatedSpriteBeep: AnimatedSprite2D = $SpriteBeep
@onready var spriteBoop: Sprite2D = $SpriteBoop


func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if CURRENT_ACTIVE_CHARACTER == 0:
		animatedSpriteBeep.show()
		spriteBoop.hide()
	else:
		spriteBoop.show()
		animatedSpriteBeep.hide()


func _physics_process(delta: float) -> void:
	
	# Add the gravity and reduced decceleration when in the air
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta
		DECCELERATION = 30
	else:
		DECCELERATION = 70
	
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
	else:
		if velocity.y < 0:
			animatedSpriteBeep.play("jump")
		else:
			animatedSpriteBeep.play("fall")


func handle_input() -> void:
	
	direction = Input.get_axis("move_left", "move_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION)


func switch_character():
	
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
	
	queue_free()
