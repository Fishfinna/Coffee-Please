extends Node

var active := false

func _ready():
	Dialogic.end_timeline(true)
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_started(_timeline_name := ""):
	active = true

func _on_timeline_ended(_timeline_name := ""):
	active = false
