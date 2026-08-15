extends Panel

@onready var title: Label = $Title
@onready var date: Label = $Title/date

@onready var revenue: Label = $GridContainer/revenue
@onready var staff: Label = $GridContainer/staff

@onready var profit_today_label: Label = $"GridContainer/profit-today-label"
@onready var profit_today: Label = $"GridContainer/profit-today"

@onready var total_label: Label = $"GridContainer/total-label"
@onready var total: Label = $GridContainer/total

var good_color = "#57634e"
var bad_color = "#915665"

signal continue_pressed

func _ready() -> void:
	title.text = "End of Day %s" % DaytimeClock.current_day
	date.text = "%s %s" % [DaytimeClock.get_date_string(), DaytimeClock.current_year]
	
	var revenue_today = Global.money_today #TODO: FIX this it is not updating
	var staff_cost = len(Global.staff) * 8 * 15
	
	var expenses = staff_cost
	var profit_today_amount = revenue_today - expenses
	var total_saved = Global.money - expenses
	Global.money = total_saved
	
	revenue.text = "%s$" % revenue_today
	staff.text = "%s$" % staff_cost
	profit_today.text = "%s$" % profit_today_amount
	
	if profit_today_amount <= 0:
		profit_today_label.add_theme_color_override("font_color", bad_color)
		profit_today.add_theme_color_override("font_color", bad_color)
	
	total.text = "\n%s$" % total_saved
	if total_saved <= 0:
		total.add_theme_color_override("font_color", bad_color)
		total_label.add_theme_color_override("font_color", bad_color)


func keep_going() -> void:
	emit_signal("continue_pressed")
