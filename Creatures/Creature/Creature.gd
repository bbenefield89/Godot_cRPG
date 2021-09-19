extends KinematicBody2D

export(float) var update_path_to_enemy_cd = 0.5

var path := PoolVector2Array()
var Navigation2d := Navigation2D.new()
var current_target = null setget set_current_target

onready var whoami := name
onready var Stats := $Stats
onready var HitBox := $HitBox
onready var ContainerNode := get_parent()
onready var UpdatePathToEnemyTimer := $UpdatePathToEnemyTimer

func create_path_to_destination(
	event_position: Vector2,
	camera_position: Vector2 = Vector2(0,0)
):
	path = Navigation2d.get_simple_path(get_position(),
			event_position + camera_position)


func set_current_target(value: KinematicBody2D = null) -> void:
	if value != null and is_instance_valid(value):
		remove_existing_connection(value.Stats)
		value.Stats.connect("zero_health", self, "set_current_target")
		UpdatePathToEnemyTimer.start(update_path_to_enemy_cd)
	else:
		remove_existing_connection(current_target.Stats)
#		current_target.Stats.disconnect("zero_health", self,
#				"set_current_target")
	current_target = value


func remove_existing_connection(enemy_stats):
	if enemy_stats.is_connected("zero_health", self, "set_current_target"):
		enemy_stats.disconnect("zero_health", self, "set_current_target")


func update_path_to_enemy():
	if current_target != null and is_instance_valid(current_target):
		create_path_to_destination(current_target.position)
