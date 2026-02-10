extends Control

@onready var ui_general = get_tree().get_first_node_in_group("UIGeneral")

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var play_walkthrough_button: Button = $VBoxContainer/PlayWalkthroughButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	
	new_game_button.grab_focus()


func _on_new_game_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/levels/atelier/atelier_a_1.tscn")


func _on_options_button_pressed() -> void:
	
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	
	get_tree().quit()


func _on_play_walkthrough_button_pressed() -> void:
	
	ui_general.activate_black_transition_nolevelswitch("SwitchLevel", "res://scenes/levels/walkthrough/walkthrough_a_1.tscn")
