extends Node2D

onready var PickupSound = $Pickup

onready var Main = get_parent()

func _on_Area2D_area_entered(area):
	if Main.player_health < 3:
		if area.name == "PlayerHitBox":
			Main.player_damaged(1, "health")
			PickupSound.playing = true
			queue_free()

