extends Node2D

var enemy_spawn_time = 2
onready var SpawnTimer = $EnemySpawnTimer
onready var Ysort = $YSort
onready var Asteroid = $YSort/Asteroid
var rng = RandomNumberGenerator.new()

var alienship = preload("res://EnemyShip.tscn")
var sandmonster = preload("res://SandMonster.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	SpawnTimer.start(enemy_spawn_time)




func _on_EnemySpawnTimer_timeout():
	var type = rng.randi_range(0,1)
	var new_enemy = null
	if type==0:
		new_enemy = alienship.instance()
		new_enemy.Asteroid = Asteroid
	elif type==1:
		new_enemy = sandmonster.instance()
		new_enemy.Asteroid = Asteroid
	Ysort.add_child(new_enemy)
	SpawnTimer.start(enemy_spawn_time)
