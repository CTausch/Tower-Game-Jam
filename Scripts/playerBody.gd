extends Area2D

@export var lineBaseReference : Node2D
@onready var bullet = preload("res://bullet.tscn")
var currentLine
var isAlive
@export var  bulletCount = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentLine = lineBaseReference.defaultLine
	isAlive = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left") and bulletCount > 0:
		var bullet_temp = bullet.instantiate()
		currentLine.add_child(bullet_temp)
		bullet_temp.position = currentLine.points[1]
		print(currentLine)
		bulletCount = bulletCount - 1
	
	if Input.is_action_just_pressed("ui_up") and currentLine.above != lineBaseReference.upperBound:
		currentLine = currentLine.above
		position = currentLine.points[1]
		print(position)
		print(currentLine)
		
	if Input.is_action_just_pressed("ui_down") and currentLine.below != lineBaseReference.lowerBound:
		currentLine = currentLine.below
		position = currentLine.points[1]
		print(position)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBullet"):
		isAlive = false #change to lose game
