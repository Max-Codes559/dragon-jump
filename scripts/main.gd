extends Node2D

onready var Player = $Player

var player_health = 3

func player_damaged(damage, cause):
	if cause == "enemy" and Player.DashingInv == false:
		player_health -= damage

	if cause == "spike":
		player_health -= damage

	print(player_health)
	if player_health <= 0:
		player_death()
		
func player_death():
	get_tree().reload_current_scene()
