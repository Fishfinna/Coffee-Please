extends Node2D
const END_DAY_SCENE = preload("res://scenes/rooms/end-day.tscn")
const SHOP_GAME_SCENE = preload("uid://bxuvuy8cnlk12")
const MAIN_MENU = preload("uid://dx3g4uolw7xpb")
const NEW_GAME_SCENE = preload("uid://b7jj10uq4ivgs")

@onready var shop_game: Node = $ShopGame

var main_menu_instance: Node = null
var new_game_instance: Node = null

func _ready():
	randomize() # randomizes the whole game!
	DaytimeClock.day_ended.connect(_on_day_ended)
	if Global.debug_mode:
		Global.reset_day()
		_spawn_shop_game()
		return
	else:
		_spawn_main_menu()

func _spawn_main_menu() -> void:
	main_menu_instance = MAIN_MENU.instantiate()
	main_menu_instance.position = Vector2.ZERO
	main_menu_instance.new_game_pressed.connect(new_game)
	add_child(main_menu_instance)

func new_game() -> void:
	if main_menu_instance:
		main_menu_instance.queue_free()
		main_menu_instance = null
	Global.money = Global.default_starting_money
	new_game_instance = NEW_GAME_SCENE.instantiate()
	new_game_instance.position = Vector2.ZERO
	new_game_instance.read_letter.connect(_on_letter_read)
	add_child(new_game_instance)

func _on_letter_read() -> void:
	if new_game_instance:
		new_game_instance.queue_free()
		new_game_instance = null
	Global.reset_day()
	_spawn_shop_game()

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
