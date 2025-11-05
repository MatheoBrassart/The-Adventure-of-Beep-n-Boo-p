extends Area2D


func _on_body_entered(body: Node2D) -> void:
	
	# Kills the player when they touch them
	if body.is_in_group("Player") == true:
		body.player_death.call_deferred()
