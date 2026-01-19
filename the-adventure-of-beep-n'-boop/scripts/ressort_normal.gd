extends Area2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var ressortNormal2D: Area2D = $"."

# Power of the ressort
const RESSORT_VELOCITY = 900.0


func _ready() -> void:
	
	animatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	
	# Bounce the player when it touches it. Direction depends on its rotation.
	if body.is_in_group("Player") == true:
		animatedSprite2D.play("used")
		
		if round(self.rotation_degrees) == 90 or -90:
			body.HIT_SIDERESSORT = true
		
		if round(self.rotation_degrees) == 0:
			body.velocity.y = RESSORT_VELOCITY * -1
		elif round(self.rotation_degrees) == 90:
			body.velocity.x = RESSORT_VELOCITY
		elif round(self.rotation_degrees) == -90:
			body.velocity.x = RESSORT_VELOCITY * -1
