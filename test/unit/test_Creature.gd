extends "res://addons/gut/test.gd"

class Enemy extends KinematicBody2D:
	var Stats = Signaler.new()
	var UpdatePathToEnemyTimer = Timer.new()


class Signaler extends Object:
	signal zero_health


class UpdatePathToEnemyTimer extends Timer:
	func start(time_sec: float = -1):
		pass

class Navigation2d extends Navigation2D:
	func get_simple_path(a: Vector2, b: Vector2, c: bool = true) -> PoolVector2Array:
		return PoolVector2Array([Vector2(0, 0)])

var Creature = load("res://Creatures/Creature/Creature.gd")

#func test_move_to_destination():
#	var creature = Creature.new()
#	creature.move_to_destination(0.5)


func test_create_path_to_destination():
	var creature = Creature.new()
	creature.Navigation2d = Navigation2d.new()
	creature.create_path_to_destination(Vector2(0, 0))
	assert_eq(creature.path, PoolVector2Array([Vector2(0, 0)]))
	creature.Navigation2d.free()
	creature.free()


func test_remove_existing_connection():
	var signaler = Signaler.new()
	var creature = Creature.new()

	signaler.connect("zero_health", creature, "set_current_target", [signaler])
	assert_connected(signaler, creature, "zero_health", "set_current_target")
	
	creature.remove_existing_connection(signaler)
	assert_not_connected(signaler, creature, "zero_health", "set_current_target")
	
	signaler.free()
	creature.free()


#func test_update_path_to_enemy():
#	var Creature = partial_double("res://Creatures/Creature/Creature.gd").new()
#	Creature.UpdatePathToEnemyTimer = UpdatePathToEnemyTimer.new()
#	stub(Creature, "remove_existing_connection").to_do_nothing()
#
#	var enemy = Enemy.new()
#	Creature.current_target = enemy


#func test_set_current_target():
#	var creature = partial_double(Creature).new()
#	stub(creature, "remove_existing_connection").to_do_nothing()
#
#	var enemy = Enemy.new()
#	creature.current_target = enemy
#	assert_eq(creature.current_enemy, enemy)
