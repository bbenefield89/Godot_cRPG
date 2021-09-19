extends "res://Creatures/Creature/Creature.gd"

func _on_HurtBox_area_entered(_area):
	"""
	Not too sure what to do with this function right now
	"""
	pass
#	stats.set_health(stats.health - area.get_parent().get_node("Stats").damage)
#	area.trigger_attack_cooldown()


func _physics_process(delta):
	move_to_point_clicked(delta)


func move_to_point_clicked(delta: float) -> void:
	var distance_to_walk = Stats.current_movement_speed * delta
	
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		
		if distance_to_walk <= distance_to_next_point:
			# warning-ignore:return_value_discarded
			move_and_slide(
				position.direction_to(path[0]) * Stats.current_movement_speed)
		else:
			path.remove(0)
		
		distance_to_walk -= distance_to_next_point


func _on_Stats_zero_health():
	queue_free()


func _on_AggroRadius_body_entered(body):
	if not (current_target and is_instance_valid(current_target)):
		print("Aggro on ", body.name)
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
