extends InteractArea

class_name GarbageContainer

#region Экспорт
# Настройки отображения поиска
@export_category("Level")

@export var level: LevelGame
@export var inventory_node: PlayerInventoryPlaceholder

@export_category("Search preferences")
@export var search_bar: Range
@export var garbage_saver: GarbageDroppFlagSaver
@export var search_time: float = 3.25
@export_subgroup("Check values")
@export var around_value = 0.001
@export_category("Random items")
@export var garbage_item: ItemFromResource

@export var random_items: Array[ItemFromResource] = [
	preload("res://Resources/Items/Beer.tres"),
	preload("res://Resources/Items/Cheese.tres"),
	preload("res://Resources/Items/Hat.tres"),
	preload("res://Resources/Items/Knife.tres"),
	preload("res://Resources/Items/TinCan.tres")
]
#endregion

#region Настройки поиска анимации
# анимация для прокрутки bar`а
var tween: Tween

# Времени на поиск осталось
var search_time_left: float

# Дистанция при старте поиска
var player_start_distance: float

# Текущая дистанция
var player_current_distance: float

# Проверка на текущий поиск
var is_searching: bool:
	set(value):
		is_searching = value
		# Когда начинается или заканчивается поиск, то мы высчитываем / прекращаем высчитывать дистанцию
		# Если есть Bar
		if search_bar:
			search_bar.visible = is_searching
		# Если мы не ищем, то останавливаем поиск, иначе начинаем
		if !is_searching:
			if tween:
				tween.stop()
		else:
			player_start_distance = global_position.distance_to(player.global_position)
			start_search()
		set_physics_process(is_searching)

# Проверка на выдачу айтема
var is_dropped: bool
#endregion

#region Сигналы
# Начало поиска
signal search_started
# Остановка поиска
signal search_stopped
# Бросок предмета
signal item_dropped
#endregion

func _ready():
	# Подключаем сигналы
	super._ready()
	# Перестаем искать, если где-то запускаем поиск
	is_searching = false
	
	if check_garbage_item():
	# Если предмет должен быть то ищем инвентарь и рандомим
		search_inventory()

func search_inventory():
	for child in get_tree().root.get_children():
		if child is LevelGame:
			for child_node in child.get_children():
				if child_node is PlayerInventoryPlaceholder:
					inventory_node = child_node

#region Назначение предмета
func check_garbage_item():
#Если предмет выбрашен, то удаляем garbage_item, иначе рандомим
	if is_dropped:
		garbage_item = null
		return false
	return true

func random_garbage_item():
	garbage_item = random_items.pick_random()
#endregion

# При взаимодействии мы начинаем поиск
func interact():
	is_searching = true

#region Поиск
# Если объект выходит из ареи, то прекращаем поиск
func object_exited(body):
	super.object_exited(body)
	is_searching = false

# Высчитываем дистанцию
func _physics_process(delta):
	search_time_left -= delta
	player_current_distance = global_position.distance_to(player.global_position)
	
	# Если игрок двинулся, то тогда прекращаем поиск
	if player_start_distance != 0 and player_current_distance != 0:
		if player_current_distance != player_start_distance:
			is_searching = false

func start_search():
	# Устанавливаем время для поиска
		# Если нет time_left`а, то тогда время поиска будет стандартной
	var time: float
	if search_time_left > around_value:
		time = search_time_left
	else:
		time = search_time
		search_time_left = search_time
	
	
		# Создаем анимацию поиска
	tween = get_tree().create_tween()
	tween.tween_property(search_bar, "value", search_bar.max_value, time).set_trans(Tween.TRANS_LINEAR)
	# По окончании анимации поиска мы вызываем метод конца поиска
	await tween.finished
	finish_search()

# Конец поиска
func finish_search():
	# По окончанию поиска мы не ищем
	is_searching = false
	# Если мы не выкинули предмет, то кидаем
	if !is_dropped:
		is_dropped = true
		if inventory_node:
			inventory_node.set_item_empty_slot(garbage_item)
	# Сигнал выброса предмет
	emit_signal("item_dropped")

	# В любом случае сбрасываем шкалу на 0
	search_bar.value = 0
	search_time_left = search_time
#endregion 

#region Сеттеры и Геттеры
# Назначаем флаг выброса айтема
func set_drop_mode(new_mode: bool):
	is_dropped = new_mode

#Возвращаем фла выброса айтема
func get_drop_mode() -> bool:
	return is_dropped
#endregion

