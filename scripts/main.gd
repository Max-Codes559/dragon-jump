extends Node2D

signal player_death
signal add_to_timer(time)
signal health_changed(new_health)
signal hurt_grace(start_end, direction)
signal send_score(score)

const VictoryScreen = preload("res://scenes/Victory.tscn")

onready var GraceTimer = $GraceTimer
onready var CameraM = $Camera2D
onready var checkpoints = get_tree().get_nodes_in_group("checkpoints")
onready var spiders = get_tree().get_nodes_in_group("spiders")
onready var TreasureGroup = get_tree().get_nodes_in_group("treasure")
onready var Player = $Player

onready var TreasureLeft = TreasureGroup.size()
onready var TreasureLeft_Label = get_node("Camera2D/TreasureCollected")
onready var total_treasure:int =  TreasureGroup.size()
onready var count_down_timer = $CountDown

var CheckPointArray = []

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
	
func connect_to_checkpoints():
	for member in checkpoints:
		var ConnectingCheckPoint = member
		ConnectingCheckPoint.connect("Activated", self, "add_respawn_point")
	
func add_spider_time():
	bonus_time(2)
	#activates when spider sends spider_died

func player_damaged(damage, cause, direction):
	var player_prehealth = player_health
	if GraceTimer.time_left == 0:
		if cause == "enemy" and Player.DashingInv == false and Player.Kicking == false:
			player_health -= damage
			GraceTimer.start()
			if player_health <= 0:
				#emit_signal("hurt_grace", "start", Vector2.ZERO)
				pass
			else:
				emit_signal("hurt_grace", "start", direction)

	if cause in ["spike", "lava"]:
		player_health -= damage
		if player_health < player_prehealth:
			GraceTimer.start()
			if player_health <= 0:
				#emit_signal("hurt_grace", "start", Vector2.ZERO)
				pass
			else:
				emit_signal("hurt_grace", "start", direction)

	if cause == "health":
		player_health += damage

	if player_health <= 0:
		player_death()
		
	if player_health > 3:
		player_health = 3
		
	emit_signal("health_changed", player_health)
	
func player_death():
	Player.global_position = find_closest_CP()
	player_health = 3
	emit_signal("player_death")
	
func bonus_time(time):
	emit_signal("add_to_timer", time)
	#sending to CountDown

func _ready():
	TreasureLeft_Label.text = str(treasure_collected) + "/" + str(total_treasure)
	connect_to_spiders()
	connect_to_treasure()
	connect_to_checkpoints()

func _on_GraceTimer_timeout():
	emit_signal("hurt_grace", "end", Vector2.ZERO)

func send_score():
	var time_left = count_down_timer.get_time_left()
	score = treasure_collected * 0.1 * time_left
	emit_signal("send_score",score)

func add_respawn_point(CPPosition):
	CheckPointArray.append(CPPosition)

func find_closest_CP():
	if CheckPointArray.size() != 0:
		var PP = Player.global_position
		var CPDistance = []
		for CP in CheckPointArray:
			CPDistance.append(sqrt(pow((PP.x - CP.x), 2) + pow((PP.y - CP.y), 2)))
		var ClosestCPIndex = CPDistance.find(CPDistance.min())
			#index of Closest CheckPoint in CheckPointArray
		return CheckPointArray[ClosestCPIndex]
	else:
		return Vector2.ZERO
