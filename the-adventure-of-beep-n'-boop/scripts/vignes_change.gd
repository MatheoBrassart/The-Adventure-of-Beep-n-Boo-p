extends Area2D

# Defines which character this vignes is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

# Animations
@onready var animatedSpriteVignesChangeBeep: Sprite2D = $AnimatedSprite2DVignesChangeBeep
@onready var animatedSpriteVignesChangeBoop: Sprite2D = $AnimatedSprite2DVignesChangeBoop
@onready var rightSprite: Sprite2D = $AnimatedSprite2DVignesChangeBeep
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		animatedSpriteVignesChangeBoop.visible = false
		rightSprite = animatedSpriteVignesChangeBeep
	else:
		animatedSpriteVignesChangeBeep.visible = false
		rightSprite = animatedSpriteVignesChangeBoop
	
	# When appearing, check if the right character is active or not
	var CURRENT_ACTIVE_CHARACTER = get_tree().get_first_node_in_group("Player")
	if not CURRENT_ACTIVE_CHARACTER.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		deactivate()
		# rightSprite.play("defaultInactive")
	else:
		pass
		# rightSprite.play("defaultActive")


func switch_state():
	
	# Called by game_informations
	if ISACTIVE == 0:
		activate()
	else:
		deactivate()


func activate():
	
	# Activates the bloc
	ISACTIVE = 1
	if WHICH_CHARACTER_IS_IT == 0:
		rightSprite.modulate = Color(1.0, 0.392, 0.373, 1.0)
	else:
		rightSprite.modulate = Color(1.0, 1, 1, 1.0)
	collision_shape_2d.disabled = false

func deactivate():
	
	# Deactivates the bloc
	ISACTIVE = 0
	if WHICH_CHARACTER_IS_IT == 0:
		rightSprite.modulate = Color(1.0, 0.392, 0.373, 0.5)
	else:
		rightSprite.modulate = Color(1.0, 1, 1, 0.5)
	collision_shape_2d.disabled = true
	
