extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var thingy : Node

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var directionx := Input.get_axis("ui_left", "ui_right")
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#var directiony := Input.get_axis("ui_up", "ui_down")
	#if directiony:
		#velocity.y = directiony * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_up"):
		position.y -= 250
	if Input.is_action_just_pressed("ui_down"):
		position.y += 250
	
	move_and_slide()
