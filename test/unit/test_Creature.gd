extends "res://addons/gut/test.gd"

var Creature = load("res://Creatures/Creature/Creature.gd")
var Stats = load("res://Creatures/Creature/Stats.gd")
var HitBox = load("res://Creatures/Actor/HitBox.gd")

class Enemy extends KinematicBody2D:
	var Stats = StatsMock.new()
	var UpdatePathToEnemyTimer = Timer.new()


class StatsMock:
	signal zero_health
	var health = 1
	var damage = 1
	var current_attack_speed = 1
	var current_movement_speed = 1


class UpdatePathToEnemyTimer extends Timer:
	func start(time_sec: float = -1):
		pass

class Navigation2d extends Navigation2D:
	func get_simple_path(a: Vector2, b: Vector2, c: bool = true) -> PoolVector2Array:
		return PoolVector2Array([Vector2(0, 0)])


class Area2d extends Area2D:
	func get_parent():
		return Enemy.new()

func test_create_path_to_destination():
	var creature = Creature.new()
	creature.Navigation2d = Navigation2d.new()
	creature.create_path_to_destination(Vector2(0, 0))
	assert_eq(creature.path, PoolVector2Array([Vector2(0, 0)]))
	creature.Navigation2d.free()
	creature.free()


func test_remove_existing_connection():
	var signaler = StatsMock.new()
	var creature = Creature.new()
	signaler.connect("zero_health", creature, "set_current_target", [signaler])
	assert_connected(signaler, creature, "zero_health", "set_current_target")
	creature.remove_existing_connection(signaler)
	assert_not_connected(signaler, creature, "zero_health", "set_current_target")
	creature.free()


func test_update_path_to_enemy():
	var creature = partial_double(Creature).new()
	var enemy = Enemy.new()
	creature.UpdatePathToEnemyTimer = UpdatePathToEnemyTimer.new()
	stub(creature, "remove_existing_connection").to_do_nothing()
	stub(creature, "create_path_to_destination").to_do_nothing()
	creature.current_target = enemy
	creature.update_path_to_enemy()
	assert_called(creature, "create_path_to_destination")


func test_set_current_target():
	var creature = partial_double(Creature).new()
	var enemy = Enemy.new()
	creature.UpdatePathToEnemyTimer = UpdatePathToEnemyTimer.new()
	stub(creature, "remove_existing_connection").to_do_nothing()
	creature.current_target = enemy
	assert_true(creature.current_target == enemy)


func test__on_HitBox_area_entered():
	var creature = partial_double(Creature).new()
	var area = Area2d.new()
	creature.current_target = Enemy.new()
	creature.Stats = StatsMock.new()
	creature.HitBox = double(HitBox).new()
	creature._on_HitBox_area_entered(area)
	assert_true(creature.path == PoolVector2Array())
	assert_called(creature.HitBox, "trigger_attack_cooldown")
