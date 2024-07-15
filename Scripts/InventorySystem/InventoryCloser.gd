extends VBoxContainer

class_name InventoryCloser

@export var time: float = 0.1
@export var tween_duartion: float = 0.1

var mouse_enter: bool:
	set(value):
		if mouse_enter != value:
			mouse_enter = value
			if mouse_enter:
				
				var timer := get_tree().create_timer(time)
				await timer.timeout
				if mouse_enter:
					visible = true
			else:
				visible = false

func _ready():
	visible = false
	modulate.a = 0
	visibility_changed.connect(_on_visible_changed)

func _on_visible_changed():
	visible_animaiton(visible)

func visible_animaiton(visual: bool):
	if visual:
		var tween := get_tree().create_tween()
		print(modulate)
		tween.tween_property(self, "modulate.a", 1, 1)
		#tween.tween_property(self, "modulate", Color()

func _input(event):
	if event is InputEventMouseMotion:
		if get_global_rect().has_point(get_global_mouse_position()):
			mouse_enter = true
		else:
			mouse_enter = false
