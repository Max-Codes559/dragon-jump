extends Node2D

onready var Main = $"../.."

func _on_AttBox_area_entered(area):
	if area.name == "PlayerHitBox":
		Main.player_damaged(1, "spike", global_position)
