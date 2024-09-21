extends "res://Scripts/enemy_base.gd"



@onready var parent = get_parent()
var InitTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = true
	enemySpeed = 50
	InitTime = Time.get_unix_time_from_system()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += enemySpeed * delta
	if position.x == parent.points[0].x:
		queue_free() #eventually change this to lose game
