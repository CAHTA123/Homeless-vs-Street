extends InteractArea

class_name GarbageContainer

@export var garbage_index: int

@export_subgroup("GarbagePreferences")
@export var search_bar: Range 
@export var search_time: float = 2.5

var is_dropped: bool

func interact():
	if search_bar:
		start_search()
		return
	print("search_bar not found!")

func _input(event):
	if event is InputEventKey and event.pressed:
		interact()

func start_search():
	var tween := get_tree().create_tween()
	tween.tween_property(search_bar, "value", search_bar.max_value, search_time).set_trans(Tween.TRANS_LINEAR)
	await tween.finished

func finish_search():
	if !is_dropped:
		is_dropped = true

func set_search_time(new_time: float):
	search_time = new_time

func set_dropped_mode(new_mode: bool):
	is_dropped = new_mode

func get_dropped_mode() -> bool:
	return is_dropped
