extends RigidBody2D

# The "dropped" signal is fired, when the ball leaves the viewport.
# It carries one Vector2 parameter which indicates where the ball was lost.
signal dropped

const speedup = 4
const max_speed = 300

var multiplier = 1

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("bricks"):
			body.register_hit(self)
			multiplier += 1
			
			# Copy brick color
			modulate = body.modulate
			modulate.v = 0.8 # Higher value for better visibility.

		elif body.is_in_group("paddle"):
			multiplier = 1
			var direction = position - body.get_node("reflector").get_global_position()
			linear_velocity = min(max_speed, linear_velocity.length() + speedup) * direction.normalized()

	if position.y > get_viewport_rect().size.y + 10:
		# We use the parent to count how many balls there are.
		# This makes sure, that the count is accurate.
		get_parent().remove_child(self)
		queue_free()
		
		emit_signal("dropped", position)