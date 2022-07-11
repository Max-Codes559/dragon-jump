extends Timer

func _ready():
	start()

func _on_CountDown_timeout():
	get_tree().reload_current_scene()

func _on_Main_add_to_timer(time):
	var Remainder = time_left
	start(Remainder + time)
