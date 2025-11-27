extends Control

@onready var characterRichTextLabel: RichTextLabel = $CanvasLayer/DialogueBox/NinePatchRect/TopBit/Character
@onready var messageRichTextLabel: RichTextLabel = $CanvasLayer/DialogueBox/NinePatchRect/Message
@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/DialogueBox/NinePatchRect
@onready var animation_player_boxApparition: AnimationPlayer = $CanvasLayer/DialogueBox/AnimationPlayerBoxApparition
@onready var dialogue_box: Control = $CanvasLayer/DialogueBox
@onready var animated_sprite_faces: AnimatedSprite2D = $CanvasLayer/DialogueBox/NinePatchRect/Faces
@onready var animated_sprite_barre_espace: AnimatedSprite2D = $CanvasLayer/DialogueBox/NinePatchRect/BarreEspace
@onready var character_voices: AudioStreamPlayer = $CanvasLayer/DialogueBox/CharacterVoices

var CURRENT_DIALOGUE_KEY: String = "0"
var CURRENT_DIALOGUE_LINE: int = 0
var NUMBER_OF_CHARACTERS: float = 0
var IS_DIALOGUE_ONGOING: bool = false
var IS_DIALOGUE_APPARITION_ONGOING: bool = false

var tween = null

var VISIBLE_CHARACTERS = 0

# Liste de tous les dialogues
var DIALOGUE_LIST: Dictionary = {
	"BeepReveil" = {
		"0" = {"Character": "Beep", "Message": "...", "face": "beepNeutral"},
		"1" = {"Character": "Beep", "Message": "Qu... Qu’est-ce qu’il se passe ? Y’a quelqu'un ?", "face": "beepAnxious"}
	},
	"PlaceholderBoopReveil" = {
		"0" = {"Character": "Le créateur", "Message": "Bon, normalement ici il est sensé il y avoir une cutscene pour le réveil de Boop, et le tutoriel de Change-moi.", "face": "leCreateur"},
		"1" = {"Character": "Boop", "Message": "C'est moi.", "face": "boopBored"},
		"2" = {"Character": "Le créateur", "Message": "Elle sera faite dans le futur, puisque je n'avais pas eu le temps de la faire ces derniers jours...", "face": "leCreateur"},
		"3" = {"Character": "Beep", "Message": "En vrais il jouait à team fortress toute la journée, donc bon.", "face": "beep3Mouth"},
		"4" = {"Character": "Le créateur", "Message": "... Bref, le chemin est ouvert, et la suite de cette démo vous attend!", "face": "leCreateur"}
	},
	"PlaceholderPremierEnregistrement" = {
		"0" = {"Character": "Le créateur", "Message": "Et enfin, ce monde est fini! GG.", "face": "leCreateur"},
		"1" = {"Character": "Le créateur", "Message": "Cette dernière salle aura aussi une cutscene via le premier enregistrement de la créatrice pour annoncer à nos protagonistes leur quête...", "face": "leCreateur"},
		"2" = {"Character": "Le créateur", "Message": "... Et après ça, la fin de ce monde pour passer au prochain.", "face": "leCreateur"},
		"3" = {"Character": "Le créateur", "Message": "Et donc, cette démo est fini. J'espère que vous l'avez apprécié!", "face": "leCreateur"},
		"4" = {"Character": "Le créateur", "Message": "Je continurai donc ce jeu durant l'année, en ajoutant toujours plus de nouveaux mondes et de nouvelles mécaniques.", "face": "leCreateur"},
		"5" = {"Character": "Le créateur", "Message": "N'hésitez pas à poser des questions si vous en avez.", "face": "leCreateur"},
		"6" = {"Character": "Beep", "Message": "A plus!", "face": "beepHappy"}
	},
	"SortieAtelierVBeep" = {
		"0" = {"Character": "Beep", "Message": "L'extérieur, enfin ! C’est... différent que ce que je pensais. On devrait aller où ?", "face": "beepNeutral"},
		"1" = {"Character": "Boop", "Message": "Vers l’avant. La balise indiquait cette direction, vers l’endroit où... elle devrait être.", "face": "boopBored"},
		"2" = {"Character": "Beep", "Message": "Super, alors c’est parti !", "face": "beepNeutral"},
	},
	"SortieAtelierVBoop" = {
		"0" = {"Character": "Boop", "Message": "L’extérieur... Complétement déserts, lui aussi.", "face": "boopBored"},
		"1" = {"Character": "Beep", "Message": "Je mentirais si je disais que je ne trouvais pas l’atmosphère sympa.", "face": "beepNeutral"},
		"2" = {"Character": "Boop", "Message": "La balise de l’ordinateur indiquait l’avant, vers l’endroit où... elle devrait être. Allons-y.", "face": "boopBored"},
	},
	"ArriveeVilleEnRuine" = {
		"0" = {"Character": "Beep", "Message": "Le signal a l'air d'être loins vers l'avant, c'est ça ?", "face": "beepNeutral"},
		"1" = {"Character": "Boop", "Message": "Effectivement, il va nous falloir traverser cet endroit bizarre.", "face": "boopBored"},
		"2" = {"Character": "Beep", "Message": "Cool, ça va être marrant alors !", "face": "beepNeutral"},
		"3" = {"Character": "Boop", "Message": "Fait attention à où tu mets les pieds... Je n'ai pas envie de savoir ce qu'il nous arrivera si on tombe...", "face": "boopBored"},
		"4" = {"Character": "Boop", "Message": "... Et je n'ai pas vraiment envie de mourrir à cause de toi.", "face": "boopBored"},
		"5" = {"Character": "Beep", "Message": "On verra bien, hein.", "face": "beepNeutral"},
	},
	"FinDemo2" = {
		"0" = {"Character": "Le créateur", "Message": "Eeeet cette deuxième demo est terminée, gg !", "face": "leCreateur"},
		"1" = {"Character": "Le créateur", "Message": "De nouveau, tous retours sont appréciés.", "face": "leCreateur"},
		"2" = {"Character": "Le créateur", "Message": "Merci donc d'avoir jouer !", "face": "leCreateur"},
	}
}


func play_dialogue(dialogueKey: String, line: int):
	
	if IS_DIALOGUE_ONGOING == false:
		IS_DIALOGUE_ONGOING = true
		dialogue_box.visible = true
		animation_player_boxApparition.play("dialogueBoxApparition")
	
	animated_sprite_barre_espace.play("default")
	
	# Sets the dialogue box to visible and the texts to the mentioned keys and lines.
	nine_patch_rect.visible = true
	CURRENT_DIALOGUE_KEY = dialogueKey
	CURRENT_DIALOGUE_LINE = line
	
	# Sets the texts
	characterRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Character"]
	messageRichTextLabel.text = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"]
	
	# Sets the face
	animated_sprite_faces.play(DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["face"])
	
	# Checks the number of characters in the message, sets the apparition speed and plays the message apparition animation
	NUMBER_OF_CHARACTERS = DIALOGUE_LIST[CURRENT_DIALOGUE_KEY][str(CURRENT_DIALOGUE_LINE)]["Message"].length()
	messageRichTextLabel.visible_ratio = 0
	IS_DIALOGUE_APPARITION_ONGOING = true
	# animation_player_messageCreation.play("scroll")
	
	tween=create_tween()
	tween.tween_property(messageRichTextLabel, "visible_ratio", 1, NUMBER_OF_CHARACTERS/40)
	tween.set_trans(Tween.TRANS_CUBIC)


func _process(_delta: float) -> void:
	
	if messageRichTextLabel.visible_ratio == 1:
		IS_DIALOGUE_APPARITION_ONGOING = false
		animated_sprite_barre_espace.play("active")
	
	if VISIBLE_CHARACTERS != messageRichTextLabel.visible_characters:
		VISIBLE_CHARACTERS = messageRichTextLabel.visible_characters
		character_voices.pitch_scale = randf_range(0.74,0.76)
		character_voices.play()
	
	if Input.is_action_just_pressed("next_dialogue"):
		if IS_DIALOGUE_ONGOING == true:
			if IS_DIALOGUE_APPARITION_ONGOING == true:
				tween.stop()
				messageRichTextLabel.visible_ratio = 1
			# Checks if the current dialogue has remaining lines. If yes, plays the next one.
			elif DIALOGUE_LIST[CURRENT_DIALOGUE_KEY].has(str(CURRENT_DIALOGUE_LINE + 1)) == true:
				play_dialogue(CURRENT_DIALOGUE_KEY, CURRENT_DIALOGUE_LINE + 1)
			# If no, ends the dialogue.
			else:
				IS_DIALOGUE_ONGOING = false
				animation_player_boxApparition.play("dialogueBoxDisparition")
				var player = get_tree().get_first_node_in_group("Player")
				player.finished_dialogue()
		


func _on_animation_player_box_apparition_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "dialogueBoxDisparition":
		dialogue_box.visible = false
