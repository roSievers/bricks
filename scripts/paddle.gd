extends KinematicBody2D

const ball_scene = preload("res://scenes/ball.tscn")

var max_speed = 600

func _physics_process(delta):
	var target = get_viewport().get_mouse_position().x
	if target < position.x:
		position.x = max(target, position.x - max_speed * delta)
	elif target > position.x:
		position.x = min(target, position.x + max_speed * delta)

func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed() and event.button_index == 1:
			var ball = ball_scene.instance()
			ball.position = position - Vector2(0, 16)
			var balls = get_node("/root/world/balls")
			balls.add_child(ball)
			
			var world = get_node("/root/world")
			ball.connect("dropped", world, "_on_ball_dropped")
			# TODO: Maybe this should use signals.
			world._on_ball_spawned()