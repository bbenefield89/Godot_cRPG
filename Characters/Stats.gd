extends Node

export(int) var max_health := 1 setget set_max_health
export(int) var damage := 1
export(int) var base_movement_speed := 100
export(float) var base_attack_speed := 2.0

onready var health := max_health setget set_health
onready var current_movement_speed := base_movement_speed
onready var current_attack_speed := base_attack_speed

signal zero_health

func set_max_health(value):
	max_health = value
	
	
func set_health(value: int) -> void:
	health = value
	if health < 1:
		emit_signal("zero_health")
