extends HBoxContainer

func _ready():
	conceal()


func show(): ###
	modulate.a = 1


func conceal(): ###
	modulate.a = 0
