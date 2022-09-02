extends Node2D
onready var Main = get_tree().get_root().find_node("Main",true,false)
onready var score_label = $CenterContainer/VBoxContainer/Score
onready var stars_earned_label = $CenterContainer/VBoxContainer/StarsEarned

var stars_earned:int #Number of stars earned, out of 3
var score_for_three_stars:int = 1400 # these are based on score, but can be changed
var score_for_two_stars:int = 1000

func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
	get_tree().quit()
	
func _ready():
	get_tree().paused = true
	Main.connect("send_score",self,"show_score")
	show_score()
	get_star_earned()

func show_score():
	score_label.text = "SCORE: " + str(Main.score)

func get_star_earned():
	#Conditions for each star
	if Main.score >= score_for_three_stars:
		stars_earned = 3
	elif Main.score >= score_for_two_stars and Main.score <= score_for_three_stars:
		stars_earned = 2
	else:
		stars_earned = 1

	match stars_earned:
		3:
			stars_earned_label.text = "STARS EARNED: 3/3"
		2:
			stars_earned_label.text = "STARS EARNED: 2/3"
		1:
			stars_earned_label.text = "STARS EARNED: 1/3"
	
