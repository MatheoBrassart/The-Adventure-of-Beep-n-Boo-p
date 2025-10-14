extends Area2D

# Indicates to which world this exit will lead to
@export var TO_WHICH_WORLD_DOES_IT_LEADS = "0"
# Indicates to which section this exit will lead to
@export var TO_WHICH_SECTION_DOES_IT_LEADS = "0"
# Indicates to which level number this exit will lead to
@export var TO_WHICH_LEVEL_DOES_IT_LEADS = 0
# Indicates to which entrance the player will be teleported to in the nex level
@export var TO_WHICH_ENTRANCE_DOES_IT_LEADS = 0


func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player") == true:
		get_tree().get_first_node_in_group("GameInformations").WHERE_TO_RESPAWN_PLAYER = TO_WHICH_ENTRANCE_DOES_IT_LEADS
		get_tree().get_first_node_in_group("GameInformations").WHICH_CHARACTER_TO_RESPAWN = body.CURRENT_ACTIVE_CHARACTER
		var LEVEL_TO_LEAD_TO = "res://scenes/levels/" + TO_WHICH_WORLD_DOES_IT_LEADS + "/" + TO_WHICH_WORLD_DOES_IT_LEADS + "_" + TO_WHICH_SECTION_DOES_IT_LEADS + "_" + str(TO_WHICH_LEVEL_DOES_IT_LEADS) + ".tscn"
		get_tree().change_scene_to_file.call_deferred(LEVEL_TO_LEAD_TO)
		
