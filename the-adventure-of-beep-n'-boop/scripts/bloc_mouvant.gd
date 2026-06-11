extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

@export var LOOP: bool = true
@export var LOOP_SPEED: float = 2.0

@export var BLOC_SCALEX = 1
@export var BLOC_SCALEY = 1

@export var ORIGINALBLOC_ON = true

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var line_2d: Line2D = $Line2D

@onready var body_animated_sprite_2d: AnimatedSprite2D = $AnimatableBody2D/BodyAnimatedSprite2D

@onready var hover_animated_sprite_2d_beep: AnimatedSprite2D = $AnimatableBody2D/HoverAnimatedSprite2DBeep
@onready var hover_animated_sprite_2d_boop: AnimatedSprite2D = $AnimatableBody2D/HoverAnimatedSprite2DBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatableBody2D/HoverAnimatedSprite2DBeep

@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var sprite_2d_noloop_stopper: Sprite2D = $Sprite2DNoloopStopper
@onready var noloop_animation_player: AnimationPlayer = $NoloopAnimationPlayer

@onready var moving_audio_stream_player: AudioStreamPlayer = $MovingAudioStreamPlayer
@onready var stopping_audio_stream_player: AudioStreamPlayer = $StoppingAudioStreamPlayer


# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0
var ISMOVEMENT_PAUSED = 0

var CAN_BESTOPPED = true

var WAS_SOUNDSTOPPINGPLAYED = false

func _ready() -> void:
	
	body_animated_sprite_2d.scale.x = body_animated_sprite_2d.scale.x * BLOC_SCALEX
	body_animated_sprite_2d.scale.y = body_animated_sprite_2d.scale.y * BLOC_SCALEY
	collision_shape_2d.scale.x = collision_shape_2d.scale.x * BLOC_SCALEX
	collision_shape_2d.scale.y = collision_shape_2d.scale.y * BLOC_SCALEY
	
	if ORIGINALBLOC_ON == false:
		body_animated_sprite_2d.visible = false
		hover_animated_sprite_2d_beep.visible = false
		line_2d.visible = false
		collision_shape_2d.disabled = true
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		hover_animated_sprite_2d_boop.visible = false
		rightSprite = hover_animated_sprite_2d_beep
	else:
		hover_animated_sprite_2d_beep.visible = false
		rightSprite = hover_animated_sprite_2d_boop
	
	# Base animations
	body_animated_sprite_2d.play("idle")
	rightSprite.play("inactive")
	
	# Get the non-component children of this node, unchild them and child them to the Bloc Mouvant
	for child in get_children():
		if (not child == path_follow_2d) and (not child == animatable_body_2d) and (not child == animation_player) and (not child == line_2d) and (not child == sprite_2d_noloop_stopper) and (not child == noloop_animation_player):
			remove_child(child)
			animatable_body_2d.add_child(child)
			if child.is_in_group("ProjecteurCCA"):
				CAN_BESTOPPED = false
	
	for i in self.curve.point_count:
		line_2d.add_point(self.curve.get_point_position(i))
	
	# If LOOP is true, the Bloc Mouvant will loop. Otherwise, it will only move once
	if LOOP == true:
		animation_player.speed_scale = LOOP_SPEED
		animation_player.play("move")
	else:
		animation_player.speed_scale = LOOP_SPEED
		animation_player.play("move_noloop")
	
	# When appearing, check if the right character is active or not
	if not player.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		pause_unpause_movement()
	else:
		rightSprite.play("active")
		if CAN_BESTOPPED == true:
			moving_audio_stream_player.play()
	
	# If LOOP is false, put the noloopstopper at the end of the line, otherwise hide it
	if LOOP == false:
		var lastPoint = (line_2d.get_point_count() - 1)
		sprite_2d_noloop_stopper.position = Vector2((line_2d.get_point_position(lastPoint).x), (line_2d.get_point_position(lastPoint).y))
	else:
		sprite_2d_noloop_stopper.visible = false


func _process(delta: float) -> void:
	
	if (path_follow_2d.progress_ratio == 1.0) and (LOOP == false) and (WAS_SOUNDSTOPPINGPLAYED == false):
		noloop_animation_player.play("stop")
		print(noloop_animation_player.is_playing())
		stopping_audio_stream_player.play()
		moving_audio_stream_player.pitch_scale = 0.5
		WAS_SOUNDSTOPPINGPLAYED = true


func pause_unpause_movement():
	
	if CAN_BESTOPPED == true:
		if ISMOVEMENT_PAUSED == 0:
			animation_player.speed_scale = 0
			body_animated_sprite_2d.play("idle")
			rightSprite.play("inactive")
			moving_audio_stream_player.stop()
			ISMOVEMENT_PAUSED = 1
		else:
			animation_player.speed_scale = LOOP_SPEED
			body_animated_sprite_2d.play("active")
			rightSprite.play("active")
			moving_audio_stream_player.play()
			ISMOVEMENT_PAUSED = 0


func _on_moving_audio_stream_player_finished() -> void:
	
	moving_audio_stream_player.play()
