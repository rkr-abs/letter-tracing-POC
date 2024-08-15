extends Camera2D

@onready var tile_map = $"../TileMap"
@export var speed : float = 200.0  # Movement speed of the camera

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_size = tile_map.tile_set.tile_size
	var plane_size = tile_map.get_used_rect().size
	plane_size.y /= 2

	var limit = (plane_size* tile_size) / 2
	
	limit_left = -limit.x
	limit_right = limit.x
	limit_top = -limit.y + tile_size.y
	limit_bottom = limit.y + tile_size.y*2

func _process(delta):
	var move_direction = Vector2.ZERO
	
	# Get input from the user (e.g., arrow keys or WASD)
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_direction.y += 1

	# Normalize the direction vector to ensure consistent speed in all directions
	if move_direction.length() > 0:
		move_direction = move_direction.normalized()
	
	# Move the camera
	position += move_direction * speed * delta
