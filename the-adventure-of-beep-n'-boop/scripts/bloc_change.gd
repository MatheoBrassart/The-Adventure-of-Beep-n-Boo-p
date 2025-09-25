extends StaticBody2D

class_name BlocChange

# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

@onready var spriteBlocChangeBeep: Sprite2D = $Sprite2DBlocChangeBeep
@onready var spriteBlocChangeBoop: Sprite2D = $Sprite2DBlocChangeBoop
@onready var rightSprite: Sprite2D = $Sprite2DBlocChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		spriteBlocChangeBoop.visible = false
		rightSprite = spriteBlocChangeBeep
	else:
		spriteBlocChangeBeep.visible = false
		rightSprite = spriteBlocChangeBoop
	
	# When appearing, check if the right character is active or not
	var CURRENT_ACTIVE_CHARACTER = get_parent().get_node("Player")
	if not CURRENT_ACTIVE_CHARACTER.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		deactivate()


func _process(_delta: float) -> void:
	
	pass


func switch_state():
	
	# Called by game_informations
	if ISACTIVE == 0:
		activate()
	else:
		deactivate()


func activate():
	
	# Activates the bloc
	ISACTIVE = 1
	rightSprite.modulate = Color(1.0, 1.0, 1.0, 1)
	collisionShape2D.disabled = false

func deactivate():
	
	# Deactivates the bloc
	ISACTIVE = 0
	rightSprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	collisionShape2D.disabled = true
	
