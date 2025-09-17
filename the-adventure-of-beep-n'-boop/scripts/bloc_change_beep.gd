extends StaticBody2D

class_name BlocChangeBeep

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D



var ISACTIVE = 1
static var SWITCH_STATE = 0

func _ready() -> void:
	
	var CURRENT_ACTIVE_CHARACTER = get_parent().get_node("Player")
	
	if CURRENT_ACTIVE_CHARACTER.CURRENT_CHARACTER == 1:
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
	sprite2D.modulate = Color(1.0, 0.733, 0.627, 1)
	collisionShape2D.disabled = false

func deactivate():
	
	ISACTIVE = 0
	sprite2D.modulate = Color(1.0, 0.733, 0.627, 0.5)
	collisionShape2D.disabled = true
	
