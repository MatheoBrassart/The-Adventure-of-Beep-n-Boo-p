extends Control

@onready var characterRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Character
@onready var messageRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Message
@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var animation_player: AnimationPlayer = $CanvasLayer/NinePatchRect/AnimationPlayer

var CURRENT_DIALOGUE_KEY: String = "0"
var CURRENT_DIALOGUE_LINE: int = 0
var NUMBER_OF_CHARACTERS: float = 0
var IS_DIALOGUE_ONGOING: bool = false

# Liste de tous les dialogues
var DIALOGUE_LIST: Dictionary = {
	"BeepReveil" = {
		"0" = {"Character": "Beep", "Message": "...", "NumberOfRemainingLines": 1},
		"1" = {"Character": "Beep", "Message": "Qu... Qu’est-ce qu’il se passe ? Y’a quelqu'un ?", "NumberOfRemainingLines": 0}
	}
}


func play_dialogue(dialogueKey: String, line: int):
	
	if IS_DIALOGUE_ONGOING == false:
		IS_DIALOGUE_ONGOING = true
	
	# Sets the dialogue box to visible and the texts to the mentioned keys and lines.
	nine_patch_rect.visible = true
	CURRENT_DIALOGUE_KEY = dialogueKey
	CURRENT_DIALOGUE_LINE = line
	
	# Sets the texts
	characterRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Character"]
	messageRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"]
	
	# Checks the number of characters in the message, sets the apparition speed and plays the message apparition animation
	NUMBER_OF_CHARACTERS = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"].length()
	animation_player.speed_scale = 1 + (NUMBER_OF_CHARACTERS / 100)
	animation_player.play("scroll")


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("next_dialogue"):
		if IS_DIALOGUE_ONGOING == true:
			# Checks if the current dialogue has remaining lines. If yes, plays the next one.
			if DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["NumberOfRemainingLines"] > 0:
				play_dialogue(CURRENT_DIALOGUE_KEY, CURRENT_DIALOGUE_LINE + 1)
			# If no, ends the dialogue.
			else:
				IS_DIALOGUE_ONGOING = false
				nine_patch_rect.visible = false
				var player = get_tree().get_first_node_in_group("Player")
				player.finished_dialogue()
		
