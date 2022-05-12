extends Camera2D
export var player_path: NodePath
onready var Player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation=Player.rotation
