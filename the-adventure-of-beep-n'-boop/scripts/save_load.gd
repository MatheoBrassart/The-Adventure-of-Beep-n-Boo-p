extends Node

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"test": 1
}


func _ready() -> void:
	_load()


func _save():
	
	var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "SnooPINGAS")
	file.store_var(contents_to_save.duplicate())
	file.close()


func _load():
	
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ, "SnooPINGAS")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.test = save_data.test
