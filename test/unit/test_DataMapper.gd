extends "res://addons/gut/test.gd"

var DataMapper = load("res://saves/DataMapper.gd")

class ActorMock extends KinematicBody2D:
	var Stats = { "health": 1 }
	func _ready():
		name = "Test"

func test_map_actor_to_dict():
	var data_mapper = partial_double(DataMapper).new()
	var actor = {
		"name": "Test",
		"health": 1,
		"position": { "x": 0, "y": 0 }
	}
	var actor_mock = ActorMock.new()
	actor_mock.name = "Test"
	var saved_actor = data_mapper.map_actor_to_dict(actor_mock)
	assert_eq(actor_mock.name, saved_actor.name)
	assert_eq(actor_mock.Stats.health, saved_actor.health)
	assert_eq(actor_mock.position.x, saved_actor.position.x)
	assert_eq(actor_mock.position.y, saved_actor.position.y)
