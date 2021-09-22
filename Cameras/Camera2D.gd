extends Camera2D

export(int) var pan_speed = 350
export(float) var zoom_speed = 2

func _physics_process(delta):
	handle_camera_movement(delta)
	handle_camera_zoom(delta)


func handle_camera_movement(delta: float) -> void:
	position.x += (Input.get_action_strength("camera_right") -
			Input.get_action_strength("camera_left")) * pan_speed * delta
	position.y += (Input.get_action_strength("camera_down")
			- Input.get_action_strength("camera_up")) * pan_speed * delta


func handle_camera_zoom(delta: float) -> void:
	if Input.is_action_just_released("scroll_wheel_up"):
		if zoom > Vector2(0.5, 0.5):
			zoom -= Vector2(zoom_speed, zoom_speed) * delta
			print(zoom)
	elif Input.is_action_just_released("scroll_wheel_down"):
		if zoom < Vector2(1.5, 1.5):
			zoom += Vector2(zoom_speed, zoom_speed) * delta
			print(zoom)
