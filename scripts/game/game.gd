extends Node2D

const END_DAY_SCENE = preload("res://scenes/rooms/end-day.tscn")
const SHOP_GAME_SCENE = preload("uid://bxuvuy8cnlk12")

@onready var shop_game: Node = $ShopGame

func _ready():
	randomize() # randomizes the whole game!
	DaytimeClock.day_ended.connect(_on_day_ended)

func _on_day_ended():
	if shop_game:
		shop_game.queue_free()
		shop_game = null
	var end_day_instance = END_DAY_SCENE.instantiate()
	end_day_instance.position = Vector2.ZERO
	add_child(end_day_instance)
