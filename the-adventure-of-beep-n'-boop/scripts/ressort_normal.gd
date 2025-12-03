extends Area2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var ressortNormal2D: Area2D = $"."

# Power of the ressort
const RESSORT_VELOCITY = 900.0

# Define the direction of the ressort. 1 = up, 2 = down, 3 = left, 4 = right
@export var RESSORT_DIRECTION = 1


func _ready() -> void:
	
	animatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	
	# Bounce the player when it touches it. Direction depends on its rotation.
	if body.is_in_group("Player") == true:
		animatedSprite2D.play("used")
		if RESSORT_DIRECTION == 3 or 4:
			body.hit_ressort(true)
		else:
			body.hit_ressort(false)
		if RESSORT_DIRECTION == 1:
			body.velocity.y = RESSORT_VELOCITY * -1
		elif RESSORT_DIRECTION == 3:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY, RESSORT_VELOCITY )
		elif RESSORT_DIRECTION == 4:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY * -1, RESSORT_VELOCITY)
