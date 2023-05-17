extends Node2D

export var level_name = "Level Name"
export (PackedScene) var level_scene

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		get_tree().change_scene_to(level_scene)
