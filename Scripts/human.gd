extends CharacterBody2D

@export var enabled := true
@export var accel := 20.0
var player = null

func _physics_process(delta: float) -> void:
	
	if player and enabled:
		velocity += -accel * (player.global_position - global_position).normalized()
	velocity = velocity.lerp(Vector2(), 0.003)
	
	move_and_slide()
