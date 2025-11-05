extends Control

@onready var black_transition_animated_sprite_2d: AnimatedSprite2D = $black_transition/BlackTransitionAnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var black_transition: Control = $black_transition
@onready var surrounders: Node2D = $black_transition/Surrounders
@onready var transition_waiter: Timer = $black_transition/TransitionWaiter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	surrounders.visible = false
	black_transition_animated_sprite_2d.play("nothing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if get_tree().get_first_node_in_group("Player") != null:
	#	player = get_tree().get_first_node_in_group("Player")
	#	black_transition.position = player.position


func activate_black_transition(body: Node2D):
	
	player = get_tree().get_first_node_in_group("Player")
	player.CAN_MOVE = false
	black_transition.position = player.position
	surrounders.visible = true
	black_transition_animated_sprite_2d.play("activating")
	
	await black_transition_animated_sprite_2d.animation_finished
	body.switch_level()


func deactivate_black_transition(_body: Node2D):
	
	transition_waiter.start()


func _on_transition_waiter_timeout() -> void:
	
	player = get_tree().get_first_node_in_group("Player")
	player.CAN_MOVE = false
	black_transition.position = player.position
	black_transition_animated_sprite_2d.play("deactivating")
	
	await black_transition_animated_sprite_2d.animation_finished
	surrounders.visible = false
	player.CAN_MOVE = true
	if get_tree().get_current_scene().get_name() == "villeenruine_a_1":
		player.HAS_TO_PLAY_DIALOGUE = true
		player.check_cutscene_informations()
