extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

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
						collider.WIND_POWER = WIND_POWER
						collider.WIND_DIRECTION = 1
				elif round(self.rotation_degrees) == -90:
					if collider.velocity.x > MAX_PUSH * -1:
						collider.WIND_POWER = WIND_POWER
						collider.WIND_DIRECTION = -1
