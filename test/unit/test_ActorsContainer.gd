extends "res://addons/gut/test.gd"

var ActorsContainer = load("res://Characters/ActorsContainer.gd")

func test_select_only_this_actor():
	var actors_container = partial_double(ActorsContainer).new()
	stub(actors_container, "deselect_all_actors").to_do_nothing()
	stub(actors_container, "append_selected_actor").to_do_nothing()
	actors_container.select_only_this_actor(KinematicBody2D.new())
	assert_called(actors_container, "deselect_all_actors")
	assert_called(actors_container, "append_selected_actor")


func test_select_only_this_actor_by_idx():
	var actors_container = partial_double(ActorsContainer).new()
	stub(actors_container, "select_only_this_actor").to_do_nothing()
	actors_container.select_only_this_actor_by_idx(0)
	assert_called(actors_container, "select_only_this_actor")


func test_select_actor():
	var actors_container = partial_double(ActorsContainer).new()
	actors_container.actors_selected = [KinematicBody2D.new()]
	stub(actors_container, "append_selected_actor").to_do_nothing()
	actors_container.select_actor(KinematicBody2D.new())
	
	actors_container.actors_selected = []
	actors_container.select_actor(KinematicBody2D.new())
	assert_call_count(actors_container, "append_selected_actor", 2)


func test_select_actor_by_idx():
	var actors_container = partial_double(ActorsContainer).new()
	actors_container.actors_in_party = [KinematicBody2D.new()]
	stub(actors_container, "select_actor").to_do_nothing()
	actors_container.select_actor_by_idx(0)
	assert_called(actors_container, "select_actor",
			[actors_container.actors_in_party[0]])
	

func test_append_selected_actor():
	var actors_container = partial_double(ActorsContainer).new()
	watch_signals(actors_container)
	var actor = KinematicBody2D.new()
	actors_container.actors_in_party = [actor]
	actors_container.append_selected_actor(actor)
	var actors_idxs = [0]
	var styles = {
		"background_color": "#0b2b5c",
		"border_color": "#949494",
		"border_width": 3
	}
	assert_eq(actors_container.actors_selected.size(), 1)
	assert_signal_emitted_with_parameters(actors_container,
			"alter_actors_portraits", [actors_idxs, styles])


func test_deselect_all_actors():
	var actors_container = partial_double(ActorsContainer).new()
	watch_signals(actors_container)
	actors_container.actors_selected = [KinematicBody2D.new()]
	actors_container.deselect_all_actors()
	assert_eq(actors_container.actors_selected.size(), 0)
	assert_signal_emitted_with_parameters(actors_container,
			"alter_actors_portraits", [[], { "background_color": "#0b2b5c" }])
