extends Node

@export var all_tasks: Array[TaskFromResource] = [
	]

@export var all_dialogues: Array[DialogueResource] = [
	preload("res://Resources/Dialogues/Greeting.dialogue"),
	preload("res://Resources/Dialogues/SideneyFound.dialogue"),
	preload("res://Resources/Dialogues/StartSearchExit.dialogue"),
	preload("res://Resources/Dialogues/MeetTrader.dialogue"),
	preload("res://Resources/Dialogues/EndGame.dialogue")
	]

var current_task: TaskFromResource = preload("res://Resources/Tasks/BeerToSid.tres"):
	set(value):
		current_task = value
		if current_task != null:
			emit_signal("task_added")
			current_task.task_complited.connect(emit_signal.bind("task_completed"))
		task_add_scene()

signal task_completed

signal task_added

func task_add_scene():
	var task_scene_instance: TaskItemAnimation = preload("res://Scenes/Animations/TaskItemScene.tscn").instantiate()
	task_scene_instance.set_task(current_task)
	get_tree().current_scene.add_child(task_scene_instance)
