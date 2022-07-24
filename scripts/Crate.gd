extends Area2D

const obj_treasure = preload("res://scenes/Treasure.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Crate_area_entered(area):
	var inst_treasure = obj_treasure.instance()
	get_parent().add_child(inst_treasure)
	inst_treasure.global_position = global_position
	queue_free()

