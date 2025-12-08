extends Area2D


# Defines which character these pics are for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

# Animations
@onready var animatedSpritePicsChangeBeep: Sprite2D = $AnimatedSprite2DScieChangeBeep
@onready var animatedSpritePicsChangeBoop: Sprite2D = $AnimatedSprite2DScieChangeBoop
@onready var rightSprite: Sprite2D = $AnimatedSprite2DScieChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		animatedSpritePicsChangeBoop.visible = false
		rightSprite = animatedSpritePicsChangeBeep
	else:
		animatedSpritePicsChangeBeep.visible = false
		rightSprite = animatedSpritePicsChangeBoop
	
	# When appearing, check if the right character is active or not
	var CURRENT_ACTIVE_CHARACTER = get_tree().get_first_node_in_group("Player")
	if not CURRENT_ACTIVE_CHARACTER.CURRENT_ACTIVE_CHARACTER == WHICH_CHARACTER_IS_IT:
		deactivate()
		# rightSprite.play("defaultInactive")
	# else:
		# rightSprite.play("defaultActive")


func _process(_delta: float) -> void:
	
	pass


func switch_state():
	
	# Called by game_informations
	if ISACTIVE == 0:
		activate()
	else:
		deactivate()


func activate():
	
	# Activates the scie
	ISACTIVE = 1
	# rightSprite.play("activating")
	if WHICH_CHARACTER_IS_IT == 0:
		rightSprite.modulate = Color(1.0, 0.579, 0.515, 1.0)
	else:
		rightSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	collisionShape2D.disabled = false


func deactivate():
	
	# Dectivates the scie
	ISACTIVE = 0
	# rightSprite.play("deactivating")
	if WHICH_CHARACTER_IS_IT == 0:
		rightSprite.modulate = Color(1.0, 0.579, 0.515, 0.5)
	else:
		rightSprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	collisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	
	# Kills the player when they touch it
	if body.is_in_group("Player") == true:
		body.player_death.call_deferred()
