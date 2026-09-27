extends Node

const INVENTORY_CAPACITY: int = 20

var items: Array[Dictionary] = []

signal inventory_changed


func add_item(item_id: String, item_type: String = "") -> bool:
	if not has_free_slot():
		print("Inventory penuh.")
		return false

	var item_data: Dictionary = {
		"id": item_id,
		"type": item_type
	}

	items.append(item_data)
	inventory_changed.emit()

	print("Item masuk Inventory: ", item_id)
	return true


func remove_item(item_id: String) -> bool:
	for i in range(items.size()):
		var item: Dictionary = items[i]

		if item.get("id", "") == item_id:
			items.remove_at(i)
			inventory_changed.emit()

			print("Item dihapus dari Inventory: ", item_id)
			return true

	return false


func has_item(item_id: String) -> bool:
	for item in items:
		if item.get("id", "") == item_id:
			return true

	return false


func get_item_count(item_id: String) -> int:
	var count: int = 0

	for item in items:
		if item.get("id", "") == item_id:
			count += 1

	return count


func has_free_slot() -> bool:
	return items.size() < INVENTORY_CAPACITY


func get_item_count_total() -> int:
	return items.size()


func clear_inventory() -> void:
	items.clear()
	inventory_changed.emit()

func print_inventory() -> void:
	print("=== INVENTORY ===")

	for i in range(items.size()):
		var item: Dictionary = items[i]
		print(
			"Slot ",
			i + 1,
			": ",
			item.get("id", ""),
			" | ",
			item.get("type", "")
		)

	print(
		"Total: ",
		items.size(),
		"/",
		INVENTORY_CAPACITY
	)
