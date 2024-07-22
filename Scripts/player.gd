extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var jump_velocity = -400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_walking: bool = false

func _physics_process(delta):	
	var direction = Input.get_axis("Player left", "Player right")
	if direction:
		velocity.x = direction * speed
		if not is_walking:
			$Anim.play("WALK")
			is_walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_walking:
			$Anim.play("IDLE")
			is_walking = false
	move_and_slide()
	
	if velocity.x > 0:
		$Anim.flip_h = false
	elif velocity.x < 0:
		$Anim.flip_h = true

func get_walk_mode() -> bool:
	return is_walking

func _on_animated_sprite_2d_animation_finished():
	is_walking = false
