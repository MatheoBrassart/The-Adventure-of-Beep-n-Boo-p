extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var detection_timer: Timer = $DetectionTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_animation_player: AnimationPlayer = $DetectionAnimationPlayer

@export var DETECTION_TIMER_SETTER = 1.0


func _ready() -> void:
	
	animated_sprite_2d.play("inactive")
	detection_timer.wait_time = DETECTION_TIMER_SETTER


func _on_body_entered(body: Node2D) -> void:
	
	# Starts the timer when the player is within
	if body.is_in_group("Player") == true:
		animated_sprite_2d.play("active")
		detection_animation_player.play("detecting", -1, (1 / DETECTION_TIMER_SETTER))
		detection_timer.start()


func _on_body_exited(body: Node2D) -> void:
	
	# Starts the timer when the player is within
	if body.is_in_group("Player") == true:
		animated_sprite_2d.play("inactive")
		detection_animation_player.play("RESET")
		detection_timer.stop()


func _on_detection_timer_timeout() -> void:
	
	player.player_death.call_deferred()
