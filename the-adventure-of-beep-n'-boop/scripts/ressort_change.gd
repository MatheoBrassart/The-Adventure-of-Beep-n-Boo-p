extends Area2D

class_name RessortChange

# Defines which character the ressort is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

const RESSORT_VELOCITY = 900.0

@onready var animatedSpriteRessortChangeBeep: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBeep
@onready var animatedSpriteRessortChangeBoop: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

@onready var ressortChange2D: Area2D = $"."

var ISACTIVE = 1

func _ready() -> void:
	
	# When appearing, hides the incorrect sprite and set the correct one as rightSprite
	if WHICH_CHARACTER_IS_IT == 0:
		animatedSpriteRessortChangeBoop.visible = false
		rightSprite = animatedSpriteRessortChangeBeep
	else:
		animatedSpriteRessortChangeBeep.visible = false
		rightSprite = animatedSpriteRessortChangeBoop
	
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
		rightSprite.play("used")
		if ressortChange2D.rotation_degrees == 0:
			body.velocity.y = RESSORT_VELOCITY * -1
		elif ressortChange2D.rotation_degrees == 90:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY, RESSORT_VELOCITY )
		elif ressortChange2D.rotation_degrees == -90:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY * -1, RESSORT_VELOCITY)
