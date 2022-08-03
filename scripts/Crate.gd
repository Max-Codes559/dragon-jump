extends Area2D

const obj_treasure = preload("res://scenes/CrateTreasure.tscn")

func _ready():
	add_to_group("crate")
	#need to count crates to tell how many treasures there WILL be


func _on_Crate_area_entered(area):
	var inst_treasure = obj_treasure.instance()
	get_parent().add_child(inst_treasure)
	inst_treasure.global_position = global_position
	queue_free()

