extends HBoxContainer


@onready var slots: Array[BaseButton] = [
	$FixedSlot,
	$Slot1,
	$Slot2,
	$Slot3,
	$Slot4
]


const HOTBAR_SWITCH_COOLDOWN := 2.0


var current_slot: int = -1
var can_switch: bool = true


func _ready():
	for i in range(slots.size()):
		slots[i].toggle_mode = true
		slots[i].pressed.connect(_on_slot_pressed.bind(i))


func _on_slot_pressed(slot_index: int):
	if not can_switch:
		_restore_current_slot()
		return

	if current_slot == slot_index:
		slots[slot_index].button_pressed = false
		current_slot = -1
		return

	if current_slot != -1:
		slots[current_slot].button_pressed = false

	slots[slot_index].button_pressed = true
	current_slot = slot_index

	_start_switch_cooldown()


func _select_slot_from_keyboard(slot_index: int):
	if not can_switch:
		return

	if current_slot == slot_index:
		slots[slot_index].button_pressed = false
		current_slot = -1
		return

	if current_slot != -1:
		slots[current_slot].button_pressed = false

	slots[slot_index].button_pressed = true
	current_slot = slot_index

	_start_switch_cooldown()


func _restore_current_slot():
	for i in range(slots.size()):
		slots[i].button_pressed = (i == current_slot)


func _start_switch_cooldown():
	can_switch = false

	await get_tree().create_timer(HOTBAR_SWITCH_COOLDOWN).timeout

	can_switch = true


func _unhandled_key_input(event: InputEvent):
	if not event.pressed:
		return

	if event.echo:
		return

	match event.keycode:
		KEY_1:
			_select_slot_from_keyboard(0)

		KEY_2:
			_select_slot_from_keyboard(1)

		KEY_3:
			_select_slot_from_keyboard(2)

		KEY_4:
			_select_slot_from_keyboard(3)

		KEY_5:
			_select_slot_from_keyboard(4)

func _get_item_texture(item_id: String) -> Texture2D:
	match item_id:
		"Karung Sampah":
			return preload(
				"res://Asset/Icon UI/Item/karung_sampah.png"
			)

	return null
