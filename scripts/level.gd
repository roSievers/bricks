extends Node2D

# Aggregates the "broken" signals
# Signal brick_broken { brick: Brick, ball_multiplier: Int }
signal brick_broken

signal level_clear

func _on_brick_broken(brick, ball_multiplier):
	emit_signal("brick_broken", brick, ball_multiplier)

	if get_child_count() == 0:
		emit_signal("level_clear")

func _ready():
	# Aggregate the "broken" signals
	for child in get_children():
		child.connect("broken", self, "_on_brick_broken")