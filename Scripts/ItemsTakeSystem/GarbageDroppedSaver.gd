extends Node2D

class_name GarbageDroppFlagSaver

#region Экспортируемые переменные
@export var container: GarbageContainer

#Категория настроек
@export_category("File preferences")

# Группа для настройки пути сохранения
@export_group("File path")
@export var prefix: String = ".json"
@export var file_start_path: String = "res://GameSaves/GarbageContainers/" 

@export_group("Keys and section")

# Секции сохранения
@export_subgroup("Section")
@export var section: String = "Garbage"

# Секции ключей
@export_subgroup("Keys")
@export var drop_key: String = "Drop"
#endregion

# Сам файл
var drop_file := ConfigFile.new()

#region Сигналы
signal garbage_loaded 
signal garbage_saved
#endregion

func _ready():
	file_start_path += str(get_parent().get_index())+ str(get_index()) + prefix
	
	# Если есть мусорыный контейнер, то по выбросу предмета мы сохраняем get_drop_mode()
	if container:
		# Если мы еще не подбирали предмет, то...
		if !container.get_drop_mode():
			container.item_dropped.connect(save_drop_data)
	# Если нет файла по пути file_path, то сохраняем новый
	if !get_available_file():
		save_drop_data()
		return
	# Иначе загружаем и задаем значения 
	load_drop_data()

#region Сохранение Загрузка
# Метод сохранения, пока что сохраняется только то, что мы выкинули
func save_drop_data():
	# Назначение секции и ключа
	drop_file.set_value(section, drop_key, container.get_drop_mode())
	# Сохранение
	drop_file.save(file_start_path)

# Метод загрузки и присвоения данных
func load_drop_data():
	#Загружаем, чтобы использовать
	drop_file.load(file_start_path)
	# создаем переменную drop, которая обозначает секцию и ключ которые мы сохраняли
	var drop = drop_file.get_value(section, drop_key)
	
	# Если есть контейнер, то устанавливаем значение для set_drop_mode()
	if container:
		container.set_drop_mode(drop)
#endregion 

#region Геттеры и Сеттеры
# Метод, который возвращает true, если есть файл по заданному пути, иначе false
func get_available_file(path: String = file_start_path) -> bool:
	if FileAccess.get_file_as_string(path):
		return true
	return false
#endregion

# При выходе либо смене сцены, мы сохраняем get_drop_mode()
func _notification(what):
	if what == container.NOTIFICATION_EXIT_TREE or what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_drop_data()
