extends Area2D


# Defines which character these pics are for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

# Animations
@onready var animatedSpritePicsChangeBeep: AnimatedSprite2D = $AnimatedSprite2DScieChangeBeep
@onready var animatedSpritePicsChangeBoop: AnimatedSprite2D = $AnimatedSprite2DScieChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DScieChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1
var REPLAY_DEFAULTANIMATION = false

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
	
	# Activates the scie
	ISACTIVE = 1
	rightSprite.play("activating")
	collisionShape2D.disabled = false
	REPLAY_DEFAULTANIMATION = true


func deactivate():
	
	# Dectivates the scie
	ISACTIVE = 0
	rightSprite.play("deactivating")
	collisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	
	# Kills the player when they touch it
	if body.is_in_group("Player") == true:
		body.player_death.call_deferred()


func _on_animated_sprite_2d_scie_change_beep_animation_finished() -> void:
	
	if REPLAY_DEFAULTANIMATION == true:
		rightSprite.play("defaultActive")
		REPLAY_DEFAULTANIMATION = false


func _on_animated_sprite_2d_scie_change_boop_animation_finished() -> void:
	
	if REPLAY_DEFAULTANIMATION == true:
		rightSprite.play("defaultActive")
		REPLAY_DEFAULTANIMATION = false
