extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var line_2d_particle_clipper: Line2D = $Line2DParticleClipper
@onready var gpu_particles_2d: GPUParticles2D = $Line2DParticleClipper/GPUParticles2D
@onready var shape_cast_2d_particles_setter: ShapeCast2D = $ShapeCast2DParticlesSetter

@export var WIND_POWER = 0
var MAX_PUSH = null

var PLAYER_HASBEENSTOPPED: bool = false

var new_point_clip_setter = null


func _ready() -> void:
	
	MAX_PUSH = WIND_POWER * 10
	
	gpu_particles_2d.amount = int(gpu_particles_2d.amount * self.transform.get_scale().x)


func _process(_delta: float) -> void:
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		if collider is Node:
			if collider.is_in_group("Player"):
				match round(self.rotation_degrees):
					0.0:
						if collider.velocity.y > MAX_PUSH * -1:
							collider.velocity.y = collider.velocity.y + (WIND_POWER * -1)
					90.0:
						collider.WIND_POWER = WIND_POWER
						collider.WIND_DIRECTION = 1
						if PLAYER_HASBEENSTOPPED == false:
							collider.velocity.x = 0
							collider.velocity.x = move_toward(0, (WIND_POWER * (round(self.rotation_degrees) / 90) * 2.8), 100000)
							PLAYER_HASBEENSTOPPED = true
					-90.0:
						collider.WIND_POWER = WIND_POWER
						collider.WIND_DIRECTION = -1
						if PLAYER_HASBEENSTOPPED == false:
							collider.velocity.x = 0
							collider.velocity.x = move_toward(0, (WIND_POWER * (round(self.rotation_degrees) / 90) * 2.8), 100000)
							PLAYER_HASBEENSTOPPED = true
			else:
				PLAYER_HASBEENSTOPPED = false
		else:
			PLAYER_HASBEENSTOPPED = false
	else:
		PLAYER_HASBEENSTOPPED = false
	
	set_particle_mask_size()


func set_particle_mask_size():
	
	if shape_cast_2d_particles_setter.is_colliding():
		var collider = shape_cast_2d_particles_setter.get_collider(0)
		if collider is Node:
			new_point_clip_setter = line_2d_particle_clipper.to_local(shape_cast_2d_particles_setter.get_collision_point(0))
			line_2d_particle_clipper.set_point_position(1, Vector2(0, new_point_clip_setter.y))
	else:
		line_2d_particle_clipper.set_point_position(1, Vector2(0, -1312))
