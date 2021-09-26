extends "res://addons/gut/test.gd"

var World = load("res://World.tscn")
var DataMapper = load("res://saves/DataMapper.gd")

class FileMock extends File:
	pass

#func test_open_esc_menu():
#	var world = partial_double(World).new()
#


func test_save_game():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	world.DataMapper = double(DataMapper).new()
	world.save_data = { "actors": { "actors_in_party": [] } }
	world.ActorsContainer.actors_in_party = [
		{ "name": "Test", "health": 1, "position": { "x": 1, "y": 1 } }
	]
	world.save_game("test_save_game")
	assert_called(world.DataMapper, "map_actor_to_dict")


func test_load_save():
	var world = partial_double(World).instance()
	stub(world, "handle_save_data").to_do_nothing()
	add_child_autofree(world)
	world.load_save("test_save_game")
	assert_called(world, "handle_save_data")


func test_handle_save_data():
	var world = partial_double(World).instance()
	stub(world, "load_actors").to_do_nothing()
	world.save_data = { "actors": { "actors_in_party": [] } }
	add_child_autofree(world)
	assert_called(world, "load_actors")


func test_load_actors():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	world.save_data = { "actors": { "actors_in_party": [{ "name": "Test" }] } }
	world.DataMapper = double(DataMapper).new()
	world.load_actors()
	assert_called(world.DataMapper, "map_dict_to_actor")


func test_connect_ActorsContainer():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	assert_connected(world.ActorsContainer, world, "open_esc_menu")
	assert_connected(world.ActorsContainer, world.PartyUI,
			"alter_actors_portraits")


func test_connect_PartyUI():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	assert_connected(world.PartyUI, world.ActorsContainer,
			"party_ui_selecting_actor")
	assert_connected(world.PartyUI, world.ActorsContainer,
			"party_ui_not_selecting_actor")
	assert_connected(world.PartyUI, world.ActorsContainer,
			"party_ui_actor_selected")


func test_connect_Actors():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	for actor in world.ActorsContainer.get_children():
		assert_true(actor.Navigation2d is Navigation2D)
		assert_true(actor.MainCamera is Camera2D)


func test_connect_Enemies():
	var world = partial_double(World).instance()
	add_child_autofree(world)
	for enemy in world.EnemyContainer.get_children():
		assert_true(enemy.Navigation2d is Navigation2D)
		assert_connected(enemy.get_node("SelectBox"), world.ActorsContainer,
				"lmb_up")
