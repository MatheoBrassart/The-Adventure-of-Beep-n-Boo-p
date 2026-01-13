extends StaticBody2D

# Defines the size of the bloc. 0 = small, 1 = medium, 2 = large
@export var BLOC_SIZE = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var incoming_fall_timer: Timer = $IncomingFallTimer
@onready var idle_shake_cooldown_timer: Timer = $IdleShakeCooldownTimer
@onready var reconstruction_cooldown_timer: Timer = $ReconstructionCooldownTimer


var SHOULD_BE_SHAKING: bool = false
var SHAKE_POWER = 0.1
var BIG_SHAKE_RANGE = 3
var SMALL_SHAKE_RANGE = 1.5

var UNRESPAWNED:bool = false
var SHOULD_RESPAWN: bool = false
var WILL_RESPAWN:bool = false


func _ready() -> void:
	
	if BLOC_SIZE == 1:
		self.scale.x = 2


func _process(_delta: float) -> void:
	
	if SHOULD_BE_SHAKING == true:
		sprite_2d.position = Vector2(randf_range(-BIG_SHAKE_RANGE, BIG_SHAKE_RANGE), randf_range(-BIG_SHAKE_RANGE, BIG_SHAKE_RANGE))
	
	if WILL_RESPAWN == true:
		sprite_2d.visible = true
		collision_shape_2d.disabled = false
		area_2d.visible = true
		UNRESPAWNED = false
		SHOULD_RESPAWN = false
		WILL_RESPAWN = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		SHOULD_BE_SHAKING = true
		incoming_fall_timer.start()


func _on_incoming_fall_timer_timeout() -> void:
	
	SHOULD_BE_SHAKING = false
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	area_2d.visible = false
	UNRESPAWNED = true
	reconstruction_cooldown_timer.start()


func _on_idle_shake_cooldown_timer_timeout() -> void:
	
	if SHOULD_BE_SHAKING == false:
		sprite_2d.position = Vector2(randf_range(-SMALL_SHAKE_RANGE, SMALL_SHAKE_RANGE), randf_range(-SMALL_SHAKE_RANGE, SMALL_SHAKE_RANGE))


func _on_reconstruction_cooldown_timer_timeout() -> void:
	
	if SHOULD_RESPAWN == true:
		WILL_RESPAWN = true
