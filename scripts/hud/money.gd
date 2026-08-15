extends Control

@onready var money_label: Label = $money/label
@onready var money_today_label: Label = $today/label
@onready var loonie: AnimatedSprite2D = $loonie

var _last_money: int = Global.money
var _last_today: int = -1

func _ready() -> void:
	_update_labels()

func _process(_delta: float) -> void:
	if Global.money != _last_money or Global.money_today != _last_today:
		_update_labels()

func _update_labels() -> void:
	if _last_money < Global.money:
		loonie.play('earned')
	_last_money = Global.money
	_last_today = Global.money_today
	money_label.text = "%d$" % _last_money
	money_today_label.text = "today: %d$" % _last_today
