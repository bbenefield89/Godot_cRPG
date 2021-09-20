extends Camera2D

export(int) var speed = 200

func _physics_process(delta):
	handle_camera_movement(delta)
	handle_camera_zoom(delta)


func handle_camera_movement(delta: float) -> void:
	position.x += (Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")) * speed * delta
	position.y += (Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")) * speed * delta


func handle_camera_zoom(delta: float) -> void:
	if Input.is_action_just_released("scroll_wheel_up"):
		if zoom > Vector2(0.5, 0.5):
			zoom -= Vector2(0.01, 0.01)
			print(zoom)
	elif Input.is_action_just_released("scroll_wheel_down"):
		if zoom < Vector2(1.5, 1.5):
			zoom += Vector2(4, 4)
			print(zoom)
