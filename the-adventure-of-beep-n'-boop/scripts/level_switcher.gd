extends Area2D

# Indicates to which level this exit will lead to
@export var TO_WHICH_LEVEL_DOES_IT_LEAD = "0"
# Indicates to which entrance the player will be teleported to in the nex level
@export var WHICH_ENTRANCE = 0


func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player") == true:
		get_tree().get_first_node_in_group("GameInformations").WHERE_TO_RESPAWN_PLAYER = WHICH_ENTRANCE
		var LEVEL_TO_LEAD_TO = "res://scenes/levels/" + TO_WHICH_LEVEL_DOES_IT_LEAD + ".tscn"
		get_tree().change_scene_to_file.call_deferred(LEVEL_TO_LEAD_TO)
		
