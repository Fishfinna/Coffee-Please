extends Node2D
const END_DAY_SCENE = preload("res://scenes/rooms/end-day.tscn")
const SHOP_GAME_SCENE = preload("uid://bxuvuy8cnlk12")
const SHOP_GAME = preload("uid://bxuvuy8cnlk12")
const MAIN_MENU = preload("uid://dx3g4uolw7xpb")

@onready var shop_game: Node = $ShopGame

func _ready():
	randomize() # randomizes the whole game!
	DaytimeClock.day_ended.connect(_on_day_ended)
	var main_menu = MAIN_MENU.instantiate()
	main_menu.position = Vector2.ZERO
	add_child(main_menu)

func new_game():
	print("show open game")

func _on_day_ended():
	if shop_game:
		shop_game.queue_free()
		shop_game = null
	var end_day_instance = END_DAY_SCENE.instantiate()
	end_day_instance.position = Vector2.ZERO
	add_child(end_day_instance)
	end_day_instance.continue_pressed.connect(_on_end_day_continue.bind(end_day_instance))

func _on_end_day_continue(end_day_instance: Node) -> void:
	end_day_instance.queue_free()
	DaytimeClock.start_next_day()
	Global.reset_day()
	_spawn_shop_game()

func _spawn_shop_game() -> void:
	shop_game = SHOP_GAME_SCENE.instantiate()
	add_child(shop_game)
	shop_game.start_new_day()
