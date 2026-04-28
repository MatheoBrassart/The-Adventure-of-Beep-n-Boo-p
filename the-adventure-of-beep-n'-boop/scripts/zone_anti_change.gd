extends Area2D

@onready var body_animated_sprite_2d: AnimatedSprite2D = $BodyAnimatedSprite2D

@onready var top_area_2d: Area2D = $TopArea2D
@onready var bottom_area_2d: Area2D = $BottomArea2D
@onready var left_area_2d: Area2D = $LeftArea2D
@onready var right_area_2d: Area2D = $RightArea2D

var WZONE_TOP = 0
var WZONE_BOTTOM = 0
var WZONE_LEFT = 0
var WZONE_RIGHT = 0

var WZONE_ARRAY: Array
var RIGHTANIMATION_SET = false


func _ready() -> void:
	
	# Play the right animation based on connections
	body_animated_sprite_2d.play("WN")


func _process(delta: float) -> void:
	
	if RIGHTANIMATION_SET == false:
		
		WZONE_ARRAY = [WZONE_TOP, WZONE_BOTTOM, WZONE_LEFT, WZONE_RIGHT]
		
		match WZONE_ARRAY:
			[0, 0, 0, 0]:
				body_animated_sprite_2d.play("WN")
			[1, 0, 0, 0]:
				body_animated_sprite_2d.play("WT")
			[1, 1, 0, 0]:
				body_animated_sprite_2d.play("WTB")
			[1, 0, 1, 0]:
				body_animated_sprite_2d.play("WTL")
			[1, 0, 0, 1]:
				body_animated_sprite_2d.play("WTR")
			[1, 1, 1, 0]:
				body_animated_sprite_2d.play("WTBL")
			[1, 0, 1, 1]:
				body_animated_sprite_2d.play("WTLR")
			[1, 1, 0, 1]:
				body_animated_sprite_2d.play("WTBR")
			[1, 1, 1, 1]:
				body_animated_sprite_2d.play("WTBLR")
			[0, 1, 0, 0]:
				body_animated_sprite_2d.play("WB")
			[0, 0, 1, 0]:
				body_animated_sprite_2d.play("WL")
			[0, 0, 0, 1]:
				body_animated_sprite_2d.play("WR")
			[0, 1, 1, 0]:
				body_animated_sprite_2d.play("WBL")
			[0, 0, 1, 1]:
				body_animated_sprite_2d.play("WLR")
			[0, 1, 0, 1]:
				body_animated_sprite_2d.play("WBR")
			[0, 1, 1, 1]:
				body_animated_sprite_2d.play("WBLR")


func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player") == true:
		body.ISIN_ZONEANTICHANGE += 1


func _on_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		body.ISIN_ZONEANTICHANGE += -1


func _on_top_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("ZoneAntiChange") == true:
		WZONE_TOP = 1
		RIGHTANIMATION_SET = false


func _on_bottom_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("ZoneAntiChange") == true:
		WZONE_BOTTOM = 1
		RIGHTANIMATION_SET = false


func _on_left_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("ZoneAntiChange") == true:
		WZONE_LEFT = 1
		RIGHTANIMATION_SET = false


func _on_right_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("ZoneAntiChange") == true:
		WZONE_RIGHT = 1
		RIGHTANIMATION_SET = false
