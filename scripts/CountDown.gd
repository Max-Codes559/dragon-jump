extends Timer

func _ready():
	start()
	print("timer started")


func _on_CountDown_timeout():
	print("Timer ended")
