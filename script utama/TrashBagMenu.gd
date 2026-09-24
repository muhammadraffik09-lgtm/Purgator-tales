extends Control

const SLOT_COUNT := 20

@onready var slots: Array[TextureButton] = [
	$Panel/SlotGrid/Slot01,
	$Panel/SlotGrid/Slot02,
	$Panel/SlotGrid/Slot03,
	$Panel/SlotGrid/Slot04,
	$Panel/SlotGrid/Slot05,
	$Panel/SlotGrid/Slot06,
	$Panel/SlotGrid/Slot07,
	$Panel/SlotGrid/Slot08,
	$Panel/SlotGrid/Slot09,
	$Panel/SlotGrid/Slot10,
	$Panel/SlotGrid/Slot11,
	$Panel/SlotGrid/Slot12,
	$Panel/SlotGrid/Slot13,
	$Panel/SlotGrid/Slot14,
	$Panel/SlotGrid/Slot15,
	$Panel/SlotGrid/Slot16,
	$Panel/SlotGrid/Slot17,
	$Panel/SlotGrid/Slot18,
	$Panel/SlotGrid/Slot19,
	$Panel/SlotGrid/Slot20
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.trash_bag_changed.connect(refresh_slots)

	refresh_slots()


func refresh_slots() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	for i in range(slots.size()):
		slots[i].set_item({})

	for i in range(player.trash_bag_items.size()):
		if i >= slots.size():
			break

		slots[i].set_item(
			player.trash_bag_items[i]
	)
