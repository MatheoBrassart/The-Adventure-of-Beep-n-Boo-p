extends Area2D

var PLAYER: Node2D = null
var IS_PLAYER_IN: bool = false

@export var WIND_POWER = 0
var MAX_PUSH = null


func _ready() -> void:
	
	MAX_PUSH = WIND_POWER * 10


func _process(delta: float) -> void:
	
	if IS_PLAYER_IN == true:
		if round(self.rotation_degrees) == 0:
			if PLAYER.velocity.y > MAX_PUSH * -1:
				PLAYER.velocity.y = PLAYER.velocity.y + (WIND_POWER * -1)
		elif round(self.rotation_degrees) == 90:
			if PLAYER.velocity.x < MAX_PUSH:
				PLAYER.velocity.x = PLAYER.velocity.x + WIND_POWER
		elif round(self.rotation_degrees) == -90:
			if PLAYER.velocity.x > MAX_PUSH * -1:
				PLAYER.velocity.x = PLAYER.velocity.x + (WIND_POWER * -1)


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") == true:
		PLAYER = body
		IS_PLAYER_IN = true


func _on_body_exited(body: Node2D) -> void:
	
	if body == PLAYER:
		IS_PLAYER_IN = false
