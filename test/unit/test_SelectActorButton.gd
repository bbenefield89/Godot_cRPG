extends "res://addons/gut/test.gd"

var SelectActorButton = load("res://UI/SelectActorButton.gd")

func test__on_SelectActorButton_button_up():
	var button = partial_double(SelectActorButton).new()
	watch_signals(button)
	button._on_SelectActorButton_button_up()
	assert_signal_emitted_with_parameters(button, "party_ui_actor_selected",
			[button])
