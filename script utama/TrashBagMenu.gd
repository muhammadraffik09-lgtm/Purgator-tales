extends Control


@onready var bag_slots: Array[TextureButton] = [
	$Panel/SlotGrid/BagSlots1,
	$Panel/SlotGrid/BagSlots2,
	$Panel/SlotGrid/BagSlots3,
	$Panel/SlotGrid/BagSlots4,
	$Panel/SlotGrid/BagSlots5,
	$Panel/SlotGrid/BagSlots6,
	$Panel/SlotGrid/BagSlots7,
	$Panel/SlotGrid/BagSlots8,
	$Panel/SlotGrid/BagSlots9,
	$Panel/SlotGrid/BagSlots10,
	$Panel/SlotGrid/BagSlots11,
	$Panel/SlotGrid/BagSlots12,
	$Panel/SlotGrid/BagSlots13,
	$Panel/SlotGrid/BagSlots14,
	$Panel/SlotGrid/BagSlots15,
	$Panel/SlotGrid/BagSlots16,
	$Panel/SlotGrid/BagSlots17,
	$Panel/SlotGrid/BagSlots18,
	$Panel/SlotGrid/BagSlots19,
	$Panel/SlotGrid/BagSlots20
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	for i in range(bag_slots.size()):
		var slot: TextureButton = bag_slots[i]

		if slot.has_method("setup"):
			slot.setup(self, i)

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.trash_bag_changed.connect(refresh_slots)

	refresh_slots()


func refresh_slots() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	for i in range(bag_slots.size()):

		var slot: TextureButton = bag_slots[i]

		if i >= player.trash_bag_items.size():

			if slot.has_method("clear_item"):
				slot.clear_item()

			continue

		var item = player.trash_bag_items[i]

		if item == null:

			if slot.has_method("clear_item"):
				slot.clear_item()

		else:

			if slot.has_method("set_item"):
				slot.set_item(item)

func remove_item_at(slot_index: int) -> bool:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return false

	if slot_index < 0:
		return false

	if slot_index >= player.trash_bag_items.size():
		return false

	if player.trash_bag_items[slot_index] == null:
		return false

	player.trash_bag_items[slot_index] = null

	player.trash_bag_changed.emit()

	refresh_slots()

	return true


func _on_back_button_pressed() -> void:
	visible = false
