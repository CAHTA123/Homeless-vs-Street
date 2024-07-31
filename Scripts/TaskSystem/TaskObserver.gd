extends CanvasLayer

class_name TaskObserver

@export var open_button: Key = KEY_TAB

var is_pressed: bool

func _ready():
	visible = false

#region Ввод
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.keycode == open_button and event.pressed and !is_pressed:
			change_visible()
#endregion

func change_visible():
	if !visible:
		visible = true
		return
		
	visible = false
