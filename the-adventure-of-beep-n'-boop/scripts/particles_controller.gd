extends Node2D

@onready var player: Player = $".."

@onready var walking_gpu_particles_2d: GPUParticles2D = $WalkingGPUParticles2D
@onready var jump_fall_left_gpu_particles_2d: GPUParticles2D = $JumpFallLeftGPUParticles2D
@onready var jump_fall_right_gpu_particles_2d: GPUParticles2D = $JumpFallRightGPUParticles2D

func _process(delta: float) -> void:
	
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


func jumpfall_particles():
	
	jump_fall_left_gpu_particles_2d.restart()
	jump_fall_right_gpu_particles_2d.restart()
	
	jump_fall_left_gpu_particles_2d.emitting = true
	jump_fall_right_gpu_particles_2d.emitting = true
