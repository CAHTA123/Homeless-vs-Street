extends RichTextLabel

class_name RichHeadTask

@export_subgroup("Items")
@export var for_prefix: String = "for"
@export var to_prefix: String = "to"

func _ready():
	GlobalDialogueState.task_added.connect(write_new_task)

func erase_text():
	text = ""

func write_new_task():
	var task: TaskFromResource = GlobalDialogueState.get_current_task()
	if task.task_type == TaskFromResource.TaskType.Bring:
		var action: String = TaskFromResource.TaskType.find_key(task.task_type)
		var item: String = ItemFromResource.Type.find_key(task.item)
		var recipient: String = TaskFromResource.CharacterType.find_key(task.item_recipient)
		text = action + " " + item + " " + for_prefix + " " + recipient
		
	elif task.task_type == TaskFromResource.TaskType.Lead:
		var action: String = TaskFromResource.TaskType.find_key(task.task_type)
		var needed: String = TaskFromResource.CharacterType.find_key(task.needed)
		var recipient = TaskFromResource.CharacterType.find_key(task.recipient)
		text = action + " " + needed + " " + to_prefix + " " + recipient
