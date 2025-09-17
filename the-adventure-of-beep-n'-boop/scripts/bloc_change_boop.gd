extends StaticBody2D

class_name BlocChangeBoop

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var CURRENT_ACTIVE_CHARACTER = 0

var ISACTIVE = 1
static var SWITCH_STATE = 0

func _ready() -> void:
	
	CURRENT_ACTIVE_CHARACTER = get_tree().get_root().get_node("player")
	if CURRENT_ACTIVE_CHARACTER == 0:
		deactivate()


func _process(_delta: float) -> void:
	
	if SWITCH_STATE == 1:
		SWITCH_STATE = 0
		if ISACTIVE == 0:
			activate()
		else:
			deactivate()


static func switch_state():
	
	SWITCH_STATE = 1


func activate():
	
	ISACTIVE = 1
	sprite2D.modulate = Color(1.0, 1.0, 1.0, 1)
	collisionShape2D.disabled = false

func deactivate():
	
	ISACTIVE = 0
	sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
	collisionShape2D.disabled = true
	
