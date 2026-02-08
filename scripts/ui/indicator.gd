class_name Indicator
extends Node2D

@export var interactable: Interactable
@export var appear_audio: AudioStream

@onready var appear_sound: AudioStreamPlayer2D = $popup_sound
@onready var sprite: AnimatedSprite2D = $indicator

var is_showing := false
var is_hiding := false
var is_in_range := false
var enter_id := 0

func _on_player_entered() -> void:
	if is_in_range:
		return

	is_in_range = true
	IndicatorManager.register(self)


func _on_player_exited() -> void:
	if not is_in_range:
		return

	is_in_range = false
	IndicatorManager.unregister(self)

func _ready() -> void:
	sprite.visible = false
	sprite.stop()

	if appear_audio:
		appear_sound.stream = appear_audio

	if interactable:
		interactable.player_entered.connect(_on_player_entered)
		interactable.player_exited.connect(_on_player_exited)

func play_audio() -> void:
	if appear_sound.playing:
		appear_sound.stop()
	appear_sound.play()

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

	if not is_in_range:
		sprite.visible = false

	is_hiding = false
