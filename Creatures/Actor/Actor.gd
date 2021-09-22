extends "res://Creatures/Creature/Creature.gd"

var MainCamera := Camera2D.new()

var HitBoxAttackCooldownTimer = null

func _ready():
	HitBoxAttackCooldownTimer = $HitBox/AttackCooldownTimer


func _ready():
	HitBox.connect("enemy_entered_hitbox", self, "attack")


func _input(event):
	if (Input.is_action_just_released("pc_move") and
			event is InputEventMouseButton and
			ContainerNode.is_actor_allowed_to_move(self)):
		current_target = null
		create_path_to_destination(event.position * MainCamera.zoom,
				MainCamera.position)


func attack(area: Area2D):
	var enemy : KinematicBody2D = area.get_parent()
	if (current_target != null and is_instance_valid(current_target)
			and enemy.name == current_target.name):
		path = PoolVector2Array()
		handle_weapon_attack_type(area)


func handle_weapon_attack_type(area: Area2D):
	if Stats.weapon.attack_type == "cleave":
		for hitbox in HitBox.enemies_in_hitbox:
			attack_targets(HitBox.enemies_in_hitbox)
	else:
		attack_targets([area])
	HitBox.trigger_attack_cooldown(Stats.current_attack_speed)


func attack_targets(targets: Array) -> void:
	for target in targets:
		target.get_parent().Stats.health -= Stats.damage


func _on_Stats_zero_health():
	queue_free()


func _on_UpdatePathToEnemyTimer_timeout():
	update_path_to_enemy()
