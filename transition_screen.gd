extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

signal onTransitionFinish

func _ready() -> void:
	colorRect.visible = false
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		animationPlayer.play("fade_to_normal")
		onTransitionFinish.emit()
	elif anim_name == "fade_to_normal":
		colorRect.visible = false

func transition():
	colorRect.visible = true
	animationPlayer.play("fade_to_black")
