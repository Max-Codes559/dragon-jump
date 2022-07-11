extends Node2D


func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
	get_tree().quit()
	
func _ready():
	get_tree().paused = true
