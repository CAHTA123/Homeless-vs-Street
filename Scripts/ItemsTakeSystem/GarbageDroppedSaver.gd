extends Node2D

class_name GarbageDroppFlagSaver

@export var container: GarbageContainer

@export_category("File preferences")

@export_group("File path")

@export var file_start_path: String = "user://garbage_drop_data"
@export var prefix: String = ".json"

@export_group("Keys and section")

@export_subgroup("Section")
@export var section: String = "Garbage"

@export_subgroup("Keys")
@export var drop_key: String = "Drop"

var file_path: String

var drop_file := ConfigFile.new()

func _ready():
	var self_node_path: String = str(container.get_index()) + container.name
	file_path = file_start_path + self_node_path + prefix
	
	
	
	if !get_available_file():
		save_drop_data()
		return
	load_drop_data()

func save_drop_data():
	print("2")
	drop_file.set_value(section, drop_key, container.get_dropped_mode())
	drop_file.save(file_path)

func load_drop_data():
	drop_file.load(file_path)
	var drop = drop_file.get_value(section, drop_key)
	
	if container:
		container.set_dropped_mode(drop)

func get_available_file(path: String = file_path) -> bool:
	if FileAccess.get_file_as_string(path):
		return true
	return false

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		print("!")
