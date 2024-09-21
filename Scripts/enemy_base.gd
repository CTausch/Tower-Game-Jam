extends Area2D

var lifetime = 15
var canDie = true
var enemySpeed = 200
var enemyType
var line
var nextEnemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") and canDie == true:
		queue_free()
