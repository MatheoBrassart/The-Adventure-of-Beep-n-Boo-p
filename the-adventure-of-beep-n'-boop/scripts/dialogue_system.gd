extends Control

@onready var characterRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Character
@onready var messageRichTextLabel: RichTextLabel = $CanvasLayer/NinePatchRect/Message

var numberOfCharacters: float = 0

@onready var animation_player: AnimationPlayer = $CanvasLayer/NinePatchRect/AnimationPlayer

var DIALOGUE_LIST: Dictionary = {
	"BeepReveil1" = {"Character": "Beep", "Message": "..."},
	"BeepReveil2" = {"Character": "Beep", "Message": "Qu... Qu’est-ce qu’il se passe ? Y’a quelqu'un ?"}
}
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("jump"):
		characterRichTextLabel.text = DIALOGUE_LIST["BeepReveil1"]["Character"]
		messageRichTextLabel.text = DIALOGUE_LIST["BeepReveil1"]["Message"]
		
		numberOfCharacters = DIALOGUE_LIST["BeepReveil1"]["Message"].length()
		
		animation_player.speed_scale = 1 + (numberOfCharacters / 2)
		animation_player.play("scroll")
