extends CanvasLayer

class_name PlayerInventoryPlaceholder

#region Экспорты
@export_group("Inventory")
# Инвентарь как ресурс
@export var player_inventory: Array[ItemFromResource] = preload("res://Resources/Inventories/PlayerInventory.tres").items_array
# Инвентарь как видимый объект, физ. инвентарь
@export var slot_parent: Control

# Сцена добавления предмета, анимация
@export_group("Item added")
@export var item_added_scene: PackedScene = preload("res://Animations/TaskItemScene.tscn")
#endregion

func _ready():
# Перебираем весь размер инвентарья
	for i in range(player_inventory.size()):
	# Если есть ячека с такимже индексом и она является физ. слотом инветаря
		if slot_parent.get_child(i) is InventorySlot:
		#  Устанавливаем предмет с индексом i в слот с таким же индексом
			slot_parent.get_child(i).set_item(player_inventory[i])

# Удаляем предмет из инветаря
func delete_item(index):
# Если айтем, который нам предлагают удалить есть в инвентаре
	if player_inventory[index]:
	# Устанавливаем предмет физ. слота такого же индекс нулевым
		slot_parent.get_child(index).set_item(null)
	# Устанавливаем слот инвентарь - ресурса нуллевым 
		player_inventory[index] = null

#Устанавливаем предмет в пустой слот
func set_item_empty_slot(new_item: ItemFromResource):
# Если есть инвентарь
	if player_inventory:
	# Создаем массив пустого инвентаря равным всем элементам, которые будут null
		var empty_inventory: Array[ItemFromResource] = player_inventory.filter(func(item): return item == null)
	# Создаем массив пустых слотов, равным слотам, которые не имеет предмета
		var empty_slots: Array = slot_parent.get_children().filter(func(slot: InventorySlot): return slot.get_item() == null)
	# Если есть массивы пустого инвенторя и пустых слотов
		if empty_inventory.size() > 0 and empty_slots.size() > 0:
		# Устанавливаем новый предмет в ресурсный инвентарь 
			player_inventory[player_inventory.find(empty_inventory[0])] = new_item
		# в пустой физ. слот устанавливаем новый предмет
			empty_slots[0].set_item(new_item)
		# инстанциируем сцену анимации получения предмета
			var item_added_scene_instance: TaskItemAnimation = item_added_scene.instantiate()
		# Указываем, что добавляем предмет
			item_added_scene_instance.set_item(new_item)
		# Добавляем сцену
			add_child(item_added_scene_instance)
