extends "res://addons/gut/test.gd"

var HitBox = load("res://Creatures/Actor/HitBox.gd")

func test__on_AttackCooldownTimer_timeout():
	var hitbox = partial_double(HitBox).new()
	hitbox._on_AttackCooldownTimer_timeout()
	assert_eq(hitbox.monitoring, true)
