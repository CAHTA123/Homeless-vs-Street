extends Resource

class_name TaskFromResource

@export var task_name: String

@export var task_essence: String

var is_complited: bool:
	set(value):
		is_complited = value 
		if is_complited:
			emit_signal("task_complited")

func get_task_name() -> String:
	return task_name

func get_task_essence() -> String:
	return task_essence

signal task_complited
