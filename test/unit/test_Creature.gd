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
	var weapon = { "attack_type": "standard" }
	func _init(a = "standard"):
		weapon.attack_type = a


class UpdatePathToEnemyTimer extends Timer:
	func start(time_sec: float = -1):
		pass

class Navigation2d extends Navigation2D:
	func get_simple_path(a: Vector2, b: Vector2, c: bool = true) -> PoolVector2Array:
		return PoolVector2Array([Vector2(0, 0)])


class Area2d extends Area2D:
	var parent = Enemy.new() setget , get_parent
	func get_parent():
		return parent


class TimerMock extends Timer:
	pass


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


###
# Cant figure out how to test a method with a yield
###
#func test_attack():
#	var creature = partial_double(Creature).new()
#	var area = Area2d.new()
#	var timer_mock = TimerMock
#	creature.current_target = Enemy.new()
#	stub(creature, "handle_weapon_attack_type")
#	stub(creature, "create_attack_windup_timer").to_return(timer_mock.new())
#	creature.attack(area)
#	yield_for(1)
#	assert_true(creature.path == PoolVector2Array())
#	assert_called(creature, "handle_weapon_attack_type")


func test_handle_weapon_attack_type():
	var creature = partial_double(Creature).new()
	creature.HitBox = double(HitBox).new()
	stub(creature.HitBox, "trigger_attack_cooldown")
	creature.Stats = StatsMock.new()
	stub(creature, "attack_targets")
	var area = Area2d.new()
	creature.handle_weapon_attack_type(area)
	assert_called(creature, "attack_targets", [[area]])
	assert_called(creature.HitBox, "trigger_attack_cooldown")
	
	creature.HitBox = partial_double(HitBox).new()
	creature.Stats = StatsMock.new("cleave")
	stub(creature.HitBox, "trigger_attack_cooldown")
	creature.handle_weapon_attack_type(area)
	assert_called(creature, "attack_targets", [creature.HitBox.enemies_in_hitbox])
	assert_called(creature.HitBox, "trigger_attack_cooldown")


func test_attack_targets():
	var creature = partial_double(Creature).new()
	creature.Stats = StatsMock.new()
	var targets = [Area2d.new()]
	creature.attack_targets(targets)
	for target in targets:
		assert_true(target.get_parent().Stats.health < 1)


func test_set_current_target():
	var creature = partial_double(Creature).new()
	var enemy = Enemy.new()
	creature.UpdatePathToEnemyTimer = UpdatePathToEnemyTimer.new()
	stub(creature, "remove_existing_connection").to_do_nothing()
	creature.current_target = enemy
	assert_true(creature.current_target == enemy)
