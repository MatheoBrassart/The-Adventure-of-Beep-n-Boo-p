extends Camera2D

@onready var change_moi_camera_effect_beep_1: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBeep1
@onready var change_moi_camera_effect_beep_2: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBeep2
@onready var change_moi_camera_effect_beep_3: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBeep3
@onready var change_moi_camera_effect_beep_4: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBeep4
@onready var change_moi_camera_effect_boop_1: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBoop1
@onready var change_moi_camera_effect_boop_2: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBoop2
@onready var change_moi_camera_effect_boop_3: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBoop3
@onready var change_moi_camera_effect_boop_4: AnimatedSprite2D = $CanvasLayer/ChangeMoiCameraEffectBoop4

# ----- Camera-related variables
var CAMERA_SHAKERANDOMSTRENGTH: float = 10.0
var CAMERA_SHAKEFADE: float = 10.0
var CAMERA_SHAKERNG = RandomNumberGenerator.new()
var CAMERA_SHAKESTRENGTH: float = 0.0


func _process(delta: float) -> void:
	
	shake_camera(delta)


func apply_camerashake():
	
	CAMERA_SHAKESTRENGTH = CAMERA_SHAKERANDOMSTRENGTH


func shake_camera(delta: float):
	
	if CAMERA_SHAKESTRENGTH > 0:
		CAMERA_SHAKESTRENGTH = lerpf(CAMERA_SHAKESTRENGTH, 0, CAMERA_SHAKEFADE * delta)
		
		var camera = get_viewport().get_camera_2d()
		camera.offset = shake_camera_randomoffset()

func shake_camera_randomoffset() -> Vector2:
	
	return Vector2(CAMERA_SHAKERNG.randf_range(-CAMERA_SHAKESTRENGTH, CAMERA_SHAKESTRENGTH), CAMERA_SHAKERNG.randf_range(-CAMERA_SHAKESTRENGTH, CAMERA_SHAKESTRENGTH))


func activate_switch_animation(character: int):
	
	if character == 0:
		change_moi_camera_effect_beep_1.visible = true
		change_moi_camera_effect_beep_2.visible = true
		change_moi_camera_effect_beep_3.visible = true
		change_moi_camera_effect_beep_4.visible = true
		change_moi_camera_effect_boop_1.visible = false
		change_moi_camera_effect_boop_2.visible = false
		change_moi_camera_effect_boop_3.visible = false
		change_moi_camera_effect_boop_4.visible = false
		change_moi_camera_effect_beep_1.play("activate")
		change_moi_camera_effect_beep_2.play("activate")
		change_moi_camera_effect_beep_3.play("activate")
		change_moi_camera_effect_beep_4.play("activate")
	else:
		change_moi_camera_effect_beep_1.visible = false
		change_moi_camera_effect_beep_2.visible = false
		change_moi_camera_effect_beep_3.visible = false
		change_moi_camera_effect_beep_4.visible = false
		change_moi_camera_effect_boop_1.visible = true
		change_moi_camera_effect_boop_2.visible = true
		change_moi_camera_effect_boop_3.visible = true
		change_moi_camera_effect_boop_4.visible = true
		change_moi_camera_effect_boop_1.play("activate")
		change_moi_camera_effect_boop_2.play("activate")
		change_moi_camera_effect_boop_3.play("activate")
		change_moi_camera_effect_boop_4.play("activate")
