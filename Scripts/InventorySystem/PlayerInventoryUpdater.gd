extends CanvasLayer

class_name PlayerInventoryPlaceholder

@export var player_inventory: Array[ItemFromResource] = preload("res://Resources/Inventories/PlayerInventory.tres").items_array
@export var slot_parent: Control

func _ready():
	for i in range(player_inventory.size()):
		if slot_parent.get_child(i) is InventorySlot:
			slot_parent.get_child(i).set_item(player_inventory[i])
