extends Node

var do_rumbles = true

func low():
	if !do_rumbles: return
	var level = 0.5
	Input.start_joy_vibration(0, level, level, 0.5)

func high():
	if !do_rumbles: return
	var level = 1
	Input.start_joy_vibration(0, level, level, 0.5)
