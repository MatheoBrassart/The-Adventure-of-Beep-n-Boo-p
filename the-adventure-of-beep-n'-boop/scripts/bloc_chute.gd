extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var incoming_fall_timer: Timer = $IncomingFallTimer


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		
		incoming_fall_timer.start()


func _on_incoming_fall_timer_timeout() -> void:
	
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	area_2d.visible = false
