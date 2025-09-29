extends Area2D

class_name PicsChange

# Defines which character these pics are for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

@onready var animatedSpritePicsChangeBeep: AnimatedSprite2D = $AnimatedSprite2DPicsChangeBeep
@onready var animatedSpritePicsChangeBoop: AnimatedSprite2D = $AnimatedSprite2DPicsChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DPicsChangeBeep
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
	
	ISACTIVE = 1
	rightSprite.play("activating")
	collisionShape2D.disabled = false


func deactivate():
	
	ISACTIVE = 0
	rightSprite.play("deactivating")
	collisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		body.player_death()
