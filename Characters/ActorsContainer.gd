extends Node2D

signal open_esc_menu

var actors_selected := Array()
var is_selecting_actor := false

onready var actors_in_party = get_children()

func _ready():
	for actor in actors_in_party:
		var actorCollider = actor.get_node("SelectBox")
		actorCollider.connect("lmb_up", self,
				"select_only_this_actor", [actor])
		actorCollider.connect("lmb_up_shift", self,
				"select_actor", [actor])
		actorCollider.connect("lmb_down", self,
				"set_is_selecting_actor", [true])
		actorCollider.connect("on_mouse_exit", self, "set_is_selecting_actor",
				[false])


func _input(_event):
	for idx in range(actors_in_party.size()):
		if Input.is_action_just_pressed("select_actor_" + String(idx)):
			handle_key_input_select_actor(idx)
			
	if Input.is_action_just_pressed("select_all_actors"):
		 actors_selected = get_children()
	elif Input.is_action_just_pressed("open_esc_menu"):
		if actors_selected.size() == 0:
			emit_signal("open_esc_menu")
		else:
			actors_selected.clear()
	elif Input.is_action_just_pressed("stop_actor_actions"):
		for actor in actors_selected:
			actor.path = PoolVector2Array()
			actor.set_current_target(null)


func handle_key_input_select_actor(num_key_value: int) -> void:
	if get_child_count() > num_key_value:
		if Input.is_action_pressed("shift"):
			select_actor(get_child(num_key_value))
		else:
			select_only_this_actor(get_child(num_key_value))


func select_only_this_actor(actor: KinematicBody2D) -> void:
	actors_selected.clear()
	actors_selected.append(actor)


func select_actor(actor: KinematicBody2D) -> void:
	if actors_selected:
		for selected_actor in actors_selected:
			if selected_actor == actor:
				return
		actors_selected.append(actor)
	else:
		actors_selected.append(actor)


func is_actor_allowed_to_move(actor: KinematicBody2D) -> bool:
	var is_actor_selected = false
	if is_selecting_actor == false:
		for selected_actor in actors_selected:
			if selected_actor == actor:
				is_actor_selected = true
	return is_actor_selected


func set_selected_actors_target(value: KinematicBody2D) -> void:
	for actor in actors_selected:
		actor.set_current_target(value)


func set_is_selecting_actor(value: bool) -> void:
	is_selecting_actor = value

