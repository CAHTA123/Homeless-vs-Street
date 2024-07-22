extends AnimatedSprite2D

class_name CharacterAnimation

@export_category("Animation drag nodes")
@export var character: CharacterBody2D

func _physics_process(delta):
	if character:
		var direction: float = character.velocity.x
		
		if direction != 0:
			play("WALK")
			
			if direction > 0:
				flip_h = false
				
			elif direction < 0:
				flip_h = true
			
			return
		
		play("IDLE")
