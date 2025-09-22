extends Node2D

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("switch_character"):
		
		Player.switch_character()
		BlocChangeBeep.switch_state()
		BlocChangeBoop.switch_state()
		PicsChangeBeep.switch_state()
