extends Node2D

var listOfChanges = []
var listOfPlayer = []


# ----- Handles Player Respawn -----
var WHERE_TO_RESPAWN_PLAYER = 0
var WHICH_CHARACTER_TO_RESPAWN = 0


# ----- Progress variables for dialogues and cutscenes -----
var CUTSCENE_BeepReveil: bool = false
var CUTSCENE_BoopReveil: bool = false
var CUTSCENE_PremierEnregistrement: bool = false
var CUTSCENE_SortieAtelier: bool = false
var CUTSCENE_ArriveeVilleEnRuine: bool = false


# ----- List of completed Levels -----
var COMPLETEDLEVELS_LIST: Dictionary = {
	"atelier" = {
		"b" = {
			13: false
		},
	},
	"villeenruine" = {
		1: false,
		2: false,
	},
}


# ----- List of obtained Puces de Données -----
var PUCES_LIST: Dictionary = {
	"atelier" = {
		1: false,
	},
	"villeenruine" = {
		1: false,
		2: false,
	},
}

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("switch_character"):
		
		listOfChanges = get_tree().get_nodes_in_group("BlocChange")
		for i in listOfChanges: 
			i.switch_state()
		
		listOfChanges = get_tree().get_nodes_in_group("PicsChange")
		for i in listOfChanges: 
			i.switch_state()
		
		listOfChanges = get_tree().get_nodes_in_group("RessortChange")
		for i in listOfChanges: 
			i.switch_state()
			
		listOfChanges = get_tree().get_nodes_in_group("VignesChange")
		for i in listOfChanges: 
			i.switch_state()
		
		listOfChanges = get_tree().get_nodes_in_group("ScieChange")
		for i in listOfChanges: 
			i.switch_state()
			
		listOfPlayer = get_tree().get_nodes_in_group("Player")
		for i in listOfPlayer: 
			i.switch_character()
