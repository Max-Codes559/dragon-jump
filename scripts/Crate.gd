extends StaticBody2D

const obj_treasure = preload("res://scenes/Collectables/CrateTreasure.tscn")
const BreakSound = preload("res://assets/sounds/Crate_break.wav")

func _on_CrateArea_area_entered(_area = "other"):
	var animation = $AnimationPlayer
	animation.play("BoxBreak")
	var Collision = $BoxShape
	Collision.set_deferred("disabled", true)
	var sound = $AudioStreamPlayer
	sound.stream = BreakSound
	sound.playing = true


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
