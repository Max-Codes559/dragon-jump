extends Node2D

signal hurt_grace
signal player_death
#only exists to prevent errors

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
