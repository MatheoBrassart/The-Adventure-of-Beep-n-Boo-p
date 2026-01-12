extends Control

@onready var ui_general = get_tree().get_first_node_in_group("UIGeneral")
@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

@onready var button_atelier: Button = $ButtonAtelier
@onready var button_villeen_ruine: Button = $ButtonVilleenRuine
@onready var button_villeen_ruine_label: Label = $ButtonVilleenRuine/buttonVilleenRuine_label
@onready var button_plaines_venteuses: Button = $ButtonPlainesVenteuses
@onready var world_unlock_timer: Timer = $WorldUnlockTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var IS_VILLEENRUINE_UNLOCKED: bool = false
var LEVEL_TO_UNLOCK: String = "a"

var tween = null


func _ready() -> void:
	
	button_atelier.grab_focus()
	
	if IS_VILLEENRUINE_UNLOCKED == false:
		if gameInformations.COMPLETEDLEVELS_LIST.atelier.b == true:
			LEVEL_TO_UNLOCK = "villeenruine"
			world_unlock_timer.start()
	else:
		button_villeen_ruine.disabled = false

func _on_button_atelier_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/levels/atelier/atelier_a_1.tscn")


func _on_button_villeen_ruine_pressed() -> void:
	
	ui_general.activate_black_transition_nolevelswitch("SwitchLevel", "res://scenes/levels/villeenruine/villeenruine_a_1.tscn")


func _on_world_unlock_timer_timeout() -> void:
	if LEVEL_TO_UNLOCK == "villeenruine":
		animation_player.play("unlock_villeenruine")
		button_villeen_ruine_label.text = "Ville en Ruine"
		button_villeen_ruine_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
		
		button_villeen_ruine_label.visible_ratio = 0
		tween=create_tween()
		tween.tween_property(button_villeen_ruine_label, "visible_ratio", 1, 0.8)
		tween.set_trans(Tween.TRANS_CUBIC)
		button_villeen_ruine.disabled = false
