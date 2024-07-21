extends CanvasLayer

class_name PlayerInventoryPlaceholder

#region Экспорты
@export_group("Inventory")
@export var player_inventory: Array[ItemFromResource] = preload("res://Resources/Inventories/PlayerInventory.tres").items_array
@export var slot_parent: Control

@export_group("Item added")
@export var item_added_scene: PackedScene = preload("res://Animations/TaskItemScene.tscn")
#endregion

signal item_selected

func _ready():
	for i in range(player_inventory.size()):
		if slot_parent.get_child(i) is InventorySlot:
			slot_parent.get_child(i).set_item(player_inventory[i])

### Проверка заполнения пустых слотов
#func _input(event):
	#if event is InputEventKey:
		#if event.keycode == KEY_ESCAPE:
			#set_item_empty_slot(preload("res://Resources/Items/Beer.tres"))
			#return

func set_item_empty_slot(new_item: ItemFromResource):
	if player_inventory:
		var empty_inventory: Array[ItemFromResource] = player_inventory.filter(func(item): return item == null)
		var empty_slots: Array = slot_parent.get_children().filter(func(slot: InventorySlot): return slot.get_item() == null)
		if empty_inventory.size() > 0 and empty_slots.size() > 0:
			empty_inventory[0] = new_item
			empty_slots[0].set_item(empty_inventory[0])
			var item_added_scene_instance: TaskItemAnimation = item_added_scene.instantiate()
			item_added_scene_instance.set_item(empty_inventory[0])
			add_child(item_added_scene_instance)
