extends Node

var active := false
var _cooling_down := false

func _ready():
	call_deferred("_connect_signals")

func _connect_signals():
	Dialogic.Text.animation_textbox_hide.connect(_on_textbox_hiding)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	print("DIALOGIC: signals connected")

func _on_textbox_hiding():
	print("DIALOGIC: unlocked via textbox hide")
	active = false
	_cooling_down = true

func _on_timeline_ended():
	print("DIALOGIC: unlocked via timeline ended")
	active = false
	_cooling_down = false

func is_busy() -> bool:
	return active or _cooling_down

func begin(timeline: String):
	if is_busy():
		print("DIALOGIC: busy, ignoring")
		return
	print("DIALOGIC: locked")
	active = true
	Dialogic.start(timeline)
