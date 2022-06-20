extends Node2D

signal add_to_timer(time)

onready var spiders = get_tree().get_nodes_in_group("spiders")
onready var Player = $Player

var player_health = 3

func connect_to_spiders():
	for entity in spiders:
		var ConnectingSpider = entity
		ConnectingSpider.connect("spider_died", self, "add_spider_time")

func add_spider_time():
	bonus_time(10)
	print("10 sec added")

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
	
func bonus_time(time):
	print("bonus time added")
	emit_signal("add_to_timer", time)

func _ready():
	connect_to_spiders()
