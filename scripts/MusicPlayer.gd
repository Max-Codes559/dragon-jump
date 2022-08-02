extends AudioStreamPlayer

var MusicOn = true

func _process(_delta):
	if self.playing == false and MusicOn == true:
		self.play()
