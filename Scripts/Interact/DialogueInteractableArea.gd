#extends InteractArea
extends InteractArea

class_name DialogueInteractableArea

@export var self_character_type: TaskFromResource.CharacterType

@export_group("Dialogues")
@export var self_all_dialogues: Array [DialogueResource] = [
	preload("res://Resources/Dialogues/Greeting.dialogue"),
	preload("res://Resources/Dialogues/StartSearchExit.dialogue")]
@export var current_dialogue: int

func interact():
	if !GlobalDialogueState.is_talking:
		start_dialogue()

func start_dialogue():
	GlobalDialogueState.dialogue_starter = self
	DialogueManager.show_dialogue_balloon(get_current_dialogue())

#region Сеттеры и Геттеры

func get_current_dialogue() -> DialogueResource:
	return self_all_dialogues[current_dialogue]

#endregion
