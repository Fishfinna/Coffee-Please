extends Control

var tickets: Array = []

func add_ticket(ticket: Dictionary) -> void:
	tickets.append(ticket)
	print("ticket added: ", ticket)
