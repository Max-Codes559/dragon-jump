extends Area2D

onready var animation = $AnimationPlayer

signal Activated(CPPosition)

var active = false

func _ready():
	add_to_group("checkpoints")

func _on_Checkpoint_area_entered(area):
	if area.name == "PlayerHitBox" and active == false:
		animation.play("activating")
		active = true
		emit_signal("Activated", global_position)
