extends Node2D

signal t_collected

func _ready():
	add_to_group("treasure")

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		emit_signal("t_collected")
		queue_free()
