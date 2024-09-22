extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalVariables.waveNumber == 1:
		texture = load("res://Sprites/SkyLevel1.png")
	elif GlobalVariables.waveNumber == 2:
		texture = load("res://Sprites/SkyLevel2.png")
	elif GlobalVariables.waveNumber == 3:
		texture = load("res://Sprites/SkyLevel3.png")
