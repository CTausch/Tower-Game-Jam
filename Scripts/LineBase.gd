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
var lines = []
@onready var enemy = preload("res://enemyBase.tscn")
var enemyQueueHead
var enemyQueueTail
var queueCurrent
var spawnTime = 0.0
var readyToSpawn = true
var timeSinceLastSpawn = 0.0
var lineHolder
var nextHolder

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
	
	lines.append(line1)
	lines.append(line2)
	lines.append(line3)
	lines.append(line4)
	lines.append(line5)
	
	#To add new stages, possibly create a function that contains all this with a passed in wave number
	#Call it in process when a new nave is needed
	#Wave dictionaries could be in an array
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
	spawnTime = WAVE_ONE["waveTime"] / (WAVE_ONE["tankCount"] + WAVE_ONE["gunnerCount"] + WAVE_ONE["bomberCount"])
	queueCurrent = enemyQueueHead
	
	#Test Code
	#while(queueCurrent != null):
		#print(queueCurrent.enemyType)
		#queueCurrent = queueCurrent.nextEnemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(queueCurrent != null): #Needs to be changed for multiple waves
		timeSinceLastSpawn += delta
		if(timeSinceLastSpawn >= spawnTime):
			print("Ready to Spawn")
			readyToSpawn = true
			timeSinceLastSpawn = 0.0
			
		if(readyToSpawn):
			lineHolder = queueCurrent.line
			nextHolder = queueCurrent.nextEnemy
			#I believe the enemy_base script is zero indexed for lines and enemy types
			#Also change this once other enemies are created
			if(queueCurrent.enemyType == 0): #Tank
				queueCurrent.set_script(load("res://TankEnemy.gd"))
			if(queueCurrent.enemyType == 1): #Gunner
				queueCurrent.set_script(load("res://TankEnemy.gd"))
			if(queueCurrent.enemyType == 2): #Bomber
				queueCurrent.set_script(load("res://TankEnemy.gd"))
				
			if lineHolder == 0:
				line1.add_child(queueCurrent)
				queueCurrent.position = line1.points[0]
				queueCurrent.position.x = line1.points[0].x-400
			if lineHolder == 1:
				line2.add_child(queueCurrent)
				queueCurrent.position = line2.points[0]
				queueCurrent.position.x = line2.points[0].x-400
			if lineHolder == 2:
				line3.add_child(queueCurrent)
				queueCurrent.position = line3.points[0]
				queueCurrent.position.x = line3.points[0].x-400
			if lineHolder == 3:
				line4.add_child(queueCurrent)
				queueCurrent.position = line4.points[0]
				queueCurrent.position.x = line4.points[0].x-400
			if lineHolder == 4:
				line5.add_child(queueCurrent)
				queueCurrent.position = line5.points[0]
				queueCurrent.position.x = line5.points[0].x-400
				
			print("Spawned")
			readyToSpawn = false
			queueCurrent = nextHolder
	
	
	#if Input.is_action_just_pressed("ui_right"):
		#var enemy_temp = enemy.instantiate()
		#enemy_temp.set_script(load("res://TankEnemy.gd"))
		#var randomNum = randi()%5+1
		#print(randomNum)
		#if randomNum == 1:
			#line1.add_child(enemy_temp)
			#enemy_temp.position = line1.points[0]
			#enemy_temp.position.x = line1.points[0].x-400
		#if randomNum == 2:
			#line2.add_child(enemy_temp)
			#enemy_temp.position = line2.points[0]
			#enemy_temp.position.x = line2.points[0].x-400
		#if randomNum == 3:
			#line3.add_child(enemy_temp)
			#enemy_temp.position = line3.points[0]
			#enemy_temp.position.x = line3.points[0].x-400
		#if randomNum == 4:
			#line4.add_child(enemy_temp)
			#enemy_temp.position = line4.points[0]
			#enemy_temp.position.x = line4.points[0].x-400
		#if randomNum == 5:
			#line5.add_child(enemy_temp)
			#enemy_temp.position = line5.points[0]
			#enemy_temp.position.x = line5.points[0].x-400
		#print("okay")
