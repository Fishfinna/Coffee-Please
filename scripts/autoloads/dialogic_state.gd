extends Node

var active := false
var _start_count := 0

func _ready():
	call_deferred("_connect_signals")

func _connect_signals():
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	print("DIALOGIC: signals connected")

func _on_timeline_started():
	_start_count += 1
	print("DIALOGIC: timeline_started fired, count = ", _start_count)

func _on_timeline_ended():
	print("DIALOGIC: timeline_ended fired")
	active = false
	_start_count = 0

func start_dialog(timeline_path: String):
	if active:
		print("DIALOGIC: blocked")
		return
	print("DIALOGIC: lock")
	active = true
	_start_count = 0
	Dialogic.start(timeline_path)
