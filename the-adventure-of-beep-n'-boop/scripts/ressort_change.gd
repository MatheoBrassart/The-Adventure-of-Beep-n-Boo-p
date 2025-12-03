extends Area2D

class_name RessortChange

# Defines which character the ressort is for. 0 = Beep, 1 = Boop
@export var WHICH_CHARACTER_IS_IT = 0

# Power of the ressort
const RESSORT_VELOCITY = 900.0

# Animations
@onready var animatedSpriteRessortChangeBeep: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBeep
@onready var animatedSpriteRessortChangeBoop: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBoop
@onready var rightSprite: AnimatedSprite2D = $AnimatedSprite2DRessortChangeBeep
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

@onready var ressortChange2D: Area2D = $"."

# Defines the direction of the ressort. 1 = up, 2 = down, 3 = left, 4 = right
@export var RESSORT_DIRECTION = 1

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
	
	# Activates the ressort
	ISACTIVE = 1
	rightSprite.play("activating")
	collisionShape2D.disabled = false


func deactivate():
	
	# Deactivates the bloc
	ISACTIVE = 0
	rightSprite.play("deactivating")
	collisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	
	# Bounce the player when it touches it. Direction depends on its rotation.
	if body.is_in_group("Player") == true:
		rightSprite.play("used")
		if (RESSORT_DIRECTION == 3) || (RESSORT_DIRECTION == 4):
			print("a")
			body.hit_ressort(true)
		else:
			body.hit_ressort(false)
		if RESSORT_DIRECTION == 1:
			body.velocity.y = RESSORT_VELOCITY * -1
		elif RESSORT_DIRECTION == 3:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY, RESSORT_VELOCITY )
		elif RESSORT_DIRECTION == 4:
			body.velocity.x = move_toward(body.velocity.x, RESSORT_VELOCITY * -1, RESSORT_VELOCITY)
