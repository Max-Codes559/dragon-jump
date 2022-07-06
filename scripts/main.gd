extends Node2D

signal add_to_timer(time)
signal health_changed(new_health)

onready var spiders = get_tree().get_nodes_in_group("spiders")
onready var treasure = get_tree().get_nodes_in_group("treasure")
onready var Player = $Player

onready var TreasureLeft = treasure.size()
var player_health = 3

func connect_to_spiders():
	for member in spiders:
		var ConnectingSpider = member
		ConnectingSpider.connect("spider_died", self, "add_spider_time")
		
func connect_to_treasure():
	for member in treasure:
		var ConnectingTreasure = member
		ConnectingTreasure.connect("t_collected", self, "treasure_collect")

func treasure_collect():
	bonus_time(2)
	TreasureLeft -= 1
	print(TreasureLeft, " treasures left")

func add_spider_time():
	bonus_time(5)
	print("10 sec added")
	#activates when spider_died signal sent from spider script

func player_damaged(damage, cause):
	if cause == "enemy" and Player.DashingInv == false:
		player_health -= damage

	if cause == "spike":
		player_health -= damage
		
	if cause == "health":
		player_health += damage

	if player_health <= 0:
		player_death()
		
	if player_health > 3:
		player_health = 3
		
	emit_signal("health_changed", player_health)
func player_death():
	get_tree().reload_current_scene()
	
func bonus_time(time):
	print("bonus time added")
	emit_signal("add_to_timer", time)

func _ready():
	connect_to_spiders()
	connect_to_treasure()
