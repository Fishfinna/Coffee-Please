extends Node2D

@export var player: Node2D
@export var trigger_distance := 50.0

@onready var sprite := $indicator

var is_showing := false
var is_hiding := false

func _ready():
	sprite.visible = false
	sprite.stop()

func _process(_delta):
	if player == null:
		return

	var distance := global_position.distance_to(player.global_position)

	if distance <= trigger_distance:
		if not is_showing:
			is_showing = true
			is_hiding = false
			sprite.visible = true
			sprite.play("load-in")
	else:
		if is_showing and not is_hiding:
			is_hiding = true
			is_showing = false
			hide_after_load_out()

func hide_after_load_out() -> void:
	sprite.play("load-out")
	await sprite.animation_finished
	sprite.visible = false
	is_hiding = false
