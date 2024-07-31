extends Control

class_name TaskItemAnimation

var item_slot_texture = preload("res://Sprites/BananaBoy assets/Ui/Task_item selected/Item.png")
var task_slot_texture = preload("res://Sprites/BananaBoy assets/Ui/Task_item selected/Task.png")

@export var anim: AnimationPlayer

@export_category("Scenes")

@export var slot: TextureRect

@export_subgroup("Task Scene")
@export var task: TaskFromResource

@export_subgroup("Item scene")
@export var item: ItemFromResource
@export var texture_viewer: TextureRect

func _ready():
	global_position = get_viewport_rect().position
	if item:
		texture_viewer.texture = item.get_texture()
		slot.texture = item_slot_texture 
	elif task != null:
		texture_viewer.get_parent().texture
		slot.texture = task_slot_texture
	
	if anim:
		anim.play("Take item animation")
		await anim.animation_finished
		queue_free()

func set_task(new_task: TaskFromResource):
	task = new_task

func set_item(new_item: ItemFromResource):
	item = new_item
