extends Control

onready var Player = get_node("../../Player")
onready var Heart1 = $Heart1
onready var Heart2 = $Heart2
onready var Heart3 = $Heart3
onready var Hearts = [Heart3, Heart2, Heart1]

onready var RedOrb1 = $RedOrb
onready var RedOrb2 = $RedOrb2
#onready var RedOrbs = [RedOrb1, RedOrb2]
onready var BlueOrb1 = $BlueOrb
onready var BlueOrb2 = $BlueOrb2
#onready var BlueOrbs = [BlueOrb1, BlueOrb2]

var max_health = 3

func _ready():
	Player.connect("OrbUpdate", self, "update_orbs")

func _on_Main_health_changed(new_health):
	#for n in max_health - (new_health):
		#Hearts[n].frame = 1
		#Hearts[n + 1].frame = 0
	for n in Hearts.size():
		Hearts[n - 1].frame = 1
		
	for n in new_health:
		Hearts[n - 1].frame = 0

func update_orbs(dashes, jumps):
	if dashes == 2:
		RedOrb1.self_modulate = Color(1, 1, 1, 1)
		RedOrb2.self_modulate = Color(1, 1, 1, 1)
		
	if dashes == 1:
		RedOrb2.self_modulate = Color(1, 1, 1, 0.3)
		
	if dashes == 0:
		RedOrb1.self_modulate = Color(1, 1, 1, 0.3)
		
	if jumps == 2:
		BlueOrb1.self_modulate = Color(1, 1, 1, 1)
		BlueOrb2.self_modulate = Color(1, 1, 1, 1)
		
	if jumps == 1:
		BlueOrb2.self_modulate = Color(1, 1, 1, 0.3)
		
	if jumps == 0:
		BlueOrb1.self_modulate = Color(1, 1, 1, 0.3)
