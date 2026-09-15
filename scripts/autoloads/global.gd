extends Node

#region DevConfigs
var debug_mode = true
#endregion

#region Money
var default_starting_money = 100
var starting_debt = 100000

var money: int = default_starting_money
var money_today: int = 0
var debt: int = starting_debt

func add_money(amount: int) -> void:
	money += amount
	money_today += amount

func reset_day() -> void:
	money_today = 0

#endregion

#region Store Rating
var stars = 2
#endregion

#region Staff (update this...)
var staff: Array[Staff] =  [
	Staff.new(&"fey", "Robin", 3, 2, 3, 0, true),
]
#endregion

# the date
# unlocked items...
# any other information
