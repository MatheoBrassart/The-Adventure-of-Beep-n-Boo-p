extends Area2D

@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

# Defines which cutscene/dialogue to play
@export var WHICH_CUTSCENE: String = "0"


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		# body.HAS_TO_PLAY_DIALOGUE = true
		gameInformations.check_cutscene_informations(WHICH_CUTSCENE)
