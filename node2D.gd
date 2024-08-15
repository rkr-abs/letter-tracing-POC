extends Node2D

@export var characterScene: PackedScene
@export_range(0.0, 1.0) var matchRatio: float = 0.9
@export var fontPaths: FontFile
@export var char: String = "A":
	set(newChar):
		char = newChar
		_setChar()
@export var fontSize: int = 48
@export var animationDelay = 1.0
@onready var hintIconPath = $HintIconPath
@onready var container = $Container
@onready var polygon2d = $Polygon2D
@onready var penLine = $Pen
@onready var label = $HUI/Control/Label
@onready var hintIconStartPos = hintIconPath.position
var charPaths
var isIconMoving = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_moveHintIcon()

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
	#label.text = char
	_createPaths()

func _createPaths():
	charPaths = getPaths(fontPaths, char)
	charPaths.reverse()
	var character = characterScene.instantiate()
	character.config = {"paths": charPaths, "label": char}
	container.add_child(character)
	
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
	for node in [label, container]:
		node.get_children().map(func(child): child.queue_free())

func flat(array):
	var res = []
	array.map(func(arr): res.append_array(arr))
	return res

func normalizeToPolygonPos(vector2d):
	return polygon2d.position + vector2d * polygon2d.scale

func _on_character_changed(newChar):
	_clearBoard()
	char = newChar

func _on_check_pressed():
	var isCompleted = container.get_children().all(func(child): return child.isFilled)

	if isCompleted:
		print("level Completed")
	else:
		print("Try Again")
