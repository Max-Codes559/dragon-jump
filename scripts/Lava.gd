extends Area2D

onready var Main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Lava_area_entered(area):
	if area.name == "PlayerHitBox":
		Main.player_damaged(100, "lava", Vector2.ZERO)
	print("Lava hit")
