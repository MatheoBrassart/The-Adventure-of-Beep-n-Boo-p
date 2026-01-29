extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

@export var BEEP_DOUBLESAUT: bool = false


func _ready() -> void:
	
	if BEEP_DOUBLESAUT == true:
		player.STATUTPERS_DOUBLESAUT = true
