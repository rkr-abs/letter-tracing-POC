extends Control

var font
var fontSize
var character

func _ready():
	font = get_theme_default_font()
	var color = Color(1, 1, 1, 1)
 
	# Create an Image to draw the character
	#image = Image.new()
	#var char_width = font.get_string_size(character).x
	#var char_height = font.get_height()
	#image.create(char_width, char_height, false, Image.FORMAT_RGBA8)
	 #
		## Create an ImageTexture to use with the CanvasItem to draw the character
	#var image_texture = ImageTexture.new()
	#image_texture.create_from_image(image)
	 #
#
	#prints(char_width, char_height)
	#_setPixels()
#
#func _setPixels():
	#var imageSize = image.get_size()
	##var pixels
	#for row in imageSize.y:
		#for column in imageSize.x:
			##pixels.append(Vector2(column, row) * scale)
			#print(Vector2(column, row))

func _draw():
	draw_string(font, Vector2(64, 64), character, HORIZONTAL_ALIGNMENT_CENTER, -1, fontSize)
