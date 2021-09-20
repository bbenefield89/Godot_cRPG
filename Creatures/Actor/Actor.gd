extends "res://Creatures/Creature/Creature.gd"

var MainCamera := Camera2D.new()

onready var HitBoxAttackCooldownTimer := $HitBox/AttackCooldownTimer

func _input(event):
	if (Input.is_action_just_released("pc_move") and
			event is InputEventMouseButton and
			ContainerNode.is_actor_allowed_to_move(self)):
		current_target = null
		create_path_to_destination(event.position * MainCamera.zoom,
				MainCamera.position)


func _on_Stats_zero_health():
	queue_free()


func _on_UpdatePathToEnemyTimer_timeout():
	update_path_to_enemy()


func _on_HitBox_area_entered(area):
	var enemy : KinematicBody2D = area.get_parent()
	if (current_target != null and is_instance_valid(current_target) and
				enemy.name == current_target.name):
			path = PoolVector2Array()
			enemy.Stats.health -= Stats.damage
			HitBox.trigger_attack_cooldown(Stats.current_attack_speed)
