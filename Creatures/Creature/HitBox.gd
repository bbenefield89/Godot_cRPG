extends Area2D

onready var attack_cooldown_timer := $AttackCooldownTimer

func trigger_attack_cooldown(attack_cooldown_duration: float) -> void:
	set_deferred("monitoring", false)
	attack_cooldown_timer.start(attack_cooldown_duration)
