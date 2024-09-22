extends "res://Scripts/enemy_base.gd"


@onready var parent = get_parent()
@onready var character = get_node("../../../player")
@onready var tankSpawn = get_node("tankSpawnSE")

var direction = 1
var InitTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canDie = false
	enemySpeed = 200
	InitTime = Time.get_unix_time_from_system()
	tankSpawn.playing = true
	await tankSpawn.finished
	tankSpawn.playing = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x + (enemySpeed * direction * delta)
	if position.x >= parent.points[1].x:
		direction = direction * -1
	if direction < 0 and position.x <= parent.points[0].x-400 and Time.get_unix_time_from_system() - InitTime <= lifetime:
			direction = direction * -1
	if position.x < -1000 and Time.get_unix_time_from_system() - InitTime >= lifetime:
		queue_free()
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		character.isAlive = false #change to lose game
		TransitionScreen.transition()
		await TransitionScreen.onTransitionFinish
		get_tree().change_scene_to_file("res://TitleScreen.tscn")
	
