extends Node2D

var score = 0 setget set_score

func set_score(new_score):
	score = new_score
	get_node("score").text = "Score: " + str(score)

