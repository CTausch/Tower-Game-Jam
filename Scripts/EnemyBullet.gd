extends Area2D

var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 100:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free() #change to lose game
