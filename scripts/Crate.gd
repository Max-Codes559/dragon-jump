extends StaticBody2D

const obj_treasure = preload("res://scenes/CrateTreasure.tscn")

func _ready():
	pass
	#add_to_group("crate")
	#need to count crates to tell how many treasures there WILL be



func _on_CrateArea_area_entered(_area):
	#self.remove_child(CrateTreasure)
	#get_parent().add_child(CrateTreasure)
	#print(CrateTreasure.get_parent())
	#CrateTreasure.global_position = global_position
	queue_free()

