extends Node2D

@export var LOOP: bool = true
@export var SPEED: int = 2
@export var SPEED_SCALE: float = 2.0

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D


func _ready() -> void:
	
	# Get the non-component children of this node, unchild them and child them to the Bloc Mouvant
	for child in get_children():
		if (not child == path_follow_2d) and (not child == animatable_body_2d) and (not child == animation_player):
			remove_child(child)
			animatable_body_2d.add_child(child)
	
	# If LOOP is true, the Bloc Mouvant will loop. Otherwise, it will only move once
	if LOOP == true:
		animation_player.speed_scale = SPEED_SCALE
		animation_player.play("move")
		set_process(false)


func _process(delta: float) -> void:
	
	path_follow_2d.progress += SPEED * delta
