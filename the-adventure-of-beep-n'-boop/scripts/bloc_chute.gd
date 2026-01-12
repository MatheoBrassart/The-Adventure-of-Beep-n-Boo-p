extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var incoming_fall_timer: Timer = $IncomingFallTimer

var SHOULD_BE_SHAKING: bool = false
var SHAKE_POWER = 0.1
var SHAKE_RANGE = 3


func _process(delta: float) -> void:
	
	if SHOULD_BE_SHAKING == true:
		sprite_2d.position = Vector2(randf_range(-SHAKE_RANGE, SHAKE_RANGE), randf_range(-SHAKE_RANGE, SHAKE_RANGE))


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		SHOULD_BE_SHAKING = true
		incoming_fall_timer.start()


func _on_incoming_fall_timer_timeout() -> void:
	
	SHOULD_BE_SHAKING = false
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	area_2d.visible = false
