extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

@export var LOOP: bool = true
@export var NONLOOP_SPEED: float = 100.0
@export var LOOP_SPEED: float = 2.0

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var line_2d: Line2D = $Line2D

# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0
var ISMOVEMENT_PAUSED = 0

func _ready() -> void:
	
	# Get the non-component children of this node, unchild them and child them to the Bloc Mouvant
	for child in get_children():
		if (not child == path_follow_2d) and (not child == animatable_body_2d) and (not child == animation_player) and (not child == line_2d):
			remove_child(child)
			animatable_body_2d.add_child(child)
	
	for i in self.curve.point_count:
		line_2d.add_point(self.curve.get_point_position(i))
	
	# If LOOP is true, the Bloc Mouvant will loop. Otherwise, it will only move once
	if LOOP == true:
		animation_player.speed_scale = LOOP_SPEED
		animation_player.play("move")
		set_process(false)
	
	# When appearing, check if the right character is active or not
	if not player.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		pause_unpause_movement()


func _process(delta: float) -> void:
	
	path_follow_2d.progress += NONLOOP_SPEED * delta


func pause_unpause_movement():
	
	if ISMOVEMENT_PAUSED == 0:
		animation_player.speed_scale = 0
		ISMOVEMENT_PAUSED = 1
	else:
		animation_player.speed_scale = LOOP_SPEED
		ISMOVEMENT_PAUSED = 0
