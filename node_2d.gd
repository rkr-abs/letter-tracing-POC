extends Node2D

@onready var lineContainer = $LineContainer

func _on_clear_pressed():
	for line in lineContainer.get_children():
		line.clear_points()
		line.queue_free()

func _on_check_pressed():
	pass # Replace with function body.
