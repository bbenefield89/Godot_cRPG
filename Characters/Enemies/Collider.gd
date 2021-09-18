extends Area2D

signal lmb_released_on_enemy_collider

func _input_event(_viewport, event, _shape_idx):
	if (
		Input.is_action_just_released("pc_move") and
		event is InputEventMouseButton
	):
		emit_signal("lmb_released_on_enemy_collider")
