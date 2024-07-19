extends Control

class_name TaskItemAnimation

enum TypeAnimation {Item, Task}

@export var anim: AnimationPlayer
@export var animation_type: TypeAnimation

@export_category("Scenes")
@export_subgroup("Task Scene")
@export var task_name: String

@export_subgroup("Item scene")
@export var item: ItemFromResource
@export var texture_viewer: TextureRect

func _ready():
	global_position = get_viewport_rect().position
	if animation_type == TypeAnimation.Item:
		if item and texture_viewer:
			texture_viewer.texture = item.get_texture() 
	elif animation_type == TypeAnimation.Task:
		if texture_viewer.get_parent() is TextureRect:
			texture_viewer.get_parent().texture
	
	if anim:
		anim.play("Take item animation")
		await anim.animation_finished
		queue_free()

func set_item(new_item: ItemFromResource):
	item = new_item

func set_animation_type(new_type: TypeAnimation):
	animation_type = new_type
