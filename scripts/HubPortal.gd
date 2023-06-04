extends Node2D

var Hub = load("res://scenes/Levels/HubWorld.tscn")

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		get_tree().change_scene_to(Hub)
