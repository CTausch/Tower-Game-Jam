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
var sendNextWave = true
@export var waveNumber = GlobalVariables.waveNumber
@export var bombsRemaining = 0
@export var enemiesRemaining = 0

#This is really weird, but it's probably the easiest way to fix the spawning problem.
#Basically the spawning broke when I refactored to add scripts during the actual spawning process.
#This is intended to fix that while still limiting the number of times random numbers must be generated
const ENEMY_NAMES = {0 : "Tank", 1 : "Gun", 2 : "Bomb"} #This isn't used, but is good reference for now
var enemy_index = [0, 1, 2]

#Enemy spawning variables - Wave 1
const WAVE_ONE = {"waveTime" : 70.0, "tankCount" : 5, "gunnerCount" : 3, "bomberCount" : 4}
#Enemy spawning variables - Wave 2
const WAVE_TWO = {"waveTime" : 105.0, "tankCount" : 8, "gunnerCount" : 5, "bomberCount" : 5}
#Enemy spawning variables - Wave 3
const WAVE_THREE = {"waveTime" : 120.0, "tankCount" : 4, "gunnerCount" : 10, "bomberCount" : 6}

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
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GlobalVariables.waveNumber < 4): #Basically an end condition. We can add something else late
		if(sendNextWave):
			GlobalVariables.waveNumber += 1
			waveSetUp(GlobalVariables.waveNumber)
			sendNextWave = false
		if(await spawnEnemies(delta)):
			sendNextWave = true
			#print("next wave")
			#GlobalVariables.waveNumber += 1
	else:
		get_tree().call_deferred("change_scene_to_file", "res://TitleScreen.tscn")
	

#Sets up enemy queue. Takes an int to indicate what wave should be set up.
func waveSetUp(waveNum: int ) -> void:
	#To add new stages, possibly create a function that contains all this with a passed in wave number
	#Call it in process when a new nave is needed
	#Wave dictionaries could be in an array
	#Bad solution. If this is ever expanded on, this would need to be changed
	var wave
	if(waveNum == 1):
		wave = WAVE_ONE
	elif(waveNum == 2):
		wave = WAVE_TWO
	else:
		wave = WAVE_THREE
	var tanksNeeded = wave["tankCount"]
	var gunnersNeeded = wave["gunnerCount"]
	var bombersNeeded = wave["bomberCount"]
	var enemiesNeededArray = [tanksNeeded, gunnersNeeded, bombersNeeded]
	enemyQueueHead = enemy.instantiate()
	enemyQueueHead.enemyType = randi()%enemiesNeededArray.size()
	enemyQueueHead.line = randi()%5
	#print(enemyQueueHead.enemyType)
	#Bad code. Ensure every wave has at least one of each enemy
	enemiesNeededArray[enemyQueueHead.enemyType] -= 1
	#print(enemiesNeededArray[enemyQueueHead.enemyType])
	queueCurrent = enemyQueueHead
	#while(enemiesNeededArray.size() != 0):
		#queueCurrent.nextEnemy = enemy.instantiate()
		#queueCurrent = queueCurrent.nextEnemy
		#queueCurrent.enemyType = randi()%enemiesNeededArray.size()
		#queueCurrent.line = randi()%5
		#enemiesNeededArray[queueCurrent.enemyType] -= 1
		#if(enemiesNeededArray[queueCurrent.enemyType] == 0):
			#enemiesNeededArray.remove_at(queueCurrent.enemyType)
	while(enemy_index.size() != 0):
		queueCurrent.nextEnemy = enemy.instantiate()
		queueCurrent = queueCurrent.nextEnemy
		queueCurrent.enemyType = enemy_index[randi()%enemy_index.size()]
		queueCurrent.line = randi()%5
		enemiesNeededArray[queueCurrent.enemyType] -= 1
		if(enemiesNeededArray[queueCurrent.enemyType] == 0):
			enemy_index.remove_at(enemy_index.find(queueCurrent.enemyType))
	enemy_index = [0, 1, 2]
	enemyQueueTail = queueCurrent
	enemiesRemaining = wave["tankCount"] + wave["gunnerCount"] + wave["bomberCount"]
	spawnTime = wave["waveTime"] / enemiesRemaining*0.25
	character.bulletCount = wave["bomberCount"] * 2
	bombsRemaining = wave["bomberCount"]
	queueCurrent = enemyQueueHead
	
#Generates enemies based on enemy queue. Updates display to show number of bombers left to spawn
#Takes in delta from _process to calculate time passed since last spawn. 
#Returns true when lines have no enemyBase children and queueCurrent is null. Wave is over
func spawnEnemies(delta: float) -> bool:
	if(queueCurrent != null): #Safety. Stall until all enemies are gone
		timeSinceLastSpawn += delta
		if(timeSinceLastSpawn >= spawnTime):
			#print("Ready to Spawn")
			readyToSpawn = true
			timeSinceLastSpawn = 0.0
		#Spawn enemies if enough time has elapsed
		if(readyToSpawn):
			lineHolder = queueCurrent.line
			nextHolder = queueCurrent.nextEnemy
			#I believe the enemy_base script is zero indexed for lines and enemy types
			#Also change this once other enemies are created
			if(queueCurrent.enemyType == 0): #Tank
				queueCurrent.set_script(load("res://Scripts/TankEnemy.gd"))
				queueCurrent.find_child("Sprite2D").texture = load("res://Sprites/tank.png")
				queueCurrent.find_child("Sprite2D").scale.x = 0.07
				queueCurrent.find_child("Sprite2D").scale.y = 0.07
			elif(queueCurrent.enemyType == 1): #Gunner
				queueCurrent.set_script(load("res://Scripts/GunEnemy.gd"))
				queueCurrent.find_child("Sprite2D").texture = load("res://Sprites/bird1.png")
			elif(queueCurrent.enemyType == 2): #Bomber
				queueCurrent.set_script(load("res://Scripts/BombEnemy.gd"))
				queueCurrent.find_child("Sprite2D").texture = load("res://Sprites/bomb.png")
				bombsRemaining -= 1
			enemiesRemaining -= 1
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
					
			#print("Spawned")
			readyToSpawn = false
			queueCurrent = nextHolder
	#Check if wave is over
	if(queueCurrent == null and
	line1.get_child_count() == 0 
	and line2.get_child_count() == 0
	and line3.get_child_count() == 0
	and line4.get_child_count() == 0
	and line5.get_child_count() == 0):
		#print("Next wave")
		TransitionScreen.transition()
		await TransitionScreen.onTransitionFinish
		return true
	return false
	
	#Test Code
	#while(queueCurrent != null):
		#print(queueCurrent.enemyType)
		#queueCurrent = queueCurrent.nextEnemy
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
