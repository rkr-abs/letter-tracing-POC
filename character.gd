extends Node2D

const PATH = preload("res://path.tscn")
@onready var label = $Label
@onready var pen = $Pen
var config

func _ready():
	label.text = config.label
	for points in config.paths:
		var penClone = pen.duplicate(true)
		label.add_child(penClone)
		var path2d = PATH.instantiate()
		path2d.pen = penClone
		var curve  = Curve2D.new()
		for point in points:
			curve.add_point(point)
		path2d.curve = curve
		add_child(path2d)

