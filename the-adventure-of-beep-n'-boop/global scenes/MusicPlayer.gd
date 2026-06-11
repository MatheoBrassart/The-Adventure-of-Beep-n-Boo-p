extends Node

@onready var atelier_audio_stream_player: AudioStreamPlayer = $AtelierAudioStreamPlayer
@onready var ville_en_ruine_audio_stream_player: AudioStreamPlayer = $VilleEnRuineAudioStreamPlayer
@onready var plaines_venteuses_audio_stream_player: AudioStreamPlayer = $PlainesVenteusesAudioStreamPlayer
@onready var ville_securisee_audio_stream_player: AudioStreamPlayer = $VilleSecuriseeAudioStreamPlayer

var CURRENTMUSIC: AudioStreamPlayer


func play_music(which: String):
	
	
	match which:
		"atelier":
			if CURRENTMUSIC == atelier_audio_stream_player:
				return
			if not CURRENTMUSIC == null:
				CURRENTMUSIC.stop()
			CURRENTMUSIC = atelier_audio_stream_player
		"villeenruine":
			if CURRENTMUSIC == ville_en_ruine_audio_stream_player:
				return
			if not CURRENTMUSIC == null:
				CURRENTMUSIC.stop()
			CURRENTMUSIC = ville_en_ruine_audio_stream_player
		"plainesventeuses":
			if CURRENTMUSIC == plaines_venteuses_audio_stream_player:
				return
			if not CURRENTMUSIC == null:
				CURRENTMUSIC.stop()
			CURRENTMUSIC = plaines_venteuses_audio_stream_player
		"villesecurisee":
			if CURRENTMUSIC == ville_securisee_audio_stream_player:
				return
			if not CURRENTMUSIC == null:
				CURRENTMUSIC.stop()
			CURRENTMUSIC = ville_securisee_audio_stream_player
	
	CURRENTMUSIC.play()


func _on_atelier_audio_stream_player_finished() -> void:
	
	CURRENTMUSIC.play()


func _on_ville_en_ruine_audio_stream_player_finished() -> void:
	
	CURRENTMUSIC.play()


func _on_plaines_venteuses_audio_stream_player_finished() -> void:
	
	CURRENTMUSIC.play()


func _on_ville_securisee_audio_stream_player_finished() -> void:
	
	CURRENTMUSIC.play()
