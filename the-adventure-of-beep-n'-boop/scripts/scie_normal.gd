extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	
	animated_sprite_2d.play("default")


func _on_body_entered(body: Node2D) -> void:
	
	# Kills the player when they touch them
	if body.is_in_group("Player") == true:
		body.player_death.call_deferred()
