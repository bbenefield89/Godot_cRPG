extends "res://Creatures/Creature/Creature.gd"

func _on_AggroRadius_body_entered(body):
	if not (current_target and is_instance_valid(current_target)):
		set_current_target(body)
		path = Navigation2d.get_simple_path(get_position(), body.position)


func _on_UpdatePathToEnemyTimer_timeout():
	update_path_to_enemy()
