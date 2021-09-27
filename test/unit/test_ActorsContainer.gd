extends "res://addons/gut/test.gd"

var ActorsContainer = load("res://Characters/ActorsContainer.gd")
var ActorScene := load("res://Creatures/Actor/Actor.tscn")

func test_select_only_this_actor():
	var actors_container = partial_double(ActorsContainer).new()
	watch_signals(actors_container)
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
	

func test_append_selected_actor_show_actor_bar():
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
	assert_signal_emitted(actors_container, "show_actor_bar")
	assert_signal_emitted_with_parameters(actors_container,
			"alter_actors_portraits", [actors_idxs, styles])


func test_append_selected_actor_conceal_actor_bar():
	var actors_container = partial_double(ActorsContainer).new()
	watch_signals(actors_container)
	var actor = KinematicBody2D.new()
	actors_container.actors_selected = [actor]
	actors_container.actors_in_party = [actor, actor]
	actors_container.append_selected_actor(actor)
	var actors_idxs = [0, 0]
	var styles = {
		"background_color": "#0b2b5c",
		"border_color": "#949494",
		"border_width": 3
	}
	assert_eq(actors_container.actors_selected.size(), 2)
	assert_signal_emitted(actors_container, "conceal_actor_bar")
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
	assert_signal_emitted(actors_container, "conceal_actor_bar")


func test_is_actor_allowed_to_move_true():
	var actors_container = partial_double(ActorsContainer).new()
	actors_container.is_selecting_actor = false
	var Actor = KinematicBody2D.new()
	actors_container.actors_selected = [Actor]
	var result = actors_container.is_actor_allowed_to_move(Actor)
	assert_true(result)


func test_is_actor_allowed_to_move_false():
	var actors_container = partial_double(ActorsContainer).new()
	actors_container.is_selecting_actor = true
	var Actor = KinematicBody2D.new()
	var result = actors_container.is_actor_allowed_to_move(Actor)
	assert_false(result)


func test_add_actor_to_party():
	var actors_container = partial_double(ActorsContainer).new()
	var Actor = double(ActorScene).instance()
	var ActorSelectBox = Actor.get_node("SelectBox")
	actors_container.add_actor_to_party(Actor)
	assert_connected(ActorSelectBox, actors_container, "lmb_up")
	assert_connected(ActorSelectBox, actors_container, "lmb_up_shift")
	assert_connected(ActorSelectBox, actors_container, "lmb_down")
	assert_connected(ActorSelectBox, actors_container, "on_mouse_exit")


func test_set_selected_actors_target():
	var actors_container = partial_double(ActorsContainer).new()
	var Actor = double(ActorScene).instance()
	actors_container.actors_selected = [Actor]
	var Enemy := KinematicBody2D.new()
	actors_container.set_selected_actors_target(Enemy)
	for actor in actors_container.actors_selected:
		assert_called(actor, "set_current_target", [Enemy])


func test_set_is_selecting_actor():
	var actors_container = partial_double(ActorsContainer).new()
	actors_container.set_is_selecting_actor(true)
	assert_true(actors_container.is_selecting_actor)
	actors_container.set_is_selecting_actor(false)
	assert_false(actors_container.is_selecting_actor)
