extends PathFollow2D
@onready var path_2d = $".."

func _on_character_body_2d_drag_character(castPosition):
	var closest_offset = path_2d.curve.get_closest_offset(castPosition)
	progress = closest_offset
