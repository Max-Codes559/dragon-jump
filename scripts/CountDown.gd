extends Timer

func _ready():
	start()
	print("timer started")


func _on_CountDown_timeout():
	print("Timer ended")


func _on_Main_add_to_timer(time):
	var Remainder = time_left
	start(Remainder + time)
