class_name Indicator
extends Node2D

@export var trigger_distance := 50.0
@export var appear_audio: AudioStream

@onready var appear_sound: AudioStreamPlayer2D = $popup_sound
@onready var sprite: AnimatedSprite2D = $indicator
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

var is_showing: bool = false
var is_hiding: bool = false
var is_in_range: bool = false
var enter_id: int = 0


func _ready() -> void:
	sprite.visible = false
	sprite.stop()

	if appear_audio:
		appear_sound.stream = appear_audio


func _process(_delta: float) -> void:
	if player == null:
		return

	var distance := distance_to_player()

	if distance <= trigger_distance and not is_in_range:
		is_in_range = true
		IndicatorManager.register(self)

	elif distance > trigger_distance and is_in_range:
		is_in_range = false
		IndicatorManager.unregister(self)


func distance_to_player() -> float:
	return global_position.distance_to(player.global_position)


func force_show() -> void:
	if is_showing:
		return

	is_showing = true
	is_hiding = false
	sprite.visible = true
	sprite.play("load-in")

	if appear_sound.playing:
		appear_sound.stop()
	appear_sound.play()


func force_hide() -> void:
	if not is_showing or is_hiding:
		return

	is_hiding = true
	is_showing = false
	hide_after_load_out()


func hide_after_load_out() -> void:
	sprite.play("load-out")
	await sprite.animation_finished

	if distance_to_player() > trigger_distance:
		sprite.visible = false

	is_hiding = false
