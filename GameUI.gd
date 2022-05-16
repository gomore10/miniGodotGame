extends CanvasLayer

onready var FullHearts = $FullHearts

func set_health(amount):
	FullHearts.rect_size = Vector2(16*amount,16)
