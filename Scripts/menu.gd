extends Node2D

var speed = 100

func _process(delta):
	$BG_Menu.scroll_offset.x -= speed * delta

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/first.tscn")

func _on_quit_pressed():
	get_tree().quit()
