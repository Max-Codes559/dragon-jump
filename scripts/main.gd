extends Node2D

signal add_to_timer(time)
signal health_changed(new_health)
signal hurt_grace(start_end, direction)

const VictoryScreen = preload("res://scenes/Victory.tscn")

onready var GraceTimer = $GraceTimer
onready var CameraM = $Camera2D
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
	bonus_time(1)
	TreasureLeft -= 1
	if TreasureLeft == 0:
		get_tree().paused = true
		var VicScreen = VictoryScreen.instance()
		CameraM.add_child(VicScreen)
	#activates when treasure sends t_collected signal
func add_spider_time():
	bonus_time(5)
	#activates when spider sends spider_died

func player_damaged(damage, cause, direction):
	var player_prehealth = player_health
	if GraceTimer.time_left == 0:
		if cause == "enemy" and Player.DashingInv == false and Player.Kicking == false:
			player_health -= damage

		if cause == "spike":
			player_health -= damage
			
		if player_health < player_prehealth:
			GraceTimer.start()
			emit_signal("hurt_grace", "start", direction)
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
	emit_signal("add_to_timer", time)
	#sending to CountDown

func _ready():
	connect_to_spiders()
	connect_to_treasure()

func _on_GraceTimer_timeout():
	emit_signal("hurt_grace", "end", Vector2.ZERO)
