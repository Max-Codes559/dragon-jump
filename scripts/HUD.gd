extends Control

onready var Heart1 = $Heart1
onready var Heart2 = $Heart2
onready var Heart3 = $Heart3
onready var Hearts = [Heart3, Heart2, Heart1]

var max_health = 3

func _on_Main_health_changed(new_health):
	for n in max_health - (new_health):
		Hearts[n].frame = 1
		Hearts[n + 1].frame = 0
