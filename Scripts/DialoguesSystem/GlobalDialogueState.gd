extends Node

@export var inventory: PlayerInventoryPlaceholder

@export var all_tasks: Array[TaskFromResource] = [
	preload("res://Resources/Tasks/BeerToVice.tres"),
	preload("res://Resources/Tasks/SidLead.tres"),
	preload("res://Resources/Tasks/BeerToSid.tres"),
	preload("res://Resources/Tasks/BeerCanSid.tres")
	]

var current_task: TaskFromResource:
	set(value):
		current_task = value
		if current_task != null:
			print("2323232323232")
			is_complete = false
			emit_signal("task_added")
			current_task.task_completed.connect(emit_signal.bind("task_completed"))
			task_add_scene()
			return
		is_complete = true

var dialogue_starter: DialogueInteractableArea

#region Сигналы
signal speak_ended

signal speak_started

signal task_completed

signal task_added
#endregion

var is_talking: bool = false:
	set(value):
		is_talking = value
		if is_talking:
			emit_signal("speak_started")
		else:
			emit_signal("speak_ended")

var is_complete: bool = false

func get_current_task() -> TaskFromResource:
	return current_task

func task_add_scene():
	var task_scene_instance: TaskItemAnimation = preload("res://Animations/TaskItemScene.tscn").instantiate()
	task_scene_instance.set_task(current_task)
	get_tree().current_scene.add_child(task_scene_instance)

func check_task_complete():
	if current_task:
		if current_task.task_type == TaskFromResource.TaskType.Bring:
			if inventory == null:
				if get_tree().current_scene is LevelGame:
					var level_scene: LevelGame = get_tree().current_scene
					inventory = level_scene.get_inventory_node()
			for child in inventory.player_inventory:
				if child and child.type == current_task.item:
					var slot_from_ui = inventory.slot_parent.get_child(inventory.player_inventory.find(child))
					if slot_from_ui is InventorySlot:
						if dialogue_starter.self_character_type == current_task.item_recipient:
							slot_from_ui.set_item(null)
							child = null
							complete_task()
							break

		elif current_task.task_type == TaskFromResource.TaskType.Lead:
			if dialogue_starter.has_overlapping_areas():
				for child in dialogue_starter.get_overlapping_areas():
					if child is DialogueInteractableArea:
						if child.self_character_type == current_task.needed:
							complete_task()

func complete_task():
	current_task.is_complete = true
