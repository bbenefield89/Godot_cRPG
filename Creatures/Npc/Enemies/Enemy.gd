extends "res://Creatures/Creature/Creature.gd"

func _on_Stats_zero_health():
	queue_free()


func _on_AggroRadius_body_entered(body):
	if not (current_target and is_instance_valid(current_target)):
		set_current_target(body)
		path = Navigation2d.get_simple_path(get_position(), body.position)


func _on_UpdatePathToEnemyTimer_timeout():
	update_path_to_enemy()


func _on_HitBox_area_entered(area):
	var enemy : KinematicBody2D = area.get_parent()
	if (current_target != null and is_instance_valid(current_target) and
				enemy.name == current_target.name):
			path = PoolVector2Array()
			enemy.Stats.health -= Stats.damage
			HitBox.trigger_attack_cooldown(Stats.current_attack_speed)
