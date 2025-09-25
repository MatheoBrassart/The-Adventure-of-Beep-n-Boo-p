extends Node2D

var listOfBlocChanges = []
var listOfPicsChanges = []
var listOfPlayer = []

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("switch_character"):
		
		listOfBlocChanges = get_tree().get_nodes_in_group("BlocChange")
		for i in listOfBlocChanges: 
			i.switch_state()
		
		listOfPicsChanges = get_tree().get_nodes_in_group("PicsChange")
		for i in listOfPicsChanges: 
			i.switch_state()
			
		listOfPlayer = get_tree().get_nodes_in_group("Player")
		for i in listOfPlayer: 
			i.switch_character()
