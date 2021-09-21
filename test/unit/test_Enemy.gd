extends "res://addons/gut/test.gd"

var Enemy = load("res://Creatures/Npc/Enemies/Enemy.gd")

#func test__on_AggroRadius_body_entered():
#	pass


func test__on_UpdatePathToEnemyTimer_timeout():
	var enemy = partial_double(Enemy).new()
	enemy._on_UpdatePathToEnemyTimer_timeout()
	assert_called(enemy, "update_path_to_enemy")


#func test__on_HitBox_area_entered():
#	pass
