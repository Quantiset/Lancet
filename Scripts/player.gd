extends CharacterBody2D

var rot := 0.0

var rot_speed := 0.55
var accel := 35.0
var max_speed := 100.0

func _physics_process(delta: float) -> void:

	var acc := Vector2()
	
	if get_parent().focused:
		acc.x += Input.get_axis("A", "D")
		acc.y += Input.get_axis("W", "S")
		if Input.is_action_pressed("E"):
			rot += delta * rot_speed
		if Input.is_action_pressed("Q"):
			rot -= delta * rot_speed
		velocity += acc
	
	if acc.is_equal_approx(Vector2()):
		velocity = velocity.lerp(Vector2(), 0.02)
	
	velocity = velocity.limit_length(max_speed)
	#$PointLight2D.rotation = rot
	$LightSprite.rotation = rot
	var collision = move_and_collide(velocity * delta)
	if collision:
		var rb = collision.get_collider()
		if rb is RigidBody2D:
			# push in direction of motion
			rb.apply_central_force(velocity * 20)
		velocity = velocity.slide(collision.get_normal())
