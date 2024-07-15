extends TextureRect

class_name InventorySlot

@export var item: ItemFromResource

var item_texture: TextureRect

func get_item() -> ItemFromResource:
	return item

func set_item(new_item: ItemFromResource):
	item = new_item
