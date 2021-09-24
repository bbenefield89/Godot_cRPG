extends Node2D

onready var ActorsContainer := $ActorsContainer
onready var EnemyContainer := $EnemyContainer
onready var Navigation2d := $Navigation2D
onready var MainCamera := $MainCamera
onready var PartyUI := $UILayer/BottomUI/HBoxContainer/PartyContainer

func _ready():
	connect_ActorsContainers()
	connect_PartyUI()
	connect_Actors()
	connect_Enemies()


func open_esc_menu(): ###
	print("Open ESC Menu") # Placeholder until we handle the ESC Menu UI


func connect_ActorsContainers() -> void: ###
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("open_esc_menu", self, "open_esc_menu")
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("alter_actors_portraits", PartyUI,
			"alter_actors_portraits")


func connect_PartyUI() -> void: ###
	# warning-ignore:return_value_discarded
	PartyUI.connect("party_ui_selecting_actor", ActorsContainer,
			"set_is_selecting_actor", [true])
	# warning-ignore:return_value_discarded
	PartyUI.connect("party_ui_not_selecting_actor", ActorsContainer,
			"set_is_selecting_actor", [false])
	# warning-ignore:return_value_discarded
	PartyUI.connect("party_ui_actor_selected", ActorsContainer,
			"select_only_this_actor_by_idx")
	# warning-ignore:return_value_discarded
	PartyUI.connect("party_ui_actor_selected_shift", ActorsContainer,
			"select_actor_by_idx")
	

func connect_Actors() -> void: ###
	for actor in ActorsContainer.get_children():
		actor.Navigation2d = Navigation2d
		actor.MainCamera = MainCamera


func connect_Enemies() -> void: ###
	for enemy in EnemyContainer.get_children():
		var SelectBox = enemy.get_node("SelectBox")
		enemy.Navigation2d = Navigation2d
		SelectBox.connect("lmb_up", ActorsContainer,
				"set_selected_actors_target", [enemy])
