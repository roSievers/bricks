extends KinematicBody2D

const ball_scene = preload("res://scenes/ball.tscn")

func _physics_process(delta):
	# TODO: Implement slower movement.
	position.x = get_viewport().get_mouse_position().x

func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed() and event.button_index == 1:
			var ball = ball_scene.instance()
			ball.position = position - Vector2(0, 16)
			get_tree().root.add_child(ball)