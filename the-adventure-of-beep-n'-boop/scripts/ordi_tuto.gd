extends Node2D

@onready var animation: AnimatedSprite2D = $Animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Defines which tutorial this screen will play
@export var WHICH_TUTORIAL = "0"

# Get the global game informations scene
@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animation_player.play("RESET")
	
	if get_tree().get_current_scene().get_name() == "atelier_a_1":
		if gameInformations.CUTSCENE_BeepReveil == true:
			WHICH_TUTORIAL = "move"
	
	if WHICH_TUTORIAL == "move":
		animation.play("move")
	elif WHICH_TUTORIAL == "jump":
		animation.play("jump")
	elif WHICH_TUTORIAL == "changemoi":
		animation.play("changemoi")
	elif WHICH_TUTORIAL == "longressortjump":
		animation.play("longressortjump")
	elif WHICH_TUTORIAL == "nothing":
		animation.play("nothing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
