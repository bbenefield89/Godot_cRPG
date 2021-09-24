extends "res://addons/gut/test.gd"

var PartyContainerUI = load("res://UI/PartyContainerUI.gd")

class MarginContainerMock extends MarginContainer:
	var panel = PanelMock.new()
	var button = null

	func _init(button_arg: Button = null):
		button = button_arg

	func get_node(node_path: NodePath) -> Node:
		if node_path == "Panel":
			return panel
		else:
			return button


class PanelMock extends Panel:
	pass


func test_alter_actors_portraits():
	var partyContainerUI = partial_double(PartyContainerUI).new()
	partyContainerUI.actors_portraits = [MarginContainerMock.new()]
	var styles = {
		"background_color": "#0b2b5c",
		"border_color": "#949494",
		"border_width": 3,
	}
	partyContainerUI.alter_actors_portraits([0], styles)
	var bg_color = Color(0.043137,0.168627,0.360784,1)
	var border_color = Color(0.580392,0.580392,0.580392,1)
	var styleBox = partyContainerUI.actors_portraits[0].get_node("Panel").get(
			"custom_styles/panel")
	assert_true(styleBox.bg_color.is_equal_approx(bg_color))
	assert_true(styleBox.border_color.is_equal_approx(border_color))
	assert_eq(styleBox.border_width_top, 3)
	assert_eq(styleBox.border_width_right, 3)
	assert_eq(styleBox.border_width_bottom, 3)
	assert_eq(styleBox.border_width_left, 3)


func test__on_SelectActorButton_party_ui_actor_selected_emitted():
	var partyContainerUI = partial_double(PartyContainerUI).new()
	watch_signals(partyContainerUI)
	var button = Button.new()
	partyContainerUI.actors_portraits = [MarginContainerMock.new(button)]
	partyContainerUI._on_SelectActorButton_party_ui_actor_selected(button)
	assert_signal_emitted(partyContainerUI, "party_ui_not_selecting_actor")
	assert_signal_emitted(partyContainerUI, "party_ui_actor_selected")


func test__on_SelectActorButton_party_ui_actor_selected_not_emitted():
	var partyContainerUI = partial_double(PartyContainerUI).new()
	watch_signals(partyContainerUI)
	var button = Button.new()
	partyContainerUI.actors_portraits = [MarginContainerMock.new(Button.new())]
	partyContainerUI._on_SelectActorButton_party_ui_actor_selected(button)
	assert_signal_emitted(partyContainerUI, "party_ui_not_selecting_actor")
	assert_signal_not_emitted(partyContainerUI, "party_ui_actor_selected")
