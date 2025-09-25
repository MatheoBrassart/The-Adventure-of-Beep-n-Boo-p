extends Area2D

class_name PicsChange

# Defines which character these pics are for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

@onready var spritePicsChangeBeep: Sprite2D = $Sprite2DPicsChangeBeep
@onready var spritePicsChangeBoop: Sprite2D = $Sprite2DPicsChangeBoop
@onready var rightSprite: Sprite2D = $Sprite2DPicsChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		spritePicsChangeBoop.visible = false
		rightSprite = spritePicsChangeBeep
	else:
		spritePicsChangeBeep.visible = false
		rightSprite = spritePicsChangeBoop
	
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
	
	ISACTIVE = 1
	rightSprite.modulate = Color(1.0, 1.0, 1.0, 1)
	collisionShape2D.disabled = false


func deactivate():
	
	ISACTIVE = 0
	rightSprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	collisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		body.player_death()
