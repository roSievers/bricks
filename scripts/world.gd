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
	var ball_count_multiplier = get_node("balls").get_child_count()
	var additional_score = ball_chain_multiplier * ball_count_multiplier
	set_score(score + additional_score)
	
	# Show a label with the score value to inform the player.
	var score = score_indicator.instance()
	score.set_caption(str(additional_score))
	# Copy brick position and color
	score.position = source.position
	score.color = source.modulate
	add_child(score)

func loose_ball(ball):
	set_score(score - 10)
	spawn_label("-10", ball.position, Color(1, 0, 0))
	
	# Remove the ball already, so we can update the instructions directly.
	get_node("balls").remove_child(ball)
	update_instructions()

# Show a label with the score value to inform the player.
func spawn_label(caption, label_position, label_color):
	var score = score_indicator.instance()
	score.set_caption(caption)
	# Copy brick position and color
	score.position = label_position
	score.color = label_color
	add_child(score)

func update_instructions():
	var ball_count = get_node("balls").get_child_count()
	var label = get_node("instructions")
	if ball_count == 0:
		label.text = "Press left mouse button to launch a ball."
	elif ball_count == 1:
		label.text = "You can launch more than one ball at a time."
	elif ball_count >= 2:
		label.text = "You loose 10 Points for each dropped ball."

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