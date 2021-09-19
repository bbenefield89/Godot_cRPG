extends Area2D

signal lmb_down
signal lmb_up
signal lmb_up_shift
signal on_mouse_exit

func _input_event(_viewport, event, _shape_idx):
	if (
		Input.is_action_just_released("pc_move") and
		event is InputEventMouseButton
	):
		if Input.is_action_pressed("shift"):
			emit_signal("lmb_up_shift")
		else:
			emit_signal("lmb_up")
	elif (
		Input.is_action_just_pressed("pc_move") and
		event is InputEventMouseButton
	):
		emit_signal("lmb_down")


func _on_SelectBox_mouse_exited():
	emit_signal("on_mouse_exit")
