extends "res://addons/gut/test.gd"

var Stats = load("res://Creatures/Creature/Stats.gd").new()

func test_set_max_health():
	Stats.set_max_health(10)
	assert_eq(Stats.max_health, 10, "max_health equals 10")


func test_set_health():
	watch_signals(Stats)
	Stats.set_health(0)
	assert_signal_emitted(Stats, "zero_health", "zero_health was emitted")
