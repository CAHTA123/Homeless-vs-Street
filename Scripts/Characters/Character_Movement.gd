extends CharacterBody2D

@export var dialogue_area: DialogueInteractableArea

@export var speed: float

var player: Player

func _ready():
	set_process(false)
	if dialogue_area:
		dialogue_area.body_entered.connect(_on_dialogue_area_body_entered)

func _on_dialogue_area_body_entered(body):
	if body is Player:
		player = body

func _process(delta):
	var direction: Vector2 = player.global_position - global_position 
	if direction.x != 0:
		velocity.x = direction.x * speed

	move_and_slide()
