extends Node2D

@export var pathScene: PackedScene
@export_range(0.0, 1.0) var matchRatio: float = 0.9
@export var fontPaths: FontFile
@export var char: String = "A":
	set(newChar):
		char = newChar
		_setChar()
@export var fontSize: int = 48
@export var animationDelay = 1.0
@onready var hintIconPath = $HintIconPath
@onready var line2d = $Line2D
@onready var container = $LinesContainer
@onready var pensContainer = $PensContainer
@onready var polygon2d = $Polygon2D
@onready var penLine = $Pen
@onready var label = $HUI/Control/Label
@onready var hintIconStartPos = hintIconPath.position
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

func _moveHintIcon():
	if isIconMoving:
		return

	hintIconPath.emitParticle(true)
	isIconMoving = true
	for points in charPaths:
		for point in points:
			var tween = get_tree().create_tween()
			tween.tween_property(hintIconPath, "position", normalizeToPolygonPos(point), animationDelay)
			await get_tree().create_timer(animationDelay).timeout
	hintIconPath.position = hintIconStartPos
	hintIconPath.emitParticle(false)
	isIconMoving = false

func _setChar():
	_createPaths()

func _createPaths():
	charPaths = getPaths(fontPaths, char)
	charPaths.reverse()
	for points in charPaths:
		var path2d = pathScene.instantiate()
		var curve  = Curve2D.new()
		var lineNode = penLine.duplicate(true)
		label.add_child(lineNode)
		path2d.line2d = lineNode
		for point in points:
			curve.add_point( normalizeToPolygonPos(point))
		path2d.curve = curve
		add_child(path2d)
	
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

func _clearBoard():
	container.get_children().map(func(child): child.queue_free())

func flat(array):
	var res = []
	array.map(func(arr): res.append_array(arr))
	return res

func normalizeToPolygonPos(vector2d):
	return polygon2d.position + vector2d * polygon2d.scale

func _on_character_changed(newChar):
	_clearBoard()
	char = newChar

func _on_clear_pressed():
	filteredPaths = charOutlines[0]
	for pen in pensContainer.get_children():
		pen.clear_points()
		pen.queue_free()

func _on_check_pressed():
	var ratio: float = 1.0 - (float(filteredPaths.size()) / float(charOutlines[0].size()))

	if ratio >= matchRatio:
		print("level Completed")
	else:
		print("Try Again")
