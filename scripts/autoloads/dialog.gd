extends Node

var active := false
var _cooling_down := false
var _pending_timeline := ""

func _ready():
	call_deferred("_connect_signals")

func _connect_signals():
	Dialogic.Text.animation_textbox_hide.connect(_on_textbox_hiding)
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_textbox_hiding():
	active = false
	_cooling_down = true

func _on_timeline_ended():
	active = false
	_cooling_down = false
	if _pending_timeline != "":
		var next = _pending_timeline
		_pending_timeline = ""
		active = true
		Dialogic.start(next)

func is_busy() -> bool:
	return active or _cooling_down

func start(timeline: String):
	if active:
		return
	if _cooling_down:
		_pending_timeline = timeline
		active = true
		return
	active = true
	Dialogic.start(timeline)
