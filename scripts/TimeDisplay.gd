extends Label

onready var timer = get_node("../../CountDown")

func _process(_delta):
	var time = str(stepify(timer.get_time_left(), 1))
	set_text(time)

