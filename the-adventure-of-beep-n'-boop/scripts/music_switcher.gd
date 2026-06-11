extends Node2D

@export var WHICHMUSIC: String


func _ready() -> void:
	
	MusicPlayer.play_music(WHICHMUSIC)
