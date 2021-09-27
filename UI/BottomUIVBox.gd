extends VBoxContainer

onready var ActorBarContainerHidden := $ActorBarContainerHidden
onready var ActorBarContainer := $ActorBarContainer

func _ready():
	conceal()


func show():
	ActorBarContainerHidden.visible = false
	ActorBarContainer.visible = true


func conceal():
	ActorBarContainerHidden.visible = true
	ActorBarContainer.visible = false
