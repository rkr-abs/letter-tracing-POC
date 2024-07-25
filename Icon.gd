extends Sprite2D

@export var trackColor: Color = Color("white")
@export var canDraw: bool = true

@onready var line2D: Line2D = $"../Line2D"
@onready var lineContainer = $"../LineContainer"

var mouse_pos: Vector2
var image: Image
var imageSize: Vector2i
var pixels: Array = []
var pen: Line2D

func _ready():
	image = Image.load_from_file("res://icon.svg")
	imageSize = image.get_size()
	var textureNormal = ImageTexture.create_from_image(image)
	texture = textureNormal
	setPixels()

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		pen = line2D.duplicate(true)
		pen.width *= scale.x
		lineContainer.add_child(pen)

	if event is InputEventScreenDrag:
		mouse_pos = event.position
		var imageOffset = Vector2(imageSize/2) * scale
		var point = (mouse_pos - position) + imageOffset
		pixels = pixels.filter(func(pixel): return point.distance_to(pixel) > pen.width)
		pen.add_point(mouse_pos)

func setPixels():
	for row in imageSize.y:
		for column in imageSize.x:
			if image.get_pixel(column, row) == trackColor:
				pixels.append(Vector2(column, row) * scale)
