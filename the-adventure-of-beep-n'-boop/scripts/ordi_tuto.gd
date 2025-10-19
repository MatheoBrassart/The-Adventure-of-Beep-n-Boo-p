extends Node2D

@onready var animation: AnimatedSprite2D = $Animation

# Defines which tutorial this screen will play
@export var WHICH_TUTORIAL = "0"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if WHICH_TUTORIAL == "move":
		animation.play("move")
	elif WHICH_TUTORIAL == "jump":
		animation.play("jump")
	elif WHICH_TUTORIAL == "changemoi":
		animation.play("changemoi")
	elif WHICH_TUTORIAL == "longressortjump":
		animation.play("longressortjump")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
