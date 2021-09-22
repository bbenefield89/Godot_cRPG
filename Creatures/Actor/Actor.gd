extends "res://Creatures/Creature/Creature.gd"

var MainCamera := Camera2D.new()

var HitBoxAttackCooldownTimer = null

func _ready():
	HitBoxAttackCooldownTimer = $HitBox/AttackCooldownTimer


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
