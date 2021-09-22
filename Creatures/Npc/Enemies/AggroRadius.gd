extends Area2D

export(float) var aggro_radius_cd_timer := 1.0

onready var AggroRadiusTimer := $AggroRadiusTimer

func _on_AggroRadius_body_entered(body):
	set_deferred("monitoring", false)
	AggroRadiusTimer.start(aggro_radius_cd_timer)


func _on_AggroRadiusTimer_timeout():
	set_deferred("monitoring", true)
