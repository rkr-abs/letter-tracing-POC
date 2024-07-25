extends Sprite2D

@export var maskColors: Array[Color] = [Color("white")]
@export var defaultInk: int = 200
@export var canDraw: bool = true: 
	get: return ink > 0

@onready var line2D: Line2D = $"../Line2D"
@onready var lineContainer = $"../LineContainer"

var mousePos: Vector2
var image: Image
var imageSize: Vector2i
var pixels: Array = []
var pen: Line2D
var ink: int

func _ready():
	image = Image.load_from_file("res://icon.svg")
	imageSize = image.get_size()
	var textureNormal = ImageTexture.create_from_image(image)
	texture = textureNormal
	setPixels()
	ink = defaultInk + pixels.size()

func _input(event):
	if !canDraw: 
		return

	if event is InputEventScreenTouch and event.pressed:
		pen = line2D.duplicate(true)
		pen.width *= scale.x
		lineContainer.add_child(pen)

	if event is InputEventScreenDrag:
		mousePos = event.position
		var imageOffset = Vector2(imageSize/2) * scale
		var point = (mousePos - position) + imageOffset
		pixels = pixels.filter(func(pixel): return point.distance_to(pixel) > pen.width)
		pen.add_point(mousePos)
		ink = clamp(ink-1, 0, INF)

func setPixels():
	for row in imageSize.y:
		for column in imageSize.x:
			if image.get_pixel(column, row) in maskColors:
				pixels.append(Vector2(column, row) * scale)

