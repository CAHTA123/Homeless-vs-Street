extends Node

#region Узлы сцены

# Для проверки выполнения задание
@export var level: LevelGame
@export var inventory: PlayerInventoryPlaceholder
#endregion

# Все задания
@export var all_tasks: Array[TaskFromResource] = [
	preload("res://Resources/Tasks/BeerToVice.tres"),
	preload("res://Resources/Tasks/SidLead.tres"),
	preload("res://Resources/Tasks/BeerToSid.tres"),
	preload("res://Resources/Tasks/CheeseToSid.tres"),
	preload("res://Resources/Tasks/TraderCan.tres")
	]

# Текущее задание
var current_task: TaskFromResource:
	set(value):
		current_task = value
		# Если мы не удаляем задание, а меняем то она нам нужно, следовательно need = true
		if current_task != null:
			task_need = true

# Текущее задание как индекс в all_tasks[]
var current_task_index: int:
	set(value):
		current_task_index = value
		next_task_index = current_task_index + 1

# Персонаж начавший диалог
var started_dialogue_character: DialogueInteractableArea

#region Сигналы

# Сигнал добавления задания
signal task_added

# Сигнал выполнения задания
signal task_completed
#endregion

# Переменная для использования в диалогов
# Чтобы сменить задание, использую ее из-за особенностей API Dialogue manager`а
# Которые не позволяют делать мат. вычисления
var next_task_index: int = 1

#region Флаги
# Разговаривает ли персонаж в данный момент
var talk_mode: bool

# Нужно ли выполнить задание в данный момент
var task_need: bool

#endregion

# Меняем задание на следующее, прибавляя current_task_index
func up_task_index():
	current_task_index += 1
	if current_task.is_complete or all_tasks[current_task_index] == null:
		current_task_index += 1

func set_task(idx: int = current_task_index):
# Устанавливаем текущее задание с помощью индекса из всего массива заданий
	current_task = all_tasks[idx]
# Сигнал добавления таска
	emit_signal("task_added")
# Добавляем сцену, предупреждающую игрока о задании
	add_task_scene()

#region Далог, начало и конец
# Начинаем диалог
func start_dialogue(dialogue: DialogueResource):
# Если мы не говорим, то начинаем
	if !talk_mode:
		talk_mode = true
# Показываем диалог, который нам указали
		DialogueManager.show_dialogue_balloon(dialogue)
# По оканчанию диалога вызываем метод
		DialogueManager.dialogue_ended.connect(on_dialogue_ended)

# Метод окончания диалога
func on_dialogue_ended(dialogue: DialogueResource):
# По окончанию диалога перестаем говорить
	talk_mode = false
#endregion

# Проверяем текущее задание
func check_task():
# Если задание было полученно
	if task_need:
	# Если текущее заадние - подобрать предмет
		if current_task.task_type == TaskFromResource.TaskType.Bring:
		# Если есть инвентарь
			if check_valid_inventory():
			# Создаем массив всех элементов инвентаря, которые могут подходить для задания
				var relevents_item: Array[ItemFromResource] = inventory.player_inventory.filter(
				# Метод возвращающий все предметы, которые подходят для задания
					func (item: ItemFromResource): 
					# Если предмет есть и его тип равен необходимого типа из задания, то возвращаем предмет
						if item != null and item.type == current_task.item_type:
							return item
				)
			# Если массив не пуст
				if relevents_item.size() > 0:
				# Если персонаж из задания соответствует персонажу, который начал диалог
					if current_task.get_item_recipient() == started_dialogue_character.self_character_type:
					# Выполняем задание
						complete_task()
					# Удаляем предмет в инвенторе, который индексом равен первому предмету из  всех подходящих предметов
						inventory.delete_item(inventory.player_inventory.find(relevents_item[0])) 
		
		elif current_task.task_type == TaskFromResource.TaskType.Lead:
			if started_dialogue_character.self_character_type == current_task.recipient:
				if started_dialogue_character.get_overlapping_areas():
					for child in started_dialogue_character.get_overlapping_areas():
						if child is DialogueInteractableArea:
							if child.self_character_type == current_task.needed:
								complete_task()
# Выполнение задания
func complete_task():
	if current_task != all_tasks[next_task_index]:
		up_task_index()
# Обнуляем текущее задание
	current_task.is_complete = true
	current_task = null
# Текущее задание выполнено, так что не нужно
	task_need = false
	emit_signal("task_completed")



# Добавляем маленькую сценку
func add_task_scene():
# Создаем запакованную сцену
	var task_scene: PackedScene = preload("res://Animations/TaskItemScene.tscn")
# Создаем экземпляр
	var task_scene_instance: TaskItemAnimation = task_scene.instantiate()
# Назначаем задание, чтобы оно отобразило задание
	task_scene_instance.set_task(get_current_task())
# Добавляем сцену
	add_child(task_scene_instance)

# Проверям наличине инвентаря
func check_valid_inventory() -> bool:
# Берем уровень, как текущюю сцену, т.к. менять мы ее не планируем
	level = get_tree().current_scene
# Если есть уровень и инвентарь, то ищем инвентарь, возвращаем тру
	if get_tree().root.get_children().find(level) and inventory:
		if level.get_children().find(inventory) >= 0:
			return true
# Иначе если есть только уровень
	elif get_tree().root.get_children().find(level) and inventory == null:
	# Берем инвентарь, и возвращаем true
		inventory = level.get_inventory_node()
		return true
	# если нет ни уровня, не инвенторя 
	elif level == null and inventory == null:
	# Ищем предметы
		return find_inventory()
# Если ни одно из этих условий не выполнилось, значит инвентаря нет, он не валиден
	return false

# Находим инвентарь
func find_inventory() -> bool:
# Перебераем все главные узлы, включая синглтоны
	for child in get_tree().root.get_children():
	# Если дочерний узел это уровень
		if child is LevelGame:
		# Записываем в переменную
			level = child
		# Если есть дочерний узел в скрипте level`а
			if level.get_inventory_node():
			# запонинаем этот дочерний узел
				inventory = level.get_inventory_node()
			# Валидно
				return true
# Если level не имеет инвентарь в скрипте
			elif level.get_inventory_node() == null:
			# перебираем все узлы в level`е
				for child_node in level.get_children():
				# Если дочерний узел инвентаря класса физ. инвентаря
					if child_node is PlayerInventoryPlaceholder:
					# Записываем дочерний узел класса физ. инвентаряв переменную
						inventory = child_node
						# Валидно
						return true
# Не валидно
	return false

#region Set`эры и Get`эры

# Возвращает текущее положение по заданию
func get_task_need_mode() -> bool:
	return task_need

# Возвращаем Текущее задание
func get_current_task() -> TaskFromResource:
	return all_tasks[current_task_index]

# Проверяет разговаривает ли ГГ с кем - нибудь
func get_talk_mode() -> bool:
	return talk_mode
#endregion

