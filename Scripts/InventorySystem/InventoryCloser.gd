extends TextureRect

class_name InventoryCloser

@export var open_button: Key

func _ready():
	get_viewport().size_changed.connect(_on_viewport_resized)
	_on_viewport_resized()
	visible = false

func _on_viewport_resized():
	anchors_preset = PRESET_RIGHT_WIDE

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == open_button:
			if !visible:
				visible = true
				return
			visible = false
