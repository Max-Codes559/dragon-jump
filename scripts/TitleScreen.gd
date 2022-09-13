extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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

