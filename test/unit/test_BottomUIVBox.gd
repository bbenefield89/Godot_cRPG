extends "res://addons/gut/test.gd"

var ActorBarContainer := load("res://UI/ActorBarContainer.gd")
var BottomUIVBox := load("res://UI/BottomUIVBox.tscn")

func test_show():
	var Box = partial_double(BottomUIVBox).instance()
	add_child_autofree(Box)
	Box.show()
	assert_eq(Box.ActorBarContainerHidden.visible, false)
	assert_eq(Box.ActorBarContainer.visible, true)


func test_conceal():
	var Box = partial_double(BottomUIVBox).instance()
	add_child_autofree(Box)
	Box.conceal()
	assert_eq(Box.ActorBarContainerHidden.visible, true)
	assert_eq(Box.ActorBarContainer.visible, false)
