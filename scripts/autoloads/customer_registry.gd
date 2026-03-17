extends Node

var by_id := {}

func register(customer: Customer) -> void:
	if customer.id == "":
		push_error("Customer missing ID")
		return
	by_id[customer.id] = customer

func unregister(customer: Customer) -> void:
	if by_id.get(customer.id) == customer:
		by_id.erase(customer.id)

func get_customer(id: String) -> Customer:
	return by_id.get(id)
