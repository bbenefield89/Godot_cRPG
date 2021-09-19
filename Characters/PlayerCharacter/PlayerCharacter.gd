extends KinematicBody2D

export(float) var update_path_to_enemy_cd := 0.5

var path := PoolVector2Array() setget set_path
var Navigation2d := Navigation2D.new() setget set_navigation2d
var MainCamera := Camera2D.new() setget set_main_camera
var ActorsContainer := Node2D.new() setget set_actors_container
var current_target = null setget set_current_target

onready var stats := $Stats
onready var hitbox := $HitBox
onready var UpdatePathToEnemyTimer := $UpdatePathToEnemyTimer

func _ready():
	hitbox.set_attack_cooldown_duration(stats.current_attack_speed)


func _input(event):
	if (
		Input.is_action_just_released("pc_move") and
		event is InputEventMouseButton and
		ActorsContainer.is_actor_allowed_to_move(self)
	):
		handle_lmb_click(event)


func _physics_process(delta):
	move_to_point_clicked(delta)


func handle_lmb_click(event):
	if not event is KinematicBody2D:
		current_target = null
	var simple_path : PoolVector2Array = Navigation2d.get_simple_path(
		get_position(),
		event.position + MainCamera.get_camera_position())
	set_path(simple_path)


func move_to_point_clicked(delta: float) -> void:
	var distance_to_walk = stats.current_movement_speed * delta
	
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		
		if distance_to_walk <= distance_to_next_point:
			# warning-ignore:return_value_discarded
			move_and_slide(
				position.direction_to(path[0]) * stats.current_movement_speed)
		else:
			path.remove(0)
		
		distance_to_walk -= distance_to_next_point


func _on_HurtBox_area_entered(area):
	stats.health -= area.get_parent().stats.damage
	area.trigger_attack_cooldown()


func _on_Stats_zero_health():
	queue_free()


func _on_UpdatePathToEnemyTimer_timeout():
	if current_target != null:
		handle_lmb_click(current_target)


func _on_HitBox_area_entered(area):
	var enemy : KinematicBody2D = area.get_parent()
	if current_target != null:
		if enemy.name == current_target.name:
			set_path(PoolVector2Array())
			enemy.stats.health -= stats.damage
			if enemy.stats.health <= 0:
				current_target = null


func set_path(value: PoolVector2Array) -> void:
	path = value


func set_main_camera(value: Camera2D) -> void:
	MainCamera = value


func set_navigation2d(value: Navigation2D) -> void:
	Navigation2d = value


func set_actors_container(value: Node2D) -> void:
	ActorsContainer = value


func set_current_target(value) -> void:
	if value != null:
		UpdatePathToEnemyTimer.start(update_path_to_enemy_cd)
	current_target = value

