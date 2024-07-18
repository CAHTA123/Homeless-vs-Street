extends Node2D

class_name GarbageDroppFlagSaver

#region Экспортируемые переменные
@export var container: GarbageContainer

#Категория настроек
@export_category("File preferences")

# Группа для настройки пути сохранения
@export_group("File path")

@export var file_start_path: String = "user://garbage_drop_data"
@export var prefix: String = ".json"

@export_group("Keys and section")

# Секции сохранения
@export_subgroup("Section")
@export var section: String = "Garbage"

# Секции ключей
@export_subgroup("Keys")
@export var drop_key: String = "Drop"
#endregion

# Конечный путь к файлу, в котором будет сохранятся get_drop_mode()
var file_path: String

# Сам файл
var drop_file := ConfigFile.new()

#region Сигналы
signal garbage_loaded 
signal garbage_saved
#endregion

func _ready():
	# Путь к файлу возможно не уникален - appdata/игра/начальная приставка пути + индекс контейнера с его именем и именем родителя.
	var self_node_path: String = str(container.get_index()) + container.name + get_parent().name
	# Соеденяем это все
	file_path = file_start_path + self_node_path + prefix
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
	drop_file.save(file_path)

# Метод загрузки и присвоения данных
func load_drop_data():
	#Загружаем, чтобы использовать
	drop_file.load(file_path)
	# создаем переменную drop, которая обозначает секцию и ключ которые мы сохраняли
	var drop = drop_file.get_value(section, drop_key)
	
	# Если есть контейнер, то устанавливаем значение для set_drop_mode()
	if container:
		container.set_drop_mode(drop)
#endregion 

# Метод, который возвращает true, если есть файл по заданному пути, иначе false
func get_available_file(path: String = file_path) -> bool:
	if FileAccess.get_file_as_string(path):
		return true
	return false

# При выходе либо смене сцены, мы сохраняем get_drop_mode()
func _notification(what):
	if what == container.NOTIFICATION_EXIT_TREE or what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_drop_data()
