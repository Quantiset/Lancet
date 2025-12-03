extends CharacterBody2D

var rot := 0.0

var rot_speed := 0.55
var accel := 35.0
var max_speed := 125.0

signal interactable_entered_fov(int_name, interactable)
signal interactable_exited_fov(int_name, interactable)

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
	$LightSprite.rotation = rot
	$Area2D.rotation = rot
	var collision = move_and_collide(velocity * delta)
	if collision:
		var rb = collision.get_collider()
		if rb is RigidBody2D:
			# push in direction of motion
			rb.apply_central_force(velocity * 20)
		velocity = velocity.slide(collision.get_normal())


func _on_area_2d_body_entered(body: Node2D) -> void:
	$RayCast2D.target_position = body.global_position - global_position
	$RayCast2D.force_raycast_update()
	
	if body.is_in_group("Human"):
		body.player = self
	
	if body.is_in_group("Interactable") and not $RayCast2D.is_colliding():
		print("what", body.interactable_name, body)
		var r = emit_signal("interactable_entered_fov", body.interactable_name, body)
		print(r)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Human"):
		body.player = null
	
	if body.is_in_group("Interactable"):
		emit_signal("interactable_exited_fov", body.interactable_name, body)
