extends Node2D

@export var scenes: Array[PackedScene] = [] 

var current_index: int = 0

func _ready():
	var current_scene_path: = get_tree().current_scene.get_name()
	if scenes.size() > 0:
		for i in range(scenes.size()):
			print(scenes[i])
			#if scenes[i].get_name() == current_scene_path:
				#current_index = i
				#break
		#print(current_index)

func _on_transition_1_body_entered(body):
	if body.is_in_group("player"):
		if current_index - 1 >= 0:
			current_index -= 1
			get_tree().change_scene_to_file(scenes[current_index].resource_path)
		else:
			current_index = scenes.size() - 1
			get_tree().change_scene_to_file(scenes[current_index].resource_path)


func _on_transition_2_body_entered(body):
	if body.is_in_group("player"):
		if current_index + 1 < scenes.size():
			current_index += 1
			get_tree().change_scene_to_file(scenes[current_index].resource_path)
		else:
			current_index = 0
			get_tree().change_scene_to_file(scenes[current_index].resource_path)
