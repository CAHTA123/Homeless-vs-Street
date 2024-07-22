extends DialogueInteractableArea

class_name FollowArea

@export var follower: CharacterBody2D

@export var speed: float
var object_to_direction: Player

var direction: Vector2

func _process(delta):
	if follower:
		direction = object_to_direction.global_position - follower.global_position
		speed = object_to_direction.velocity.x * 0.75
		follower.velocity = direction.normalized() * speed
		follower.move_and_slide()

func _ready():
	super._ready()
	set_process(false)
	body_entered.connect(_on_body_entered)
	GlobalDialogueState.task_added.connect(check_task_type)

func _on_body_entered(body):
	if body is Player:
		object_to_direction = body

func check_task_type():
	if GlobalDialogueState.current_task.task_type != TaskFromResource.TaskType.Lead:
		set_process(false)
