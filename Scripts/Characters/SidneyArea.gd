extends DialogueInteractableArea

class_name SidArea

@export var sid: CharacterBody2D

func _ready():
	super._ready()

func interact():
	super.interact()
	print("23")
