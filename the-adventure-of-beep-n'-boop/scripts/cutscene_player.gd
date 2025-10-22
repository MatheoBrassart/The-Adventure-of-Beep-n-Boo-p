extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		body.HAS_TO_PLAY_DIALOGUE = true
		body.check_cutscene_informations()
