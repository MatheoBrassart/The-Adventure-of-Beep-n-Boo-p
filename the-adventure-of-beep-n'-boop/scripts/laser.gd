extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var line_2d: Line2D = $Line2D
@onready var shape_cast_2d_line_2d_setter: ShapeCast2D = $ShapeCast2DLine2DSetter

var new_point_clip_setter = null


func _process(_delta: float) -> void:
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		if collider is Node:
			if collider.is_in_group("Player"):
				
				collider.player_death.call_deferred()
	
	set_laser_size()


func set_laser_size():
	
	if shape_cast_2d_line_2d_setter.is_colliding():
		var collider = shape_cast_2d_line_2d_setter.get_collider(0)
		if collider is Node:
			new_point_clip_setter = line_2d.to_local(shape_cast_2d_line_2d_setter.get_collision_point(0))
			line_2d.set_point_position(1, Vector2(0, new_point_clip_setter.y))
	else:
		line_2d.set_point_position(1, Vector2(0, -1312))
