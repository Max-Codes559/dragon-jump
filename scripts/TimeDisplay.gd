extends Label

onready var timer = get_node("../../CountDown")

func _process(delta):
	var time = str(stepify(timer.get_time_left(), 0.01))
	set_text(time)

