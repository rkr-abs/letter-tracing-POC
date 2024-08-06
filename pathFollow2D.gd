extends Path2D
@onready var path_follow_2d = $PathFollow2D

func _on_character_body_2d_drag_character(castPosition):
	var closest_offset = curve.get_closest_offset(castPosition)
	path_follow_2d.progress = closest_offset
