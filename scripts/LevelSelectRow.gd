extends HBoxContainer

export var level_name = "Level Name"
export (PackedScene) var level_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene_to(level_scene)
	pass # Replace with function body.
