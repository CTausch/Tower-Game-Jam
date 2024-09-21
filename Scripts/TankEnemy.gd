extends "res://Scripts/enemy_base.gd"


@onready var parent = get_parent()
var direction = 1
var InitTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = false
	enemySpeed = 200
	InitTime = Time.get_unix_time_from_system()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x + (enemySpeed * direction * delta)
	if position.x >= parent.points[1].x:
		direction = direction * -1
	if direction < 0 and position.x <= parent.points[0].x and Time.get_unix_time_from_system() - InitTime <= 6:
			direction = direction * -1
	if position.x < -600 and Time.get_unix_time_from_system() - InitTime >= 6:
		queue_free()
	
	
