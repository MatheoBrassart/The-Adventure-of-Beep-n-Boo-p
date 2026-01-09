extends Control

@onready var ui_general = get_tree().get_first_node_in_group("UIGeneral")

@onready var button_atelier: Button = $ButtonAtelier
@onready var button_villeen_ruine: Button = $ButtonVilleenRuine
@onready var button_plaines_venteuses: Button = $ButtonPlainesVenteuses


func _ready() -> void:
	
	button_atelier.grab_focus()

func _on_button_atelier_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/levels/atelier/atelier_a_1.tscn")


func _on_button_villeen_ruine_pressed() -> void:
	
	ui_general.activate_black_transition_nolevelswitch("SwitchLevel", "res://scenes/levels/villeenruine/villeenruine_a_1.tscn")
