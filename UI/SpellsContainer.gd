extends HBoxContainer

var Essential := preload("res://UI/Essential.tscn")

func _ready():
	var spells = [
		{
			"name": "Fireball", "cost": 1, "dmg": 1, "range": 1,
		},
	]
	create_spell_containers(spells)


func create_spell_containers(spells):
	for spell in spells:
		var spell_ui := Essential.instance()
		spell_ui.get_node("Button").text = spell.name
		add_child(spell_ui)
