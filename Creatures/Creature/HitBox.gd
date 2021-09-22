extends Area2D

signal enemy_entered_hitbox

var enemies_in_hitbox := []

onready var attack_cooldown_timer := $AttackCooldownTimer

func trigger_attack_cooldown(attack_cooldown_duration: float) -> void:
	set_deferred("monitoring", false)
	attack_cooldown_timer.start(attack_cooldown_duration)


func _on_HitBox_area_entered(area):
	enemies_in_hitbox.append(area)
	emit_signal("enemy_entered_hitbox", area)


func _on_HitBox_area_exited(area):
	var area_index = enemies_in_hitbox.find(area)
	enemies_in_hitbox.remove(area_index)
