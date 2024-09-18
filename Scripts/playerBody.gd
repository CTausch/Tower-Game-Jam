extends Area2D

@export var lineBaseReference : Node2D
var currentLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentLine = lineBaseReference.defaultLine

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and currentLine.above != lineBaseReference.upperBound:
		currentLine = currentLine.above
		position = currentLine.points[1]
		print(position)
		
	if Input.is_action_just_pressed("ui_down") and currentLine.below != lineBaseReference.lowerBound:
		currentLine = currentLine.below
		position = currentLine.points[1]
		print(position)
