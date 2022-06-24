extends Camera2D

onready var player = get_node("../Player")

func _process(_delta):
	position = lerp(position, player.position, 0.3)
	#position = player.position
