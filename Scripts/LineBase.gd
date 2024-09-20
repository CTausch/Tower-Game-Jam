extends Node2D

const HEIGHT_DIFF = 100.0
const LINE_LENGTH = 300.0
@export var defaultLine : Line2D
@export var lowerBound : Line2D
@export var upperBound : Line2D
@export var character : Area2D
@export var line1 : Line2D
@export var line2 : Line2D
@export var line3 : Line2D
@export var line4 : Line2D
@export var line5 : Line2D
var lines = [line1, line2, line3, line4, line5]
@onready var enemy = preload("res://enemyBase.tscn")
var enemyQueueHead
var enemyQueueTail
var queueCurrent

#Enemy spawning variables - Wave 1
const WAVE_ONE = {"waveTime" : 90.0, "tankCount" : 5, "gunnerCount" : 5, "bomberCount" : 5}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initialize lines and character
	var currentLine = defaultLine
	var line = PackedVector2Array()
	line.append(Vector2(-(LINE_LENGTH / 2.0), -HEIGHT_DIFF))
	line.append(Vector2((LINE_LENGTH / 2.0), -HEIGHT_DIFF))
	while(currentLine != upperBound):
		currentLine.points = line
		line[0].y -= HEIGHT_DIFF
		line[1].y -= HEIGHT_DIFF
		currentLine = currentLine.above
	character.position = character.currentLine.points[1]
	
	var tanksNeeded = WAVE_ONE["tankCount"]
	var gunnersNeeded = WAVE_ONE["gunnerCount"]
	var bombersNeeded = WAVE_ONE["bomberCount"]
	var enemiesNeededArray = [tanksNeeded, gunnersNeeded, bombersNeeded]
	enemyQueueHead = enemy.instantiate()
	enemyQueueHead.enemyType = randi()%enemiesNeededArray.size()
	enemyQueueHead.line = randi()%5
	#print(enemyQueueHead.enemyType)
	#Bad code. Ensure every wave has at least one of each enemy
	enemiesNeededArray[enemyQueueHead.enemyType] -= 1
	#print(enemiesNeededArray[enemyQueueHead.enemyType])
	queueCurrent = enemyQueueHead
	while(enemiesNeededArray.size() != 0):
		queueCurrent.nextEnemy = enemy.instantiate()
		queueCurrent = queueCurrent.nextEnemy
		queueCurrent.enemyType = randi()%enemiesNeededArray.size()
		queueCurrent.line = randi()%5
		enemiesNeededArray[queueCurrent.enemyType] -= 1
		if(enemiesNeededArray[queueCurrent.enemyType] == 0):
			enemiesNeededArray.remove_at(queueCurrent.enemyType)
	enemyQueueTail = queueCurrent
	queueCurrent = enemyQueueHead
	
	#Test Code
	while(queueCurrent != null):
		print(queueCurrent.enemyType)
		queueCurrent = queueCurrent.nextEnemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	
	if Input.is_action_just_pressed("ui_right"):
		var enemy_temp = enemy.instantiate()
		enemy_temp.set_script(load("res://TankEnemy.gd"))
		var randomNum = randi()%5+1
		print(randomNum)
		if randomNum == 1:
			line1.add_child(enemy_temp)
			enemy_temp.position = line1.points[0]
			enemy_temp.position.x = line1.points[0].x-400
		if randomNum == 2:
			line2.add_child(enemy_temp)
			enemy_temp.position = line2.points[0]
			enemy_temp.position.x = line2.points[0].x-400
		if randomNum == 3:
			line3.add_child(enemy_temp)
			enemy_temp.position = line3.points[0]
			enemy_temp.position.x = line3.points[0].x-400
		if randomNum == 4:
			line4.add_child(enemy_temp)
			enemy_temp.position = line4.points[0]
			enemy_temp.position.x = line4.points[0].x-400
		if randomNum == 5:
			line5.add_child(enemy_temp)
			enemy_temp.position = line5.points[0]
			enemy_temp.position.x = line5.points[0].x-400
		print("okay")
