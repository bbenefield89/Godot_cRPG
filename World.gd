extends Node2D

var ActorScene := preload("res://Creatures/Actor/Actor.tscn")
var ActorsPortraitScene := preload("res://UI/PartyMemberPortrait.tscn")
var DataMapper := preload("res://saves/DataMapper.gd").new()
var save_data := {}

onready var ActorsContainer := $ActorsContainer
onready var EnemyContainer := $EnemyContainer
onready var Navigation2d := $Navigation2D
onready var MainCamera := $MainCamera
onready var PartyUI := $UILayer/BottomUI/BottomUIVBox/HBoxContainer/PartyContainer
onready var ActorBar := $UILayer/BottomUI/BottomUIVBox/ActorBarContainer
onready var BottomUIVBox := $UILayer/BottomUI/BottomUIVBox

func _ready():
	load_save("quick_save") # Only run on ready for dev purposes
	connect_ActorsContainers()
	connect_PartyUI()
	connect_Actors()
	connect_Enemies()
	connect_ActorBarButtons()


func _input(event):
	if event.is_action_pressed("quick_save"):
		save_game("quick_save")
		print("Quick Save Complete")


func save_game(file_name: String) -> void:
	var save_file := File.new()
	# warning-ignore:return_value_discarded
	save_file.open("res://saves/%s.json" % file_name, File.WRITE)
	save_data.actors.actors_in_party.clear()
	for actor in ActorsContainer.actors_in_party:
		save_data.actors.actors_in_party.append(DataMapper.map_actor_to_dict(actor))
	save_file.store_string(to_json(save_data))
	save_file.close()


func load_save(file_name: String) -> void:
	var save_file := File.new()
	if save_file.open("res://saves/%s.json" % file_name, File.READ) == OK:
		var save_file_json = JSON.parse(save_file.get_as_text())
		if save_file_json.error == OK:
			save_data = save_file_json.result
			handle_save_data()
	else:
		print('Save "%s" not found' % file_name) # Need to handle this error appropriately in the future
	save_file.close()


func handle_save_data() -> void:
	load_actors()


func load_actors() -> void:
	var actors_portraits = []
	for actor in save_data.actors.actors_in_party:
		var actor_tscn = ActorScene.instance()
		ActorsContainer.add_actor_to_party(actor_tscn)
		DataMapper.map_dict_to_actor(actor, actor_tscn)
		
		var ActorsPortrait = ActorsPortraitScene.instance()
		actors_portraits.append(ActorsPortrait)
		ActorsPortrait.name = actor.name
		PartyUI.add_child(ActorsPortrait)
		connect_SelectActorButton(ActorsPortrait.get_node("SelectActorButton"))
	PartyUI.actors_portraits = actors_portraits


func open_esc_menu() -> void: ###
	print("Open ESC Menu") # Placeholder until we handle the ESC Menu UI


func connect_ActorsContainers() -> void:
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("open_esc_menu", self, "open_esc_menu")
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("alter_actors_portraits", PartyUI,
			"alter_actors_portraits")
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("show_actor_bar", BottomUIVBox, "show")
	# warning-ignore:return_value_discarded
	ActorsContainer.connect("conceal_actor_bar", BottomUIVBox, "conceal")


func connect_PartyUI() -> void:
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
	

func connect_Actors() -> void:
	for actor in ActorsContainer.get_children():
		actor.Navigation2d = Navigation2d
		actor.MainCamera = MainCamera


func connect_Enemies() -> void:
	for enemy in EnemyContainer.get_children():
		var SelectBox = enemy.get_node("SelectBox")
		enemy.Navigation2d = Navigation2d
		SelectBox.connect("lmb_up", ActorsContainer,
				"set_selected_actors_target", [enemy])


func connect_SelectActorButton(button: Button) -> void:
	# warning-ignore:return_value_discarded
	button.connect("button_down", PartyUI, "_on_SelectActorButton_button_down")
	# warning-ignore:return_value_discarded
	button.connect("party_ui_actor_selected", PartyUI,
			"_on_SelectActorButton_party_ui_actor_selected")
	# warning-ignore:return_value_discarded
	button.connect("party_ui_actor_selected_shift", PartyUI,
			"_on_SelectActorButton_party_ui_actor_selected_shift")


func connect_ActorBarButtons() -> void:
	for ButtonContainer in ActorBar.get_children():
		if ButtonContainer.name != "SpellsMargin":
			for button in ButtonContainer.get_children():
				button.connect("button_down", ActorsContainer,
						"set_is_selecting_actor", [true])
				button.connect("button_up", ActorsContainer,
						"set_is_selecting_actor", [false])
