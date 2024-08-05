extends CharacterBody2D

var isEntered: bool = false
var isPressed: bool = false
signal dragCharacter(castPosition)

func _input(event):
	if !isEntered:
		return

	if event is InputEventScreenTouch:
		isPressed = event.is_pressed()
		dragCharacter.emit(event.position)
	if event is InputEventScreenDrag:
		dragCharacter.emit(event.position)

func _on_mouse_entered():
	isEntered = true

func _on_mouse_exited():
	isEntered = false
