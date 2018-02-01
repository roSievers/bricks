extends StaticBody2D

export var initial_hitpoints = 1
var hitpoints setget set_hitpoints

var damaged_brick = preload("res://sprites/brick_damage.png")

func _ready():
	randomize()
	hitpoints = initial_hitpoints
	modulate = Color(randf(), randf(), randf())
	modulate.s = 0.5
	modulate.v = 0.5

func set_hitpoints(new_hitpoints):
	hitpoints = new_hitpoints
	if new_hitpoints <= 0:
		queue_free()
	else:
		var sprite = find_node("sprite")
		sprite.set_texture(damaged_brick)