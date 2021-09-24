extends "res://addons/gut/test.gd"

var World = load("res://World.tscn")

#func test_open_esc_menu():
#	var world = partial_double(World).new()
#

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
