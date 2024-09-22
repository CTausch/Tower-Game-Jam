extends "res://Scripts/enemy_base.gd"


@onready var parent = get_parent()
@onready var bullet = preload("res://enemyBullet.tscn")
var direction = 1
var InitTime
var shootDelay = 2
var shootDelayTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = true
	enemySpeed = 100
	InitTime = Time.get_unix_time_from_system()
	shootDelayTimer = shootDelay
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ((Time.get_unix_time_from_system() - InitTime) <= lifetime):
		position.x += enemySpeed * delta
		if position.x >= parent.points[0].x:
			enemySpeed = 0
	else:
		enemySpeed = -100
		position.x += enemySpeed * delta
	if position.x < -600 and Time.get_unix_time_from_system() - InitTime >= lifetime:
			queue_free()
			
	if enemySpeed == 0 and Time.get_unix_time_from_system() - InitTime >= shootDelayTimer:
		shootDelayTimer += shootDelay
		var bullet_temp = bullet.instantiate()
		parent.add_child(bullet_temp)
		bullet_temp.position = parent.points[0]
		#fire bullet
	#print(Time.get_unix_time_from_system() - InitTime)
