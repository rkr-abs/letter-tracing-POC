extends Path2D

@export var line2d: Line2D
@onready var pathFollow = $PathFollow2D
var isFilled: bool = false

func _ready():
	pathFollow.progress_ratio = 0

func _on_character_body_2d_drag_character(castPosition):
	var closest_offset = curve.get_closest_offset(castPosition)
	pathFollow.progress = closest_offset
	if !isFilled:
		line2d.add_point(pathFollow.position - line2d.get_parent().position)
		isFilled = pathFollow.progress_ratio >= 0.9
