extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

@export var BEEP_DOUBLESAUT: bool = false
@export var NIVEAU_LIMITECHANGEMOI: int = 0

var CHANGEMOI_RESTANTS = 0


func _ready() -> void:
	
	if BEEP_DOUBLESAUT == true:
		player.STATUTPERS_DOUBLESAUT = true
	
	if NIVEAU_LIMITECHANGEMOI > 0:
		CHANGEMOI_RESTANTS = NIVEAU_LIMITECHANGEMOI
