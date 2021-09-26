extends Node

func map_actor_to_dict(actor: KinematicBody2D) -> Dictionary:
	return {
		"name": actor.name,
		"health": actor.Stats.health,
		"position": { "x": actor.position.x, "y": actor.position.y },
	}


func map_dict_to_actor(data: Dictionary, actor: KinematicBody2D) -> void:
	actor.name = data.name
	actor.Stats.health = data.health
	actor.position = Vector2(data.position.x, data.position.y)
