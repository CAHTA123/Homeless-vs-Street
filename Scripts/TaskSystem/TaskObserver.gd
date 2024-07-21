extends CanvasLayer

class_name TaskObserver

var is_pressed: bool

func _ready():
	visible = false

#region Ввод
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_T and event.pressed and !is_pressed:
			change_visible()
#endregion

func change_visible():
	if !visible:
		visible = true
		return
		
	visible = false
