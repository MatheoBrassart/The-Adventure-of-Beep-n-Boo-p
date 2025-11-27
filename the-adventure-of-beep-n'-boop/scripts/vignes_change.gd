extends Area2D

# Defines which character this vignes is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

# Animations
@onready var animatedSpriteVignesChangeBeep: AnimatedSprite2D = $AnimatedSprite2DVignesChangeBeep
@onready var animatedSpriteVignesChangeBoop: AnimatedSprite2D = $AnimatedSprite2DVignesChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DVignesChangeBeep
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
		rightSprite.play("defaultInactive")
	else:
		rightSprite.play("defaultActive")


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
	collision_shape_2d.disabled = false

func deactivate():
	
	# Deactivates the bloc
	ISACTIVE = 0
	rightSprite.play("deactivating")
	collision_shape_2d.disabled = true
