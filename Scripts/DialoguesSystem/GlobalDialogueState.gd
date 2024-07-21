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
			is_complete = false
			emit_signal("task_added")
			current_task.task_completed.connect(emit_signal.bind("task_completed"))
			task_add_scene()
			return
		is_complete = true

var current_task_index: int

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
		print("2")
		if current_task.task_type == TaskFromResource.TaskType.Bring:
			print("3")
			if inventory == null:
				print("4")
				if get_tree().current_scene is LevelGame:
					print("5")
					var level_scene: LevelGame = get_tree().current_scene
					inventory = level_scene.get_inventory_node()
			for child in inventory.player_inventory:
				if child:
					print("7")
					if dialogue_starter.self_character_type == current_task.item_recipient:
						return true
						
		elif current_task.task_type == TaskFromResource.TaskType.Lead:
			pass
			
			
	return false
