extends PathFollow2D
@onready var path_2d = $".."

func _on_character_body_2d_drag_character(castPosition):
	var closest_point = path_2d.curve.get_closest_point(castPosition)
	var closest_offset = path_2d.curve.get_closest_offset(castPosition)
	var distance = castPosition.distance_to(closest_point)
	var direction = castPosition.direction_to(closest_point)
	prints(closest_offset, closest_point, distance, direction)
	progress = closest_offset
