extends "res://addons/gut/test.gd"

var Enemy = load("res://Creatures/Npc/Enemies/Enemy.gd")

func test__on_AggroRadius_body_entered():
	var enemy = partial_double(Enemy).new()
	stub(enemy, "set_current_target").to_do_nothing()
	enemy._on_AggroRadius_body_entered(KinematicBody2D.new())
	assert_called(enemy, "set_current_target")


func test__on_UpdatePathToEnemyTimer_timeout():
	var enemy = partial_double(Enemy).new()
	enemy._on_UpdatePathToEnemyTimer_timeout()
	assert_called(enemy, "update_path_to_enemy")
