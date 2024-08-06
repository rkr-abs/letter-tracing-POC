extends Node2D

@export_range(0.0, 1.0) var matchRatio: float = 0.9
@export var fontPaths: FontFile
@export var char: String = "A":
	set(newChar):
		char = newChar
		_setChar()
@export var fontSize: int = 48
@export var animationDelay = 1.0
@onready var hintIconPath = $HintIconPath
@onready var path_2d = $Path2D
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var line2d = $Line2D
@onready var container = $LinesContainer
@onready var pensContainer = $PensContainer
@onready var polygon_2d = $Polygon2D
@onready var penLine = $Pen
var defaultFont
var curPen
var charPaths
var charOutlines
var isIconMoving = false
var filteredPaths = []

func _ready():
	defaultFont = get_tree().root.get_theme_default_font()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_moveHintIcon()
	
	if event is InputEventScreenTouch and event.pressed:
		curPen = penLine.duplicate(true)
		pensContainer.add_child(curPen)

	if event is InputEventScreenDrag:
		_handleDraw(event)

func _setChar():
	_drawChar()
	_addPath()

func _drawChar():
	charOutlines = getPaths(defaultFont, char)
	
	for paths in charOutlines:
		#_drawLine(paths)
		_drawPolygon(paths)

func _addPath():
	var curve  = Curve2D.new()
	charPaths = getPaths(defaultFont, char)
	for point in charPaths[0]:
		point = line2d.position + point * line2d.scale
		curve.add_point(point)
	path_2d.curve = curve
	$Path2D/PathFollow2D.progress_ratio = 0
	filteredPaths = charPaths[0]
	
func getPaths(font, char):
	var font_rid = font.get_rids()[0]
	var text_server = TextServerManager.get_primary_interface()
	var glyph_index = text_server.font_get_glyph_index(font_rid, fontSize, char.unicode_at(0), 0)
	var contours = text_server.font_get_glyph_contours(font_rid, fontSize, glyph_index)
	var contourPoints = _getContourPoints(contours)

	return contourPoints.map(func(points: Array):
		return points.map(func(point):
			var pos = Vector2(point.x, point.y)
			return pos))

func _getContourPoints(contours):
	var startIdx = 0
	var points = []
	for endIdx in contours.contours:
		endIdx += 1
		var slicedPoints = contours.points.slice(startIdx, endIdx)
		points.append(slicedPoints)
		startIdx = endIdx
		
	return points

func _drawPolygon(paths):
	var polygon2d = polygon_2d.duplicate(true)
	polygon2d.polygon = paths
	container.add_child(polygon2d)

func _drawLine(paths):
	var line = line2d.duplicate(true)
	for path in paths:
		line.add_point(path)
	container.add_child(line)

func _clearBoard():
	container.get_children().map(func(child): child.queue_free())

func _moveHintIcon():
	if isIconMoving:
		return

	var origin = hintIconPath.transform.origin
	hintIconPath.emitParticle(true)
	var line = container.get_children().filter(func(child): return child is Polygon2D)[0]
	isIconMoving = true
	#for line in lines:
	for point in line.polygon:
		var tween = get_tree().create_tween()
		tween.tween_property(hintIconPath, "position", line.position + point * line.scale, animationDelay)
		await get_tree().create_timer(animationDelay).timeout
	hintIconPath.position = origin
	hintIconPath.emitParticle(false)
	isIconMoving = false

func _handleDraw(event):
	var mousePos = event.position
	var point = mousePos
	filteredPaths = filteredPaths.filter(
		func(pixel):
			pixel = line2d.position + pixel * line2d.scale
			return point.distance_to(pixel) > penLine.width
	)

	curPen.add_point(mousePos)

func flat(array):
	var res = []
	array.map(func(arr): res.append_array(arr))
	return res

func _on_character_changed(newChar):
	_clearBoard()
	char = newChar

func _on_clear_pressed():
	filteredPaths = charOutlines[0]
	for pen in pensContainer.get_children():
		pen.clear_points()
		pen.queue_free()

func _on_check_pressed():
	if path_2d.get_node("PathFollow2D").get_progress_ratio() != 1.0:
		return
	var ratio: float = 1.0 - (float(filteredPaths.size()) / float(charOutlines[0].size()))

	if ratio >= matchRatio:
		print("level Completed")
	else:
		print("Try Again")
