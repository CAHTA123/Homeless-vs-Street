extends Area2D

class_name DialogueInteractableArea

@export_group("Dialogues")

@export var self_all_dialogues: Array[DialogueResource]
@export var current_dialogue: int

func interact():
	start_dialogue()

func start_dialogue():
	DialogueManager.show_dialogue_balloon(get_current_dialogue())

#region Сеттеры и Геттеры

func get_current_dialogue() -> DialogueResource:
	return self_all_dialogues[current_dialogue]

#endregion
