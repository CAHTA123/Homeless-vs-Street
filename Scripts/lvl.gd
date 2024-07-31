extends Node2D

class_name LevelGame

@export var inventory: PlayerInventoryPlaceholder

@export var task_observer: TaskObserver

func get_task_observer() -> TaskObserver:
	if task_observer:
		return task_observer
	return null

func get_inventory_node() -> PlayerInventoryPlaceholder:
	if inventory:
		return inventory
	return null
