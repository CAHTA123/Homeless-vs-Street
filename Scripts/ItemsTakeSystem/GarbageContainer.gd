extends InteractArea

class_name GarbageContainer

# Настройки отображения поиска
@export_category("Search preferences")
@export var search_bar: Range 
@export var garbage_saver: GarbageDroppFlagSaver
@export var search_time: float = 3.25

@export_category("Random items")
@export var garbage_item: ItemFromResource
@export var random_items: Array[ItemFromResource] = [
	preload("res://Resources/Items/Beer.tres"),
	preload("res://Resources/Items/Cheese.tres"),
	preload("res://Resources/Items/Hat.tres"),
	preload("res://Resources/Items/Knife.tres"),
	preload("res://Resources/Items/TinCan.tres")
]

#region Настройки поиска анимации
# анимация для прокрутки bar`а
var tween: Tween

# Времени на поиск осталось
var search_time_left: float:
	set(value):
		search_time_left = value
		if search_time_left <= 0:
			search_time_left = search_time 

# Дистанция при старте поиска
var player_start_distance: float

# Текущая дистанция
var player_current_distance: float

# Проверка на текущий поиск
var is_searching: bool:
	set(value):
		is_searching = value
		# Когда начинается или заканчивается поиск, то мы высчитываем / прекращаем высчитывать дистанцию
		set_physics_process(is_searching)
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

# Проверка на выдачу айтема
var is_dropped: bool
#endregion

signal search_started
signal search_stopped
signal item_dropped

func _ready():
	# Подключаем сигналы
	super._ready()
	# Перестаем искать, если где-то это запускаем
	is_searching = false
	check_garbage_item()
	
	if garbage_item:
		print(garbage_item)
# Если предмет выбрашен, то удаляем garbage_item, иначе рандомим

#region Назначение предмета
func check_garbage_item():
	if is_dropped:
		garbage_item = null
		return
	random_garbage_item()

func random_garbage_item():
	garbage_item = random_items.pick_random()
#endregion

# При взаимодействии мы начинаем поиск
func interact():
	is_searching = true

#region Поиск
# Если объект выходит из ареи, то прекращаем поиск
func object_exited(body):
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
	if search_time_left > 0:
		time = search_time_left
	else:
		time = search_time
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
		# Сигнал выброса предмета
		emit_signal("item_dropped")

	# В любом случае сбрасываем шкалу на 0
	search_bar.value = 0

#endregion 

#region Сеттеры и Геттеры
# Назначаем время поиска
func set_search_time(new_time: float):
	search_time = new_time

# Назначаем флаг выброса айтема
func set_drop_mode(new_mode: bool):
	is_dropped = new_mode

#Возвращаем фла выброса айтема
func get_drop_mode() -> bool:
	return is_dropped
#endregion
