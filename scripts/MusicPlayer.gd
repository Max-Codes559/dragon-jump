extends AudioStreamPlayer

export var PlayMusic = true

func _process(_delta):
	if self.playing == false and PlayMusic == true:
		self.play()
