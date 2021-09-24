extends Button

signal party_ui_actor_selected(button)
signal party_ui_actor_selected_shift(button)

func _on_SelectActorButton_button_up():
	if Input.is_action_pressed("shift"):
		emit_signal("party_ui_actor_selected_shift", self)
	else:
		emit_signal("party_ui_actor_selected", self)
