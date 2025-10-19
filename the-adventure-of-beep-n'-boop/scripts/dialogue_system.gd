extends Control

@onready var characterRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Character
@onready var messageRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Message

var CURRENT_DIALOGUE_KEY: String = "0"
var CURRENT_DIALOGUE_LINE: int = 0
var numberOfCharacters: float = 0
var IS_DIALOGUE_ONGOING: bool = false

@onready var animation_player: AnimationPlayer = $CanvasLayer/NinePatchRect/AnimationPlayer

var DIALOGUE_LIST: Dictionary = {
	"BeepReveil" = {
		"0" = {"Character": "Beep", "Message": "...", "NumberOfRemainingLines": 1},
		"1" = {"Character": "Beep", "Message": "Qu... Qu’est-ce qu’il se passe ? Y’a quelqu'un ?", "NumberOfRemainingLines": 0}
	}
}


func play_dialogue(dialogueKey: String, line: int):
	
	if IS_DIALOGUE_ONGOING == false:
		IS_DIALOGUE_ONGOING = true
	
	CURRENT_DIALOGUE_KEY = dialogueKey
	CURRENT_DIALOGUE_LINE = line
	
	characterRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Character"]
	messageRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"]
		
	numberOfCharacters = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"].length()
	
	animation_player.speed_scale = 1 + (numberOfCharacters / 100)
	animation_player.play("scroll")


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("jump"):
		
		if IS_DIALOGUE_ONGOING == true:
			if DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["NumberOfRemainingLines"] > 0:
				play_dialogue(CURRENT_DIALOGUE_KEY, CURRENT_DIALOGUE_LINE + 1)
			else:
				IS_DIALOGUE_ONGOING = false
				var player = get_tree().get_first_node_in_group("Player")
				player.finished_dialogue()
		
