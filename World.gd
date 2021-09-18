extends Node2D

onready var ActorsContainer := $ActorsContainer
onready var EnemyContainer := $EnemyContainer
onready var Navigation2d := $Navigation2D
onready var MainCamera := $MainCamera

func _ready():
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("open_esc_menu", self, "open_esc_menu")

	for actor in ActorsContainer.get_children():
		actor.set_navigation2d(Navigation2d)
		actor.set_main_camera(MainCamera)
		actor.set_actors_container(ActorsContainer)

	for enemy in EnemyContainer.get_children():
		var collider = enemy.get_node("Collider")
		enemy.set_navigation2d(Navigation2d)
		enemy.set_actors_container(EnemyContainer)
		collider.connect("lmb_released_on_enemy_collider", ActorsContainer,
				"path_to_enemy", [enemy])
		collider.connect("lmb_released_on_enemy_collider", ActorsContainer,
				"set_selected_actors_target", [enemy])

func open_esc_menu():
	print("Open ESC Menu")
