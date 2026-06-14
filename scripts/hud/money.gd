extends Control

@onready var money_label: Label = $total
@onready var money_today_label: Label = $today
@onready var loonie: AnimatedSprite2D = $loonie

var _last_money: int = Global.money
var _day_start_money: int = 0
var _last_today: int = -1

func _ready() -> void:
	_day_start_money = Global.money
	DaytimeClock.day_ended.connect(_on_day_ended)
	_update_labels()

func _on_day_ended() -> void:
	_day_start_money = Global.money
	_last_today = -1
	_update_labels()

func _process(_delta: float) -> void:
	if Global.money != _last_money:
		_update_labels()

func _update_labels() -> void:
	if _last_money < Global.money:
		loonie.play('earned')
	_last_money = Global.money
	money_label.text = "%d$" % _last_money
	var today: int = _last_money - _day_start_money
	if today != _last_today:
		_last_today = today
		money_today_label.text = "today: %d$" % today
