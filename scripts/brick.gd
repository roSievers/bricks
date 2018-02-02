extends StaticBody2D

export var initial_hitpoints = 1
var hitpoints setget set_hitpoints


func _ready():
	randomize()
	hitpoints = initial_hitpoints
	modulate = Color(randf(), randf(), randf())
	modulate.s = 1
	modulate.v = 0.5

func set_hitpoints(new_hitpoints):
	hitpoints = new_hitpoints
	if new_hitpoints <= 0:
		on_destroy()
	else:
		var sprite = find_node("sprite")
		sprite.frame = randi()%3 + 1

func on_destroy():
	queue_free()
	
	# Here we substract 1, because self still is a child of its parent.
	var other_brick_count = get_parent().get_child_count() - 1
	if other_brick_count == 0:
		get_node("/root/world").game_over()