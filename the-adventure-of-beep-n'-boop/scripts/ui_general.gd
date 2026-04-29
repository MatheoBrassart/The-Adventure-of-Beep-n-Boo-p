extends Control

@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

@onready var black_transition_animated_sprite_2d: AnimatedSprite2D = $black_transition/BlackTransitionAnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var black_transition: Control = $black_transition
@onready var surrounders: Node2D = $black_transition/Surrounders

@onready var transition_waiter: Timer = $black_transition/TransitionWaiter
@onready var black_transition_ongoing_timer: Timer = $black_transition/BlackTransitionOngoingTimer
@onready var black_transition_ongoing_timer_delay: Timer = $black_transition/BlackTransitionOngoingTimerDelay

@onready var double_saut_beep_sprite_2d: Sprite2D = $status/DoubleSautBeepSprite2D
@onready var limite_change_moi_sprite_2d: Sprite2D = $status/LimiteChangeMoiSprite2D
@onready var status_animation_player: AnimationPlayer = $status/StatusAnimationPlayer

var WHAT_TO_DO_AFTER_TRANSITION:String = "a"
var LEVEL_TO_LEAD_TO:String = "a"

var PLAY_DBP = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	surrounders.visible = false
	black_transition_animated_sprite_2d.play("nothing")


func activate_black_transition_nolevelswitch(order: String, switchedLevel: String):
	
	player = get_tree().get_first_node_in_group("Player")
	if not player == null:
		player.CAN_MOVE = false
		black_transition.global_position = player.rightSprite.global_position
	surrounders.visible = true
	WHAT_TO_DO_AFTER_TRANSITION = order
	LEVEL_TO_LEAD_TO = switchedLevel
	black_transition_animated_sprite_2d.play("activating")
	
	black_transition_ongoing_timer.start()


func _on_black_transition_ongoing_timer_timeout() -> void:
	
	if WHAT_TO_DO_AFTER_TRANSITION == "WorldMenu":
		get_tree().change_scene_to_file("res://scenes/menus/world_menu.tscn")
		black_transition.position = Vector2(940,520)
	
	if WHAT_TO_DO_AFTER_TRANSITION == "SwitchLevel":
		get_tree().change_scene_to_file(LEVEL_TO_LEAD_TO)
	
	# Delay used so that SwitchLevel doesn't return a null when looking for the player
	black_transition_ongoing_timer_delay.start()


func _on_black_transition_ongoing_timer_delay_timeout() -> void:
	
	if WHAT_TO_DO_AFTER_TRANSITION == "SwitchLevel":
		player = get_tree().get_first_node_in_group("Player")
		player.CAN_MOVE = false
		black_transition.position = player.position
	
	black_transition_animated_sprite_2d.play("deactivating")
	await black_transition_animated_sprite_2d.animation_finished
	
	surrounders.visible = false
	if WHAT_TO_DO_AFTER_TRANSITION == "SwitchLevel":
		gameInformations.HAS_LIMITECHANGEMOI = false
		match get_tree().get_current_scene().get_name():
			"atelier_a_1":
				gameInformations.check_cutscene_informations("BeepReveil")
			"villeenruine_a_1":
				gameInformations.check_cutscene_informations("ArriveeVilleEnRuine")
			"plainesventeuses_a_1":
				gameInformations.check_cutscene_informations("ArriveePlainesVenteuses")
			"walkthrough_a_1":
				gameInformations.check_cutscene_informations("BeepReveilWalkthrough")
			_:
				player.CAN_MOVE = true
	
	if WHAT_TO_DO_AFTER_TRANSITION == "SwitchLevel":
		var machine = get_tree().get_first_node_in_group("MachineStatut")
		if not machine == null:
			if (machine.BEEP_DOUBLESAUT == true) and (double_saut_beep_sprite_2d.visible == false):
				status_animation_player.play("DSB_Apparition")
			if (machine.NIVEAU_LIMITECHANGEMOI > 0) and (limite_change_moi_sprite_2d.visible == false):
				print("a")
				status_animation_player.play("LCM_Apparition")
		else:
			if double_saut_beep_sprite_2d.visible == true:
				double_saut_beep_sprite_2d.visible = false
			if limite_change_moi_sprite_2d.visible == true:
				limite_change_moi_sprite_2d.visible = false
