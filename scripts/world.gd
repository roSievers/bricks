extends Node2D

const levels = [
	preload("res://scenes/levels/level_1.tscn"),
	preload("res://scenes/levels/level_2.tscn"), 
	preload("res://scenes/levels/level_3.tscn")]

var level = 1 setget set_level

const score_indicator = preload("res://scenes/score_gain_indicator.tscn")
var score = 0
var health = 100

func _ready():
	var bricks = get_node("bricks")	
	
	bricks.connect("brick_broken", self, "_on_brick_broken")
	bricks.connect("level_clear", self, "_on_level_clear")

func get_ball_count_multiplier():
	return get_node("balls").get_child_count()

func _on_brick_broken(brick, ball_chain_multiplier):
	var additional_score = ball_chain_multiplier * get_ball_count_multiplier() * level
	score += additional_score
	health += additional_score
	update_score_label()
	update_health_label()
	
	# Show a label with the score value to inform the player.
	spawn_label(str(additional_score), brick.position, brick.modulate)

func _on_ball_dropped(last_known_position):
	var loss = 10 * level * level
	health -= loss
	update_health_label()
	
	if health <= 0:
		# TODO: Figure out how to transfer the score value to the game_over scene.
		get_tree().change_scene("res://scenes/game_over.tscn")
	
	var label_position = Vector2(last_known_position.x, get_viewport_rect().size.y)
	spawn_label(str(-loss), last_known_position, Color(1, 0, 0))
	
	update_instructions()

func _on_ball_spawned():
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
		var loss = 10 * level * level
		label.text = "You lose "+str(loss)+" health for each dropped ball."

func update_score_label():
	get_node("score").text = "Score: " + str(score)

func update_health_label():
	get_node("health").text = "Health: " + str(health)
	
func set_level(new_level):
	level = new_level
	get_node("level").text = "Level: " + str(level)

func _on_level_clear():
	# delete all active balls
	for child in get_node("balls").get_children():
		child.queue_free()
		
	set_level(level + 1)
	load_level()
	update_instructions()

func load_level():
	get_node("bricks").replace_by(levels[(level-1)%3].instance())
	var bricks = get_node("bricks")
	bricks.connect("brick_broken", self, "_on_brick_broken")
	bricks.connect("level_clear", self, "_on_level_clear")