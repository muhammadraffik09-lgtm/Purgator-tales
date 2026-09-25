extends Node

const INVENTORY_SIZE := 20

var inventory_items: Array = []


func _ready() -> void:
	inventory_items.resize(INVENTORY_SIZE)

	_setup_initial_inventory()


func _setup_initial_inventory() -> void:
	for i in range(inventory_items.size()):
		inventory_items[i] = null

	inventory_items[0] = {
		"id": "Karung Sampah",
		"type": "Equipment"
	}


func add_item(
	item_id: String,
	amount: int = 1
) -> bool:

	if amount <= 0:
		return false

	for i in range(inventory_items.size()):

		if inventory_items[i] == null:
			continue

		if inventory_items[i]["id"] == item_id:

			inventory_items[i]["amount"] += amount

			return true


	# Cari slot kosong
	for i in range(inventory_items.size()):

		if inventory_items[i] == null:

			inventory_items[i] = {
				"id": item_id,
				"amount": amount
			}

			return true


	# Inventory penuh
	return false
