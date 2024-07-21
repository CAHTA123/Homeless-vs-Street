extends Area2D

class_name InteractArea

var player: Player:
	set(value):
		player = value
		if player != null:
			set_process_input(true)
			return
		set_process_input(false)

@export var interact_button := KEY_E

func _ready():
	player = null
	body_entered.connect(object_entered)
	body_exited.connect(object_exited)

func object_entered(body):
	if body is Player:
		player = body

func object_exited(body):
	if body == player:
		player = null

func interact():
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == interact_button:
			interact()
