extends StaticBody2D

class_name BlocChange

# Defines which character this bloc is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

@onready var animatedSpriteBlocChangeBeep: AnimatedSprite2D = $AnimatedSprite2DBlocChangeBeep
@onready var animatedSpriteBlocChangeBoop: AnimatedSprite2D = $AnimatedSprite2DBlocChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DBlocChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		animatedSpriteBlocChangeBoop.visible = false
		rightSprite = animatedSpriteBlocChangeBeep
	else:
		animatedSpriteBlocChangeBeep.visible = false
		rightSprite = animatedSpriteBlocChangeBoop
	
	# When appearing, check if the right character is active or not
	var CURRENT_ACTIVE_CHARACTER = get_parent().get_node("Player")
	if not CURRENT_ACTIVE_CHARACTER.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		deactivate()
		rightSprite.play("defaultInactive")
	else:
		rightSprite.play("defaultActive")


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
	rightSprite.play("activating")
	collisionShape2D.disabled = false

func deactivate():
	
	# Deactivates the bloc
	ISACTIVE = 0
	rightSprite.play("deactivating")
	collisionShape2D.disabled = true
	
