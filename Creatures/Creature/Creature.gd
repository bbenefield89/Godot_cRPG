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

func _physics_process(delta):
	move_to_destination(delta)


func move_to_destination(delta: float) -> void:
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


func create_path_to_destination(
	event_position: Vector2,
	camera_position: Vector2 = Vector2(0,0)
):
	path = Navigation2d.get_simple_path(get_position(),
			event_position + camera_position)


func remove_existing_connection(enemy_stats):
	if enemy_stats.is_connected("zero_health", self, "set_current_target"):
		enemy_stats.disconnect("zero_health", self, "set_current_target")


func update_path_to_enemy():
	if current_target != null and is_instance_valid(current_target):
		create_path_to_destination(current_target.position)


func set_current_target(value: KinematicBody2D = null) -> void:
	if value != null and is_instance_valid(value):
		remove_existing_connection(value.Stats)
		value.Stats.connect("zero_health", self, "set_current_target")
		UpdatePathToEnemyTimer.start(update_path_to_enemy_cd)
	else:
		remove_existing_connection(current_target.Stats)
	current_target = value
