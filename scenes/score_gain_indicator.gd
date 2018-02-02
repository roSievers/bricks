extends Node2D

const gravity = 400
var velocity = -200
var rotation_speed

# This looks like a hack, because color is never set and need not
# be a variable.
var color setget set_color, get_color

func _ready():
	rotation_speed = randf() * 20 - 10

func _physics_process(delta):
	velocity += gravity * delta
	position.y += velocity * delta
	rotation_degrees += rotation_speed * delta
	
	if position.y > get_viewport_rect().size.y + 10:
		queue_free()

func get_color():
	return get_node("label").get("custom_colors/font_color")

func set_color(new_color):
	get_node("label").set("custom_colors/font_color", new_color)
	
func set_caption(new_caption):
	get_node("label").text = new_caption