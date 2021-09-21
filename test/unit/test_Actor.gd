extends "res://addons/gut/test.gd"

class Enemy extends KinematicBody2D:
	pass

var Actor = load("res://Creatures/Actor/Actor.gd")

func test__on_UpdatePathToEnemyTimer_timeout():
	var actor = partial_double(Actor).new()
	actor._on_UpdatePathToEnemyTimer_timeout()
	assert_called(actor, "update_path_to_enemy")


#func test__on_HitBox_area_entered():
#	var actor = partial_double(Actor).new()
#	actor._on_HitBox_area_entered(Area2D.new())
	
