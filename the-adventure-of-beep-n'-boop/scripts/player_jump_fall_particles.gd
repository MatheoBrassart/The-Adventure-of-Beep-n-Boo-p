extends Node2D

@onready var jump_fall_left_gpu_particles_2d: GPUParticles2D = $JumpFallLeftGPUParticles2D
@onready var jump_fall_right_gpu_particles_2d: GPUParticles2D = $JumpFallRightGPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	jump_fall_left_gpu_particles_2d.emitting = true
	jump_fall_right_gpu_particles_2d.emitting = true
