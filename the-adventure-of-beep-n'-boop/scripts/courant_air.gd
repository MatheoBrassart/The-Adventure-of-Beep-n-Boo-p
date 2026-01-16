extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

var PLAYER: Node2D = null
var IS_PLAYER_IN: bool = false

@export var WIND_POWER = 0
var MAX_PUSH = null


func _ready() -> void:
	
	MAX_PUSH = WIND_POWER * 10


func _process(_delta: float) -> void:
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		if collider is Node:
			if collider.is_in_group("Player"):
				if round(self.rotation_degrees) == 0:
					if collider.velocity.y > MAX_PUSH * -1:
						collider.velocity.y = collider.velocity.y + (WIND_POWER * -1)
				elif round(self.rotation_degrees) == 90:
					if collider.velocity.x < MAX_PUSH:
						collider.velocity.x = collider.velocity.x + WIND_POWER
				elif round(self.rotation_degrees) == -90:
					if collider.velocity.x > MAX_PUSH * -1:
						collider.velocity.x = collider.velocity.x + (WIND_POWER * -1)
