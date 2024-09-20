extends Area2D

var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * -1
	if position.x < -400:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		queue_free()
