extends "res://addons/gut/test.gd"

var Actor = load("res://Creatures/Actor/Actor.gd")
var HitBox = load("res://Creatures/Actor/HitBox.gd")

class StatsMock:
	var health = 1
	var damage = 1
	var current_attack_speed = 1


class Enemy extends KinematicBody2D:
	var Stats = StatsMock.new()


class Area2d extends Area2D:
	func get_parent():
		return Enemy.new()


func test__on_UpdatePathToEnemyTimer_timeout():
	var actor = partial_double(Actor).new()
	actor._on_UpdatePathToEnemyTimer_timeout()
	assert_called(actor, "update_path_to_enemy")
