extends CharacterBody2D

class_name Player

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_walking: bool = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if not is_walking:
			$Anim.offset.x = -8.15
			$Anim.play("WALK")
			is_walking = true
		$Anim.scale.x = direction 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_walking:
			$Anim.offset.x = 0
			$Anim.play("IDLE")
			is_walking = false
	move_and_slide()

func get_walk_mode() -> bool:
	return is_walking

func _on_animated_sprite_2d_animation_finished():
	is_walking = false
