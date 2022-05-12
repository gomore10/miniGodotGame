extends Camera2D
var cam_offset = 20
export var player_path: NodePath
onready var Player = get_node(player_path)
export var asteroid_path: NodePath
onready var Asteroid = get_node(asteroid_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = (Player.position-Asteroid.position).normalized()*cam_offset
	rotation=Player.rotation
