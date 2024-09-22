extends Label

@export var character : Area2D
@export var lineBase : Node2D
var textToDisplay
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	textToDisplay = "Ammo: " + str(character.bulletCount) + "\n"
	textToDisplay = textToDisplay + "Bombs Remaining: " + str(lineBase.bombsRemaining) + "\n"
	textToDisplay = textToDisplay + "Enemies Remaining: " + str(lineBase.enemiesRemaining) + "\n"
	textToDisplay = textToDisplay + "Wave: " + str(GlobalVariables.waveNumber)
	text = textToDisplay
