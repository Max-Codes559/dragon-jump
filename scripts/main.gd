extends Node2D

signal add_to_timer(time)
signal health_changed(new_health)
signal hurt_grace(start_end, direction)
signal send_score(score)

const VictoryScreen = preload("res://scenes/Victory.tscn")

onready var GraceTimer = $GraceTimer
onready var CameraM = $Camera2D
onready var spiders = get_tree().get_nodes_in_group("spiders")
onready var TreasureGroup = get_tree().get_nodes_in_group("treasure")
#onready var CrateGroup = get_tree().get_nodes_in_group("crate")
onready var Player = $Player

onready var TreasureLeft = TreasureGroup.size()
onready var TreasureLeft_Label = get_node("Camera2D/TreasureCollected")
onready var total_treasure:int =  TreasureGroup.size()
onready var count_down_timer = $CountDown

var player_health = 3
var treasure_collected:int = 0
var score:int

func connect_to_spiders():
	for member in spiders:
		var ConnectingSpider = member
		ConnectingSpider.connect("spider_died", self, "add_spider_time")
		
func connect_to_treasure():
	for member in TreasureGroup:
		var ConnectingTreasure = member
		ConnectingTreasure.connect("t_collected", self, "treasure_collect")
		
func connect_to_crate_treasure():
	#TreasureGroup[-1].connect("t_collected", self, "treasure_collect")
	pass

func treasure_collect():
	bonus_time(1)
	TreasureLeft -= 1
	treasure_collected += 1
	
	if TreasureLeft == 0:
		get_tree().paused = true
		var VicScreen = VictoryScreen.instance()
		send_score()
		CameraM.add_child(VicScreen)
	#activates when treasure sends t_collected signal
	
	TreasureLeft_Label.text = str(treasure_collected) + "/" + str(total_treasure)
func add_spider_time():
	bonus_time(5)
	#activates when spider sends spider_died

func player_damaged(damage, cause, direction):
	var player_prehealth = player_health
	if GraceTimer.time_left == 0:
		if cause == "enemy" and Player.DashingInv == false and Player.Kicking == false:
			player_health -= damage
			GraceTimer.start()
			emit_signal("hurt_grace", "start", direction)

	if cause in ["spike", "lava"]:
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
	TreasureLeft_Label.text = str(treasure_collected) + "/" + str(total_treasure)
	connect_to_spiders()
	connect_to_treasure()

func _on_GraceTimer_timeout():
	emit_signal("hurt_grace", "end", Vector2.ZERO)

func send_score():
	var time_left = count_down_timer.get_time_left()
	score = treasure_collected * 0.1 * time_left
	emit_signal("send_score",score)
