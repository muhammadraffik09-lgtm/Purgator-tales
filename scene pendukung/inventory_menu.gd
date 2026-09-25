extends Control


const INVENTORY_SLOT_COUNT := 20


@onready var inventory_slots: Array = [
	$Panel/InventoryGrid/InventorySlot01,
	$Panel/InventoryGrid/InventorySlot02,
	$Panel/InventoryGrid/InventorySlot03,
	$Panel/InventoryGrid/InventorySlot04,
	$Panel/InventoryGrid/InventorySlot05,
	$Panel/InventoryGrid/InventorySlot06,
	$Panel/InventoryGrid/InventorySlot07,
	$Panel/InventoryGrid/InventorySlot08,
	$Panel/InventoryGrid/InventorySlot09,
	$Panel/InventoryGrid/InventorySlot10,
	$Panel/InventoryGrid/InventorySlot11,
	$Panel/InventoryGrid/InventorySlot12,
	$Panel/InventoryGrid/InventorySlot13,
	$Panel/InventoryGrid/InventorySlot14,
	$Panel/InventoryGrid/InventorySlot15,
	$Panel/InventoryGrid/InventorySlot16,
	$Panel/InventoryGrid/InventorySlot17,
	$Panel/InventoryGrid/InventorySlot18,
	$Panel/InventoryGrid/InventorySlot19,
	$Panel/InventoryGrid/InventorySlot20
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_refresh_inventory()


func _refresh_inventory() -> void:

	for i in range(INVENTORY_SLOT_COUNT):

		var slot = inventory_slots[i]

		# Cegah error jika node slot tidak ditemukan
		if slot == null:
			push_error(
				"InventoryMenu: InventorySlot ke-" + str(i + 1) + " tidak ditemukan."
			)
			continue


		if i >= InventoryManager.inventory_items.size():

			if slot.has_method("clear_item"):
				slot.clear_item()

			continue


		var item = InventoryManager.inventory_items[i]


		if item == null:

			if slot.has_method("clear_item"):
				slot.clear_item()

		else:

			if slot.has_method("set_item"):
				slot.set_item(item)


func refresh_inventory() -> void:
	_refresh_inventory()

func _on_close_button_pressed() -> void:
	if not UITransitionManager.try_transition():
		return

	visible = false
