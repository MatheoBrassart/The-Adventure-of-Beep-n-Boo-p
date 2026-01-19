extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var line_2d_particle_clipper: Line2D = $Line2DParticleClipper
@onready var gpu_particles_2d: GPUParticles2D = $Line2DParticleClipper/GPUParticles2D
@onready var shape_cast_2d_particles_setter: ShapeCast2D = $ShapeCast2DParticlesSetter

# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0
var CURRENT_WIND_DIRECTION = 0

@export var WIND_POWER = 0
var MAX_PUSH = null

var new_point_clip_setter = null


func _ready() -> void:
	
	MAX_PUSH = WIND_POWER * 10
	
	# When appearing, check if the right character is active or not
	if not player.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		CURRENT_WIND_DIRECTION = 1
	
	gpu_particles_2d.amount = int(gpu_particles_2d.amount * self.transform.get_scale().x)



func _process(_delta: float) -> void:
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		if collider is Node:
			if collider.is_in_group("Player"):
				
				if CURRENT_WIND_DIRECTION == 0:
					airblow_forward(collider)
				else:
					airblow_backward(collider)
	
	set_particle_mask_size()
	
	if CURRENT_WIND_DIRECTION == 1:
		gpu_particles_2d.position = line_2d_particle_clipper.get_point_position(1)


func airblow_forward(collider: Node2D):
	
	# the air blows forward
	if round(self.rotation_degrees) == 0:
		if collider.velocity.y > MAX_PUSH * -1:
			collider.velocity.y = collider.velocity.y + (WIND_POWER * -1)
				
	elif round(self.rotation_degrees) == 90:
		collider.WIND_POWER = WIND_POWER
		collider.WIND_DIRECTION = 1
	elif round(self.rotation_degrees) == -90:
		collider.WIND_POWER = WIND_POWER
		collider.WIND_DIRECTION = -1


func airblow_backward(collider: Node2D):
	
	# the air blows backward
	if round(self.rotation_degrees) == 0:
		if collider.velocity.y > MAX_PUSH:
			collider.velocity.y = collider.velocity.y + WIND_POWER
				
	elif round(self.rotation_degrees) == 90:
		collider.WIND_POWER = WIND_POWER
		collider.WIND_DIRECTION = -1
	elif round(self.rotation_degrees) == -90:
		collider.WIND_POWER = WIND_POWER
		collider.WIND_DIRECTION = 1


func change_wind_direction():
	
	gpu_particles_2d.visible = false
	gpu_particles_2d.amount += -1
	
	if CURRENT_WIND_DIRECTION == 0:
		CURRENT_WIND_DIRECTION = 1
		gpu_particles_2d.rotation_degrees = 180
	else:
		CURRENT_WIND_DIRECTION = 0
		gpu_particles_2d.rotation_degrees = 0
		gpu_particles_2d.position = Vector2(0, -32)
	
	gpu_particles_2d.visible = true
	gpu_particles_2d.amount += 1
	player.WIND_WASPLAYERSTOPPED = false


func set_particle_mask_size():
	
	if shape_cast_2d_particles_setter.is_colliding():
		var collider = shape_cast_2d_particles_setter.get_collider(0)
		if collider is Node:
			new_point_clip_setter = line_2d_particle_clipper.to_local(shape_cast_2d_particles_setter.get_collision_point(0))
			line_2d_particle_clipper.set_point_position(1, Vector2(0, new_point_clip_setter.y))
	else:
		line_2d_particle_clipper.set_point_position(1, Vector2(0, -1312))
