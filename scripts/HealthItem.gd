extends Node2D

onready var Main = $"../.."

func _on_Area2D_area_entered(area):
	if Main.player_health < 3:
		if area.name == "PlayerHitBox":
			Main.player_damaged(1, "health", Vector2.ZERO)
			queue_free()

