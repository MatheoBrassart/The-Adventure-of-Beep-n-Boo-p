extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var detection_timer: Timer = $DetectionTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var DETECTION_TIMER_SETTER = 1.0


func _ready() -> void:
	
	detection_timer.wait_time = DETECTION_TIMER_SETTER


func _on_body_entered(body: Node2D) -> void:
	
	# Starts the timer when the player is within
	if body.is_in_group("Player") == true:
		sprite_2d.modulate = Color(1.0, 0.452, 0.384, 1.0)
		detection_timer.start()


func _on_body_exited(body: Node2D) -> void:
	
	# Starts the timer when the player is within
	if body.is_in_group("Player") == true:
		sprite_2d.modulate = Color(1.0, 1.0, 1.0, 1.0)
		detection_timer.stop()


func _on_detection_timer_timeout() -> void:
	
	player.player_death.call_deferred()
