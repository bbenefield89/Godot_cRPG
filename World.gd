extends Node2D

onready var ActorsContainer := $ActorsContainer
onready var EnemyContainer := $EnemyContainer
onready var Navigation2d := $Navigation2D
onready var MainCamera := $MainCamera

func _ready():
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("open_esc_menu", self, "open_esc_menu")

	for actor in ActorsContainer.get_children():
		actor.Navigation2d = Navigation2d
		actor.MainCamera = MainCamera

	for enemy in EnemyContainer.get_children():
		var collider = enemy.get_node("SelectBox")
		enemy.Navigation2d = Navigation2d
		collider.connect("lmb_up", ActorsContainer,
				"set_selected_actors_target", [enemy])


func open_esc_menu():
	print("Open ESC Menu")
