extends RigidBody2D

const speedup = 4
const max_speed = 300

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("bricks"):
			body.queue_free()
			get_node("/root/world").score += 1

		if body.is_in_group("paddle"):
			var direction = position - body.get_node("reflector").get_global_position()
			linear_velocity = min(max_speed, linear_velocity.length() + speedup) * direction.normalized()
			