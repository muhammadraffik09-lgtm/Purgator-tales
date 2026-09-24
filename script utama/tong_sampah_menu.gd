extends Control

const PROCESS_SLOT_COUNT := 20
const RESULT_SLOT_COUNT := 5

const ORGANIC_REQUIRED := 5
const INORGANIC_REQUIRED := 5
const B3_REQUIRED := 3

const PROCESS_TIME := 1.0

var trash_type: String = ""

var process_items: Array = []
var result_items: Array = []

var processed_count: int = 0


@onready var process_slots: Array[TextureButton] = [
	$Panel/ProcessGrid/ProcessSlot01,
	$Panel/ProcessGrid/ProcessSlot02,
	$Panel/ProcessGrid/ProcessSlot03,
	$Panel/ProcessGrid/ProcessSlot04,
	$Panel/ProcessGrid/ProcessSlot05,
	$Panel/ProcessGrid/ProcessSlot06,
	$Panel/ProcessGrid/ProcessSlot07,
	$Panel/ProcessGrid/ProcessSlot08,
	$Panel/ProcessGrid/ProcessSlot09,
	$Panel/ProcessGrid/ProcessSlot10,
	$Panel/ProcessGrid/ProcessSlot11,
	$Panel/ProcessGrid/ProcessSlot12,
	$Panel/ProcessGrid/ProcessSlot13,
	$Panel/ProcessGrid/ProcessSlot14,
	$Panel/ProcessGrid/ProcessSlot15,
	$Panel/ProcessGrid/ProcessSlot16,
	$Panel/ProcessGrid/ProcessSlot17,
	$Panel/ProcessGrid/ProcessSlot18,
	$Panel/ProcessGrid/ProcessSlot19,
	$Panel/ProcessGrid/ProcessSlot20
]


@onready var result_slots: Array[TextureButton] = [
	$Panel/ResultGrid/ResultSlot01,
	$Panel/ResultGrid/ResultSlot02,
	$Panel/ResultGrid/ResultSlot03,
	$Panel/ResultGrid/ResultSlot04,
	$Panel/ResultGrid/ResultSlot05
]


@onready var process_label: Label = $Panel/ProcessLabel
@onready var title_label: Label = $Panel/Title

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	process_items.resize(PROCESS_SLOT_COUNT)
	result_items.resize(RESULT_SLOT_COUNT)

	_clear_process_slots()
	_clear_result_slots()

	_update_process_label()

func setup_bin(type: String) -> void:
	trash_type = type

	if title_label:
		title_label.text = "TONG " + trash_type.to_upper()

	_update_process_label()

func _get_empty_process_slot() -> int:
	for i in range(process_items.size()):
		if process_items[i] == null:
			return i

	return -1

func try_add_trash(
	trash_id: String,
	source_type: String
) -> bool:

	if source_type != trash_type:
		return false

	var empty_slot := _get_empty_process_slot()

	if empty_slot == -1:
		return false

	var trash_data: Dictionary = {
		"id": trash_id,
		"type": source_type
	}

	process_items[empty_slot] = trash_data

	_show_process_slot(
		empty_slot,
		trash_id
	)

	_process_slot(empty_slot)

	return true

func _process_slot(slot_index: int) -> void:
	await get_tree().create_timer(PROCESS_TIME).timeout

	if slot_index < 0:
		return

	if slot_index >= process_items.size():
		return

	var item = process_items[slot_index]

	if item == null:
		return

	process_items[slot_index] = null

	_clear_process_slot(slot_index)

	processed_count += 1

	_update_process_label()

	_check_result_creation()

func _get_required_amount() -> int:
	match trash_type:
		"Organik":
			return ORGANIC_REQUIRED

		"Anorganik":
			return INORGANIC_REQUIRED

		"B3":
			return B3_REQUIRED

	return 5

func _update_process_label() -> void:
	if process_label == null:
		return

	var required := _get_required_amount()

	process_label.text = str(
		processed_count,
		" / ",
		required
	)

func _check_result_creation() -> void:
	var required := _get_required_amount()

	if processed_count < required:
		return

	if _get_empty_result_slot() == -1:
		return

	processed_count -= required

	_update_process_label()

	var result_id := ""

	match trash_type:
		"Organik":
			result_id = "Sampah Organik"

		"Anorganik":
			result_id = "Sampah Anorganik"

		"B3":
			result_id = "Sampah B3"

	_add_result(result_id)

func _get_empty_result_slot() -> int:
	for i in range(result_items.size()):
		if result_items[i] == null:
			return i

	return -1

func _add_result(result_id: String) -> void:
	var slot_index := _get_empty_result_slot()

	if slot_index == -1:
		return

	var result_data: Dictionary = {
		"id": result_id,
		"type": trash_type
	}

	result_items[slot_index] = result_data

	_show_result_slot(
		slot_index,
		result_id
	)

func _get_trash_texture(trash_id: String) -> Texture2D:
	match trash_id:
		"Kumpulan Tanah":
			return preload(
				"res://Asset/Icon UI/Item/Kumpulan Tanah (Orga).png"
			)

		"Pisang":
			return preload(
				"res://Asset/Icon UI/Item/Pisang (Orga).png"
			)

		"Botol Plastik":
			return preload(
				"res://Asset/Icon UI/Item/Botol_Plastik (Anor).png"
			)

		"Kantong Sampah":
			return preload(
				"res://Asset/Icon UI/Item/Kantong Sampah (Anor).png"
			)

		"Baterai":
			return preload(
				"res://Asset/Icon UI/Item/Baterai (B3).png"
			)

		"Jarum Suntik":
			return preload(
				"res://Asset/Icon UI/Item/Jarum Suntik (B3).png"
			)

	return null

func _show_result_slot(
	slot_index: int,
	result_id: String
) -> void:

	var slot := result_slots[slot_index]

	slot.texture_normal = _get_result_texture(result_id)
	slot.tooltip_text = result_id

func _clear_process_slots() -> void:
	for slot in process_slots:
		slot.texture_normal = null
		slot.tooltip_text = ""


func _clear_result_slots() -> void:
	for slot in result_slots:
		slot.texture_normal = null
		slot.tooltip_text = ""


func _clear_process_slot(slot_index: int) -> void:
	process_slots[slot_index].texture_normal = null
	process_slots[slot_index].tooltip_text = ""

func _show_process_slot(
	slot_index: int,
	trash_id: String
) -> void:

	var slot := process_slots[slot_index]

	slot.texture_normal = _get_trash_texture(trash_id)
	slot.tooltip_text = trash_id
