extends Resource

class_name TaskFromResource

enum TaskType {Bring, Lead}

enum CharacterType {Null, Vice, Sid, Trader}

@export var all_items = preload("res://Resources/Inventories/AllItems.tres")

@export_category("Task settings")
@export var task_type: TaskType

@export_group("Item")
@export var item: ItemFromResource.Type
@export var item_recipient: CharacterType

@export_group("Lead")
@export var needed: CharacterType
@export var recipient: CharacterType

var is_complete: bool:
	set(value):
		is_complete = value 
		if is_complete:
			GlobalDialogueState.current_task = null
			emit_signal("task_completed")

func get_needed_item() -> ItemFromResource.Type:
	return item

func get_item_recipient() -> CharacterType:
	return item_recipient

func get_task_type() -> TaskType:
	return task_type

signal task_completed
