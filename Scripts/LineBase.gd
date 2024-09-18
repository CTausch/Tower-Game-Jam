extends Node2D

const HEIGHT_DIFF = 100.0
const LINE_LENGTH = 300.0
@export var defaultLine : Line2D
@export var lowerBound : Line2D
@export var upperBound : Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var currentLine = defaultLine
	var line = PackedVector2Array()
	line.append(Vector2(-(LINE_LENGTH / 2.0), -HEIGHT_DIFF))
	line.append(Vector2((LINE_LENGTH / 2.0), -HEIGHT_DIFF))
	while(currentLine != upperBound):
		currentLine.points = line
		line[0].y -= HEIGHT_DIFF
		line[1].y -= HEIGHT_DIFF
		currentLine = currentLine.above
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
