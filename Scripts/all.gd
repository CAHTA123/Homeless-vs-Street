extends Node2D

@export var scenes: Array[PackedScene] = []  

var current_scene: Node = null 
var current_index: int  

func _ready():
	current_index = 0
	if scenes.size() > 0:
		anim()

func prev(body):
	if body.is_in_group("player"):
		if current_index - 1 >= 0:
			current_index -= 1
			anim()
		else:
			current_index = scenes.size() - 1
			anim()

func next(body):
	if body.is_in_group("player"):
		if current_index + 1 < scenes.size():
			current_index += 1
			anim()
		else:
			current_index = 0
			anim()

func anim():
	$Anim.play("Transition")

func delete():
	if current_scene != null:
		remove_child(current_scene)
		current_scene.queue_free()
		new1()
	else:
		new1()

func new1():
	current_scene = scenes[current_index].instantiate()
	add_child(current_scene)
	var parent = current_scene.get_parent()
	parent.move_child(current_scene, parent.get_child_count() - 3) 
