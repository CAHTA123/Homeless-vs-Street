extends Node2D

var speed = 100

func _process(delta):
	$BG_Menu.scroll_offset.x -= speed * delta

func _on_start_pressed():
	get_parent().current_index = 1
	get_parent().anim()

func _on_quit_pressed():
	get_tree().quit()

