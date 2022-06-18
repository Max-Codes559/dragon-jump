extends Node2D

var Player = null

func _ready():
	Player = get_parent()
	
func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_ResumeButton_pressed():
	get_tree().paused = false
	queue_free()
	


