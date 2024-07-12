extends Node2D

@export var scenes: Array[PackedScene] = []

var current_index: int = 0

func _ready():
	
	print("Размер массива scenes: ", scenes.size())
	for scene in scenes:
		print("Сцена: ", scene.name)
		
	var current_scene_name = get_tree().current_scene.name
	if scenes.size() > 0:
		for i in range(scenes.size()):
			if scenes[i].name == current_scene_name:
				current_index = i
				break
	else:
		print ("нет сцен")

func _on_transition_1_body_entered(body):
	if body.is_in_group("player"):
		if scenes.size() > 0:
			if current_index - 1 >= 0:
				current_index -= 1
				get_tree().change_scene_to_file(scenes[current_index].resource_path)
			else:
				current_index = scenes.size() - 1
				get_tree().change_scene_to_file(scenes[current_index].resource_path)
		else:
			print ("нет сцен")

func _on_transition_2_body_entered(body):
	print (current_index)
	if body.is_in_group("player"):
		if scenes.size() > 0:
			if current_index + 1 < scenes.size():
				current_index += 1
				get_tree().change_scene_to_file(scenes[current_index].resource_path)
			else:
				current_index = 0
				get_tree().change_scene_to_file(scenes[current_index].resource_path)
		else:
			print ("нет сцен")
