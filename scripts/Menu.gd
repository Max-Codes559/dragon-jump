extends Node2D

onready var LevelMusic = get_node("../../Player/LevelMusic")
onready var MusicToggle = $MusicToggle
onready var CameraM = get_parent()
onready var Controls = load("res://scenes/Menus/ControlsTut.tscn")
onready var ExitButton = $CenterContainer/VBoxContainer/ExitButton

var Hub = load("res://scenes/Levels/HubWorld.tscn")
	
func _ready():
	print(get_tree().current_scene.name)
	if get_tree().current_scene.name == "HubWorld":
		ExitButton.text = "QUIT"
	MusicToggle.set_pressed_no_signal(LevelMusic.MusicOn) 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_RestartButton_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
	if get_tree().current_scene.name == "HubWorld":
		get_tree().quit()
	else:
		get_tree().paused = false
		get_tree().change_scene_to(Hub)

func _on_ResumeButton_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			queue_free()

func _on_MusicToggle_toggled(button_pressed):
	if button_pressed == true:
		LevelMusic.MusicOn = true
	elif button_pressed == false:
		LevelMusic.MusicOn = false
		LevelMusic.stop()


func _on_Controls_pressed():
	var Tut = Controls.instance()
	add_child(Tut)
