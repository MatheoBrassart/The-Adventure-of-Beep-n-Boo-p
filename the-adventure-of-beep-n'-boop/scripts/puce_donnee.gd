extends Area2D

@onready var gameInformations = get_tree().get_first_node_in_group("GameInformations")

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Indicates to which world the puce is for
@export var WHICH_WORLD = "0"
# Indicates which number the puce is in this world
@export var WHICH_NUMBER = 0


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		collision_shape_2d.set_deferred("disabled", true)
		animation_player.play("obtained")
