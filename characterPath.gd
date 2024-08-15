extends Path2D

@export var pen: Line2D
@onready var pathFollow = $PathFollow2D
@onready var characterBody = $PathFollow2D/CharacterBody2D
var isFilled: bool = false
var bakedPoints: Array

func _ready():
	pathFollow.progress_ratio = 0
	curve.set_bake_interval(40)
	bakedPoints = curve.get_baked_points()

func _on_character_body_2d_drag_character(castPosition):
	var closest_offset = curve.get_closest_offset(get_parent().to_local(castPosition))

	if abs(closest_offset - pathFollow.progress) > 30:
		return

	pathFollow.progress = closest_offset
	if !bakedPoints.is_empty() and pathFollow.position.distance_to(bakedPoints.front()) < 10:
		pen.add_point(bakedPoints.pop_front() - pen.get_parent().position)

	if !isFilled:
		isFilled = pathFollow.progress_ratio >= 0.9
