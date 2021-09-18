extends Camera2D

export(int) var speed = 5

func _physics_process(_delta):
	position.x += (Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")) * speed
	position.y += (Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")) * speed
