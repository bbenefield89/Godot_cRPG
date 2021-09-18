extends Area2D

export(float) var aggro_radius_disabled_duration = 0.5


func _on_AggroRadius_body_entered(_body):
	set_deferred("monitorable", false)
	$AggroRadiusTimer.start(aggro_radius_disabled_duration)


func _on_AggroRadiusTimer_timeout():
	set_deferred("monitorable", true)
