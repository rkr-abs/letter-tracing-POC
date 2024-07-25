extends Line2D

@export var trackColor: Color = Color("white")
@onready var icon = $"../Icon" 
var mouse_pos
var image: Image
var pixels = []
var pen: Line2D

func _ready():
	image = Image.load_from_file("res://icon.svg")
	var textureNormal = ImageTexture.create_from_image(image)
	icon.texture = textureNormal
	width *= icon.scale.x 
	setPixels()

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		pen = duplicate(true)
		add_child(pen)

	if event is InputEventScreenDrag:
		mouse_pos = event.position
		var point = (mouse_pos - icon.position) + (Vector2(64, 64) * icon.scale)
		pixels = pixels.filter(func(pixel): 
			return point.distance_to(pixel) > pen.width)
		pen.add_point(mouse_pos)

func setPixels():
	var imageSize = image.get_size()
	for row in imageSize.y:
		for column in imageSize.x:
			if image.get_pixel(column, row) == trackColor:
				pixels.append(Vector2(column, row) * icon.scale)
