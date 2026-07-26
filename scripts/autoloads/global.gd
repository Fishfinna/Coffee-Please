extends Node

# Money
var default_starting_money = 100
var money: int = default_starting_money
var money_today: int = 0

# Store Rating
var stars = 2

# Staff (update this...)
var staff: Array[Staff] =  [
	Staff.new(&"fey", "Robin", 3, 2, 3, 0, true),
]

# the date
# unlocked items...
# any other information
