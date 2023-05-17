extends HBoxContainer

export var level_name = "Level Name"
export (PackedScene) var level_scene

func _on_Button_pressed():
	get_tree().change_scene_to(level_scene)

