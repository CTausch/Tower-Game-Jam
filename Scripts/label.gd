extends Label

@export var character : Area2D
@export var lineBase : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Ammo: " + str(character.bulletCount) + "\n" + "Bomb enemies remaining: \n" + "Non-bomb enemies remaining: "
