extends Node2D

var MusicOn = true
	
func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_ResumeButton_pressed():
	get_tree().paused = false
	queue_free()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			print("Closing menu")
			get_tree().paused = false
			queue_free()



func _on_MusicToggle_toggled(button_pressed):
	if button_pressed == true:
		MusicOn = true
