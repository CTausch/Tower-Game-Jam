extends "res://Scripts/enemy_base.gd"



@onready var parent = get_parent()
#@onready var character = get_node("../../../player")
@onready var bombSpawn = get_node("bombSpawnSE")

var InitTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = true
	enemySpeed = 50
	InitTime = Time.get_unix_time_from_system()
	bombSpawn.playing = true
	await bombSpawn.finished
	bombSpawn.playing = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += enemySpeed * delta
	if position.x >= parent.points[1].x:
		#character.isAlive = false
		#queue_free() #eventually change this to lose game
		TransitionScreen.transition()
		await TransitionScreen.onTransitionFinish
		get_tree().call_deferred("change_scene_to_file", "res://TitleScreen.tscn")
		queue_free()
