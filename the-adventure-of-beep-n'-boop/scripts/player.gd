extends CharacterBody2D

class_name Player

const MAX_SPEED = 300.0
var CURRENT_SPEED = 0
var ACCELERATION = 40
var DECCELERATION = 50
var DECCELERATION_DIRECTION = 0

const JUMP_VELOCITY = -750.0
const GRAVITY_MULTIPLIER = 1.5

# Variable that defines which character is currently active. 0 = Beep, 1 = Boop
var CURRENT_CHARACTER = 0

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# Add the gravity and reduced decceleration
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta
		DECCELERATION = 20
	else:
		DECCELERATION = 50

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	#if direction > 0:
	#	animated_sprite.flip_h = false
	#elif direction < 0:
	#	animated_sprite.flip_h = true
		
	#Play animations
	#if is_on_floor():
	#	if direction == 0:
	#		animated_sprite.play("idle")
	#	else:
	#		animated_sprite.play("run")
	#else:
	#	animated_sprite.play("jump")
	
	# Apply movement via acceleration
	if direction:
		if CURRENT_SPEED <= MAX_SPEED:
			CURRENT_SPEED = CURRENT_SPEED + ACCELERATION
		velocity.x = direction * CURRENT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)
		
	# Slow down via decceleration
	if Input.is_action_just_pressed("move_right"):
		DECCELERATION_DIRECTION = 1
		
	if Input.is_action_just_pressed("move_left"):
		DECCELERATION_DIRECTION = -1
		
	if direction == 0:
		if not CURRENT_SPEED <= 0:
			CURRENT_SPEED = CURRENT_SPEED - DECCELERATION
			if CURRENT_SPEED <= 0:
				CURRENT_SPEED = 0
		velocity.x = DECCELERATION_DIRECTION * CURRENT_SPEED

	move_and_slide()
	
static func switch_character():
		
	print ("yay")
