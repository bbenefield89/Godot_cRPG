extends Area2D

onready var attack_cooldown_timer := $AttackCooldownTimer

var attack_cooldown_duration := 1.0 setget set_attack_cooldown_duration

func trigger_attack_cooldown() -> void:
	set_deferred("monitorable", false)
	attack_cooldown_timer.start(attack_cooldown_duration)


func set_attack_cooldown_duration(value: float) -> void:
	attack_cooldown_duration = value


func _on_AttackCooldownTimer_timeout():
	set_deferred("monitorable", true)
