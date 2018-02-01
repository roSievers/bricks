extends RigidBody2D

const speedup = 4
const max_speed = 300

var multiplier = 1

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("bricks"):
			body.hitpoints -= 1
			get_node("/root/world").score += multiplier
			multiplier += 1
			
			modulate = body.modulate

		elif body.is_in_group("paddle"):
			multiplier = 1
			var direction = position - body.get_node("reflector").get_global_position()
			linear_velocity = min(max_speed, linear_velocity.length() + speedup) * direction.normalized()
			
			modulate = Color( randf(), randf(), randf() )
			
	if position.y > get_viewport_rect().size.y + 10:
		queue_free()
		get_node("/root/world").score -= 10
		