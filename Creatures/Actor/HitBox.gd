extends "res://Creatures/Creature/HitBox.gd"

func _on_AttackCooldownTimer_timeout():
	set_deferred("monitoring", true)
