extends Control

@onready var money_label: Label = $money
@onready var money_today_label: Label = $today
@onready var time_label: Label = $time

var _last_money: int = -1
var _day_start_money: int = 0
var _last_today: int = -1

func _ready() -> void:
	_day_start_money = Global.money
	_update_labels()

func _process(_delta: float) -> void:
	if Global.money != _last_money:
		_update_labels()
	time_label.text = "Time: %f" % _delta

func _update_labels() -> void:
	_last_money = Global.money
	money_label.text = "Money: %d$" % _last_money

	var today: int = _last_money - _day_start_money
	if today != _last_today:
		_last_today = today
		money_today_label.text = "Today: %d$" % today
