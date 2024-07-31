#extends InteractArea
extends InteractArea

class_name DialogueInteractableArea

@export var self_character_type: TaskFromResource.CharacterType

@export_group("Dialogues")
@export var self_all_dialogues: Array [DialogueResource] = []
@export var current_dialogue: int

func interact():
	GlobalDialogueState.started_dialogue_character = self
	GlobalDialogueState.start_dialogue(get_current_dialogue())

func up_dialogue_index(idx: int = 1):
	current_dialogue += idx

#region Сеттеры и Геттеры

func get_current_dialogue() -> DialogueResource:
	return self_all_dialogues[current_dialogue]

#endregion
