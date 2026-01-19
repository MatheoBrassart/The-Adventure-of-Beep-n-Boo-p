extends Area2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D

# Power of the ressort
const RESSORT_VELOCITY = 900.0


func _ready() -> void:
	
	animatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	
	# Bounces the player when they touches it. Direction depends on its rotation.
	if body.is_in_group("Player") == true:
		animatedSprite2D.play("used")
	
		match round(self.rotation_degrees):
			0.0:
				body.velocity.y = RESSORT_VELOCITY * -1
			90.0:
				body.HIT_SIDERESSORT = true
				body.velocity.x = RESSORT_VELOCITY
			-90.0:
				body.HIT_SIDERESSORT = true
				body.velocity.x = RESSORT_VELOCITY * -1
