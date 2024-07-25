extends Node2D

@onready var line_2d = $Line2D

func _on_clear_pressed():
	for child in line_2d.get_children():
		child.clear_points()
		child.queue_free()

func _on_check_pressed():
	pass # Replace with function body.
