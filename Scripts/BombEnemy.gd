extends "res://Scripts/enemy_base.gd"



@onready var parent = get_parent()
@onready var character = get_node("../../../player")

var InitTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = true
	enemySpeed = 50
	InitTime = Time.get_unix_time_from_system()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += enemySpeed * delta
	if position.x >= parent.points[1].x:
		character.isAlive = false
		queue_free() #eventually change this to lose game
		get_tree().change_scene_to_file("res://TitleScreen.tscn")
