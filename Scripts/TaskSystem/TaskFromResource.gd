extends Resource

class_name TaskFromResource

@export var task_name: String

@export var task_essence: String

var is_complited: bool:
	set(value):
		is_complited = value 
		if is_complited:
			emit_signal("task_complited")

signal task_complited
