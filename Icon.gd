extends Sprite2D

@export var maskColors: Array[Color] = [Color("white")]
@export var defaultInk: int = 200
@export var canDraw: bool = true: 
	get: return ink > 0

@onready var line2D: Line2D = $"../Line2D"
@onready var lineContainer = $"../LineContainer"
@onready var sub_viewport = $"../CanvasLayer/SubViewportContainer/SubViewport"

var mousePos: Vector2
var image: Image
var imageSize: Vector2i
var textureNormal: ImageTexture
var pixels: Array = []
var filteredPixels: Array = []
var pen: Line2D
var ink: int

func _ready():
	await RenderingServer.frame_post_draw
	image = sub_viewport.get_texture().get_image()
	imageSize = image.get_size()
	textureNormal = ImageTexture.create_from_image(image)
	texture = textureNormal
	_setPixels()
	_fillInk()

func _input(event):
	if !canDraw: 
		return

	if event is InputEventScreenTouch and event.pressed:
		pen = line2D.duplicate(true)
		lineContainer.add_child(pen)

	if event is InputEventScreenDrag:
		mousePos = event.position
		var imageOffset = Vector2(imageSize/2) * scale
		var point = (mousePos - position) + imageOffset
		filteredPixels = filteredPixels.filter(func(pixel): return point.distance_to(pixel) > pen.width)
		#_setColor(filteredPixels)
		pen.add_point(mousePos)
		ink = clamp(ink-1, 0, INF)

func _setColor(pixels):
	pixels.map(func(pixel):
		pixel /= scale
		image.set_pixel(pixel.x, pixel.y, Color.RED)
	)
	textureNormal = ImageTexture.create_from_image(image)
	texture = textureNormal

func _setPixels():
	for row in imageSize.y:
		for column in imageSize.x:
			if image.get_pixel(column, row) in maskColors:
				pixels.append(Vector2(column, row) * scale)
	filteredPixels = pixels.duplicate(true)

func _fillInk():
	ink = defaultInk + pixels.size()

func reset():
	_fillInk()
	filteredPixels = pixels
