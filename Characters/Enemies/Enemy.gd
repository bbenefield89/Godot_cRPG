extends KinematicBody2D

onready var stats = $Stats
onready var hitbox = $HitBox

var Navigation2d := Navigation2D.new() setget set_navigation2d
var ActorsContainer := Node2D.new() setget set_actors_container

var path := PoolVector2Array() setget set_path

func _ready():
	hitbox.set_attack_cooldown_duration(stats.current_attack_speed)


func _on_HurtBox_area_entered(area):
	stats.set_health(stats.health - area.get_parent().get_node("Stats").damage)
	area.trigger_attack_cooldown()


func _on_Stats_zero_health():
	queue_free()


func _on_AggroRadius_body_entered(body):
	var simple_path : PoolVector2Array = Navigation2d.get_simple_path(
		get_position(),
		body.position)
	set_path(simple_path)


func _physics_process(delta):
	move_to_point_clicked(delta)


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


func set_path(value: PoolVector2Array) -> void:
	path = value


func set_navigation2d(value: Navigation2D) -> void:
	Navigation2d = value


func set_actors_container(value: Node2D) -> void:
	ActorsContainer = value
