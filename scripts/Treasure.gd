extends Node2D

signal t_collected

onready var animation = $Animation
onready var bounce = $Bounce
onready var display = $Display
export(String, "Pearl", "Gold", "Diamond") var TType = "Pearl"

func _ready():
	add_to_group("treasure")
	
	if TType == "Pearl":
		var texture = load("res://assets/Sprites and sheets/Pearl.png")
		display.texture = texture
		display.hframes = 1
		display.scale = Vector2(1, 1)
		
	if TType == "Gold":
		var texture = load("res://assets/Sprites and sheets/Gold.png")
		display.texture = texture
		display.hframes = 6
		bounce.stop()
		animation.play("Gold")
		display.scale = Vector2(1, 1)
		
	if TType == "Diamond":
		var texture = load("res://assets/Sprites and sheets/Diamond.png")
		display.texture = texture
		display.hframes = 6
		animation.play("Diamond")
		display.scale = Vector2(0.5, 0.5)

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		emit_signal("t_collected")
		queue_free()
