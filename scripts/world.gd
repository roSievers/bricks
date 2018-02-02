extends Node2D

const level_1 = preload("res://scenes/levels/level_1.tscn")
const score_indicator = preload("res://scenes/score_gain_indicator.tscn")

var score = 0 setget set_score

# This is not consistent with inline get_node("score"). Which one is better?
var bricks_node
var balls_node

func _ready():
	bricks_node= get_node("bricks")
	balls_node = get_node("balls")

func gain_score(source, ball_chain_multiplier):
	var additional_score = ball_chain_multiplier
	set_score(score + additional_score)
	
	# Show a label with the score value to inform the player.
	var score = score_indicator.instance()
	score.set_caption(str(additional_score))
	# Copy brick position and color
	score.position = source.position
	score.color = source.modulate
	add_child(score)

func set_score(new_score):
	score = new_score
	get_node("score").text = "Score: " + str(score)

func game_over():
	clear()
	load_level()
	
func clear():
	# Remove old level node
	bricks_node.queue_free()
	# We remove it from the tree, because we add an new
	# object with the same name immediately.
	remove_child(bricks_node)
	
	# delete all active balls
	for child in balls_node.get_children():
		child.queue_free()

func load_level():
	bricks_node = level_1.instance()
	bricks_node.name = "bricks"
	add_child(bricks_node)