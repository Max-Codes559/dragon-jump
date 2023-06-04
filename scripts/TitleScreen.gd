extends TextureRect

export (PackedScene) var Hubworld

func _on_BtnInstructions_pressed():
	$Main.hide()
	$Instruction.show()

func _on_BtnLevel_pressed():
	$Main.hide()
	$LevelSelect.show()

func _on_BtnQuit_pressed():
	get_tree().quit()

func _on_BtnLevelBack_pressed():
	$LevelSelect.hide()
	$Main.show()

func _on_BtnInstBack_pressed():
	$Instruction.hide()
	$Main.show()

func _on_BtnStart_pressed():
	get_tree().change_scene_to(Hubworld)
