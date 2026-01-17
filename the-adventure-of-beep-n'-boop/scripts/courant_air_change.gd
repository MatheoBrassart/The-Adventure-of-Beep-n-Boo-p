extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0
var CURRENT_WIND_DIRECTION = 0

@export var WIND_POWER = 0
var MAX_PUSH = null


func _ready() -> void:
	
	MAX_PUSH = WIND_POWER * 10
	
	# When appearing, check if the right character is active or not
	var CURRENT_ACTIVE_CHARACTER = get_tree().get_first_node_in_group("Player")
	if not CURRENT_ACTIVE_CHARACTER.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		CURRENT_WIND_DIRECTION = 1



func _process(_delta: float) -> void:
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		if collider is Node:
			if collider.is_in_group("Player"):
				
				if CURRENT_WIND_DIRECTION == 0:
					airblow_forward(collider)
				else:
					airblow_backward(collider)


func airblow_forward(collider: Node2D):
	
	# the air blows forward
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

func airblow_backward(collider: Node2D):
	
	# the air blows backward
	if round(self.rotation_degrees) == 0:
		if collider.velocity.y > MAX_PUSH:
			collider.velocity.y = collider.velocity.y + WIND_POWER
				
	elif round(self.rotation_degrees) == 90:
		if collider.velocity.x > MAX_PUSH * 1:
			collider.WIND_POWER = WIND_POWER
			collider.WIND_DIRECTION = -1
	elif round(self.rotation_degrees) == -90:
		if collider.velocity.x < MAX_PUSH:
			collider.WIND_POWER = WIND_POWER
			collider.WIND_DIRECTION = 1


func change_wind_direction():
	if CURRENT_WIND_DIRECTION == 0:
		CURRENT_WIND_DIRECTION = 1
	else:
		CURRENT_WIND_DIRECTION = 0
