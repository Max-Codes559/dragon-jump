extends Node2D

signal t_collected

onready var Player = get_node("../Player")

onready var TreasurePUShape = $TreasurePU/CollisionShape2D
onready var animation = $Animation
onready var bounce = $Bounce
onready var display = $Display

onready var main = get_parent()

var collected = false

func TRandomize():
	var TType = randi() % 3
	if TType == 0:
		var texture = load("res://assets/Sprites and sheets/Health and PickUps/Pearl.png")
		display.texture = texture
		display.hframes = 1
		display.scale = Vector2(1, 1)
		
	if TType == 1:
		var texture = load("res://assets/Sprites and sheets/Health and PickUps/Gold.png")
		display.texture = texture
		display.hframes = 6
		bounce.stop()
		animation.play("Gold")
		display.scale = Vector2(1, 1)
		
	if TType == 2:
		var texture = load("res://assets/Sprites and sheets/Health and PickUps/Diamond.png")
		display.texture = texture
		display.hframes = 6
		animation.play("Diamond")
		display.scale = Vector2(0.5, 0.5)

func _ready():
	add_to_group("treasure")
	TRandomize()
	
func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox" and collected == false:
		emit_signal("t_collected")
		collected = true
		TreasurePUShape.set_deferred("disabled", true)
		bounce.stop()
		bounce.play("shrink")
		#sending to Main

func _process(delta):
	if collected == true:
		position = lerp(position, Player.position, 8.15 * delta)

func _on_Bounce_animation_finished(_anim):
	queue_free()

