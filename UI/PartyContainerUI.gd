extends HBoxContainer

signal party_ui_actor_selected(actor_idx)
signal party_ui_actor_selected_shift(actor_idx)
signal party_ui_selecting_actor
signal party_ui_not_selecting_actor

var actors_portraits = null

func _ready():
	actors_portraits = get_children()

func alter_actors_portraits(actors_idxs: Array, styles: Dictionary) -> void:
	var style = StyleBoxFlat.new()
	if actors_idxs:
		for idx in actors_idxs:
			style.set_bg_color(Color(styles.background_color))
			style.set_border_color(Color(styles.border_color))
			style.set_border_width_all(styles.border_width)
			actors_portraits[idx].get_node("Panel").set(
					"custom_styles/panel", style)
	else:
		for actors_portrait in actors_portraits:
			style.set_bg_color(Color(styles.background_color))
			actors_portrait.get_node("Panel").set("custom_styles/panel", style)


func _on_SelectActorButton_party_ui_actor_selected(button):
	emit_signal("party_ui_not_selecting_actor")
	for idx in range(actors_portraits.size()):
		var SelectActorButton = actors_portraits[idx].get_node(
				"SelectActorButton")
		if SelectActorButton == button:
			emit_signal("party_ui_actor_selected", idx)


func _on_SelectActorButton_party_ui_actor_selected_shift(button):
	emit_signal("party_ui_not_selecting_actor")
	for idx in range(actors_portraits.size()):
		var SelectActorButton = actors_portraits[idx].get_node(
				"SelectActorButton")
		if SelectActorButton == button:
			emit_signal("party_ui_actor_selected_shift", idx)


func _on_SelectActorButton_button_down():
	emit_signal("party_ui_selecting_actor")
