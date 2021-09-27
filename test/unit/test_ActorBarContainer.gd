extends "res://addons/gut/test.gd"

var ActorBarContainer := load("res://UI/ActorBarContainer.gd")

func test_show():
	var actor_bar = partial_double(ActorBarContainer).new()
	actor_bar.show()
	assert_eq(actor_bar.modulate.a, 1)


func test_conceal():
	var actor_bar = partial_double(ActorBarContainer).new()
	actor_bar.conceal()
	assert_eq(actor_bar.modulate.a, 0)
