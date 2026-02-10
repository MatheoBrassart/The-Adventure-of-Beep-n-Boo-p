extends Node2D

@onready var dialogueSystem = get_tree().get_first_node_in_group("DialogueSystem")
@onready var ui_general = get_tree().get_first_node_in_group("UIGeneral")

var listOfChanges = []
var listOfPlayer = []
var listOfCourantsAirChanges = []


# ----- Handles Player Respawn -----
var WHERE_TO_RESPAWN_PLAYER = 0
var WHICH_CHARACTER_TO_RESPAWN = 0


# ----- Progress variables for dialogues and cutscenes -----
var CUTSCENE_BeepReveil: bool = false
var CUTSCENE_BoopReveil: bool = false
var CUTSCENE_PremierEnregistrement: bool = false
var CUTSCENE_SortieAtelier: bool = false
var CUTSCENE_ArriveeVilleEnRuine: bool = false
var CUTSCENE_ArriveePlainesVenteuses: bool = false
var CUTSCENE_BeepReveilWalkthrough: bool = false

var CURRENT_ACTIVE_DIALOGUE: String = "0"


# ----- List of completed Levels -----
var COMPLETEDLEVELS_LIST: Dictionary = {
	"atelier" = {
		"b" = {
			"c": false,
			"13": false,
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
	
	# ----- Change-Moi -----
	if Input.is_action_just_pressed("switch_character"):
		var player = get_tree().get_first_node_in_group("Player")
		if not player == null:
			if player.ISIN_ZONEANTICHANGE == 0:
			
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
				
				listOfChanges = get_tree().get_nodes_in_group("CourantAirChange")
				for i in listOfChanges: 
					i.change_wind_direction()
				
				listOfChanges = get_tree().get_nodes_in_group("BlocMouvant")
				for i in listOfChanges: 
					i.pause_unpause_movement()


func check_cutscene_informations(whichCutscene: String):
	
	match whichCutscene:
		"BeepReveil":
			if CUTSCENE_BeepReveil == false:
				CURRENT_ACTIVE_DIALOGUE = "BeepReveil"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				dialogueSystem.play_dialogue("BeepReveil", 0)
		
		"BoopReveil":
			if CUTSCENE_BoopReveil == false:
				CURRENT_ACTIVE_DIALOGUE = "BoopReveil"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				dialogueSystem.play_dialogue("PlaceholderBoopReveil", 0)
	
		"PremierEnregistrement":
			if CUTSCENE_PremierEnregistrement == false:
				CURRENT_ACTIVE_DIALOGUE = "PremierEnregistrement"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				dialogueSystem.play_dialogue("PlaceholderPremierEnregistrement", 0)
	
		"SortieAtelier":
			if CUTSCENE_SortieAtelier == false:
				CURRENT_ACTIVE_DIALOGUE = "SortieAtelier"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				if player.CURRENT_ACTIVE_CHARACTER == 0:
					dialogueSystem.play_dialogue("SortieAtelierVBeep", 0)
				else:
					dialogueSystem.play_dialogue("SortieAtelierVBoop", 0)
		
		"ArriveeVilleEnRuine":
			if CUTSCENE_ArriveeVilleEnRuine == false:
				CURRENT_ACTIVE_DIALOGUE = "ArriveeVilleEnRuine"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				dialogueSystem.play_dialogue("ArriveeVilleEnRuine", 0)
		
		"ArriveePlainesVenteuses":
			if CUTSCENE_ArriveePlainesVenteuses == false:
				CURRENT_ACTIVE_DIALOGUE = "ArriveePlainesVenteuses"
				var player = get_tree().get_first_node_in_group("Player")
				player.CAN_MOVE = false
				dialogueSystem.play_dialogue("ArriveePlainesVenteuses", 0)
		
		"FinDemo2":
			CURRENT_ACTIVE_DIALOGUE = "FinDemo2"
			var player = get_tree().get_first_node_in_group("Player")
			player.CAN_MOVE = false
			dialogueSystem.play_dialogue("FinDemo2", 0)
		
		"BeepReveilWalkthrough":
			CURRENT_ACTIVE_DIALOGUE = "BeepReveilWalkthrough"
			var player = get_tree().get_first_node_in_group("Player")
			player.CAN_MOVE = false
			dialogueSystem.play_dialogue("BeepReveilWalkthrough", 0)


func finished_dialogue():
	
	if CURRENT_ACTIVE_DIALOGUE == "BeepReveil":
		CUTSCENE_BeepReveil = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
		var ordiTuto = get_tree().get_first_node_in_group("OrdiTuto")
		ordiTuto.animation_player.play("tutoApparition")
		ordiTuto.animation.play("move")
	
	if CURRENT_ACTIVE_DIALOGUE == "BoopReveil":
		CUTSCENE_BoopReveil = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
	
	if CURRENT_ACTIVE_DIALOGUE == "SortieAtelier":
		CUTSCENE_PremierEnregistrement = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
		COMPLETEDLEVELS_LIST["atelier"]["b"]["13"] = true
		ui_general.activate_black_transition_nolevelswitch("WorldMenu", "a")
	
	if CURRENT_ACTIVE_DIALOGUE == "ArriveeVilleEnRuine":
		CUTSCENE_ArriveeVilleEnRuine = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
	
	if CURRENT_ACTIVE_DIALOGUE == "ArriveePlainesVenteuses":
		CUTSCENE_ArriveePlainesVenteuses = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
	
	if CURRENT_ACTIVE_DIALOGUE == "BeepReveilWalkthrough":
		CUTSCENE_BeepReveilWalkthrough = true
		var player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = true
	
	if CURRENT_ACTIVE_DIALOGUE == "FinDemo2":
		get_tree().quit()
