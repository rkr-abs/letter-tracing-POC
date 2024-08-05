extends Node2D

@export_range(0.0, 1.0) var matchRatio: float = 1.0
@export var character: String = "A"
@export var fontSize: int = 16
@onready var lineContainer = $LineContainer
@onready var icon = $Icon
@onready var pen = $Line2D
@onready var control = $CanvasLayer/SubViewportContainer/SubViewport/Control

func _ready():
	control.character = character
	control.fontSize = fontSize
	pen.width = fontSize / 2

func _on_clear_pressed():
	icon.reset()
	for line in lineContainer.get_children():
		line.clear_points()
		line.queue_free()

func _on_check_pressed():
	var ratio: float = 1.0 - (float(icon.filteredPixels.size()) / float(icon.pixels.size()))

	if ratio >= matchRatio:
		print("level Completed")
	else:
		print("Try Again")
