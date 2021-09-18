extends Area2D

signal lmb_clicked_on_player_collider
signal lmb_released_on_player_collider
signal lmb_released_on_player_collider_shift
signal on_mouse_exit

func _input_event(_viewport, event, _shape_idx):
	if (
		Input.is_action_just_released("pc_move") and
		event is InputEventMouseButton
	):
		if Input.is_action_pressed("shift"):
			emit_signal("lmb_released_on_player_collider_shift")
		else:
			emit_signal("lmb_released_on_player_collider")
	elif (
		Input.is_action_just_pressed("pc_move") and
		event is InputEventMouseButton
	):
		emit_signal("lmb_clicked_on_player_collider")


func _on_Collider_mouse_exited():
	emit_signal("on_mouse_exit")
