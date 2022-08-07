extends Area2D

onready var Main = get_parent()

func _on_Lava_area_entered(area):
	if area.name == "PlayerHitBox":
		Main.player_damaged(100, "lava", Vector2.ZERO)
	print("Lava hit")
