extends AudioStreamPlayer

export var PlayMusic = false

func _process(_delta):
	if self.playing == false and PlayMusic == true:
		self.play()
