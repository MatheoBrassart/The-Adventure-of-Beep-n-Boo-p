extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/levels/atelier/atelier_a_1.tscn")


func _on_options_button_pressed() -> void:
	
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	
	get_tree().quit()
