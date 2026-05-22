extends Node2D

@onready var player: Player = $".."

@onready var walking_gpu_particles_2d: GPUParticles2D = $WalkingGPUParticles2D

@onready var jumpfall_particles = preload("res://particles/player_jump_fall_particles.tscn")
@onready var particle_jumpfall_cooldown: Timer = $ParticleJumpfallCooldown

func _process(_delta: float) -> void:
	
	if player.is_on_floor():
		if player.direction_x == 0:
			walking_gpu_particles_2d.emitting = false
		else:
			walking_gpu_particles_2d.emitting = true
	else:
		walking_gpu_particles_2d.emitting = false
		if player.velocity.y < 0:
			pass
		else:
			pass


func jumpfall_particles_instantiate():
	
	if particle_jumpfall_cooldown.is_stopped():
		particle_jumpfall_cooldown.start()
		var instance = jumpfall_particles.instantiate()
		add_child(instance)
