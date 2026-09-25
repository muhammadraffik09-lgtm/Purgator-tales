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
var opened_by_tong: Node = null
var processed_count: int = 0


@onready var process_label: Label = $Panel/ProcessLabel
@onready var title_label: Label = $Panel/Title


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

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	process_items.resize(PROCESS_SLOT_COUNT)
	result_items.resize(RESULT_SLOT_COUNT)

	_clear_process_slots()
	_clear_result_slots()

	_setup_process_slots()

	_update_process_label()

func setup_bin(type: String, source_tong: Node = null) -> void:
	trash_type = type
	opened_by_tong = source_tong

	if title_label:
		title_label.text = "TONG " + trash_type.to_upper()

	_update_process_label()


# =========================================================
# JUMLAH SAMPAH UNTUK 1 HASIL
# =========================================================

func _get_required_amount() -> int:
	match trash_type:
		"Organik":
			return ORGANIC_REQUIRED

		"Anorganik":
			return INORGANIC_REQUIRED

		"B3":
			return B3_REQUIRED

	return 5


# =========================================================
# UPDATE COUNTER
# =========================================================

func _update_process_label() -> void:
	if process_label == null:
		return

	var required: int = _get_required_amount()

	process_label.text = str(
		processed_count,
		" / ",
		required
	)


# =========================================================
# TAMBAH SAMPAH KE TONG
# =========================================================

func try_add_trash(
	trash_id: String,
	source_type: String
) -> bool:

	# Kategori harus sesuai
	if source_type != trash_type:
		return false

	# Cari slot kosong
	var empty_slot: int = _get_empty_process_slot()

	if empty_slot == -1:
		return false

	# Simpan data
	var trash_data: Dictionary = {
		"id": trash_id,
		"type": source_type
	}

	process_items[empty_slot] = trash_data

	# Tampilkan icon
	_show_process_slot(
		empty_slot,
		trash_id
	)

	# Mulai proses
	_process_slot(empty_slot)

	return true


# =========================================================
# CARI SLOT PROSES KOSONG
# =========================================================

func _get_empty_process_slot() -> int:
	for i in range(process_items.size()):
		if process_items[i] == null:
			return i

	return -1


# =========================================================
# PROSES 1 ITEM
# =========================================================

func _process_slot(slot_index: int) -> void:

	await get_tree().create_timer(
		PROCESS_TIME
	).timeout

	# Validasi index
	if slot_index < 0:
		return

	if slot_index >= process_items.size():
		return

	# Ambil item
	var item = process_items[slot_index]

	if item == null:
		return

	# Hapus dari slot proses
	process_items[slot_index] = null

	_clear_process_slot(slot_index)

	# Tambah jumlah sampah yang sudah diproses
	processed_count += 1

	_update_process_label()

	# Cek apakah sudah menghasilkan item
	_check_result_creation()


# =========================================================
# CEK PEMBUATAN HASIL
# =========================================================

func _check_result_creation() -> void:

	var required: int = _get_required_amount()

	# Belum cukup
	if processed_count < required:
		return

	# Tidak ada slot hasil
	var result_slot: int = _get_empty_result_slot()

	if result_slot == -1:
		return

	# Kurangi jumlah yang sudah diproses
	processed_count -= required

	_update_process_label()

	# Tentukan hasil
	var result_id: String = ""

	match trash_type:
		"Organik":
			result_id = "Sampah Organik"

		"Anorganik":
			result_id = "Sampah Anorganik"

		"B3":
			result_id = "Sampah B3"

	# Masukkan hasil
	_add_result(
		result_slot,
		result_id
	)

func _get_empty_result_slot() -> int:

	for i in range(result_items.size()):
		if result_items[i] == null:
			return i

	return -1

func _add_result(
	slot_index: int,
	result_id: String
) -> void:

	if slot_index < 0:
		return

	if slot_index >= result_items.size():
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

func take_result(slot_index: int) -> bool:

	if slot_index < 0:
		return false

	if slot_index >= result_items.size():
		return false

	var item = result_items[slot_index]

	if item == null:
		return false


	var item_id: String = item["id"]


	var berhasil: bool = InventoryManager.add_item(
		item_id,
		1
	)


	if not berhasil:
		print("Inventory penuh. Hasil tidak dapat diambil.")
		return false

	result_items[slot_index] = null

	result_slots[slot_index].texture_normal = null
	result_slots[slot_index].tooltip_text = ""

	print(
		"Hasil diambil: ",
		item_id
	)

	return true

func _show_result_slot(
	slot_index: int,
	result_id: String
) -> void:

	if slot_index < 0:
		return

	if slot_index >= result_slots.size():
		return

	var slot: TextureButton = result_slots[slot_index]

	slot.texture_normal = _get_result_texture(result_id)
	slot.tooltip_text = result_id


func _get_result_texture(
	result_id: String
) -> Texture2D:

	match result_id:

		"Sampah Organik":
			return preload(
				"res://Asset/Icon UI/Item/sampah_kecil_organik.png"
			)

		"Sampah Anorganik":
			return preload(
				"res://Asset/Icon UI/Item/sampah_kecil_anorganik.png"
			)

		"Sampah B3":
			return preload(
				"res://Asset/Icon UI/Item/sampah_kecil_b3.png"
			)

	return null


func _get_trash_texture(
	trash_id: String
) -> Texture2D:

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


func _show_process_slot(
	slot_index: int,
	trash_id: String
) -> void:

	if slot_index < 0:
		return

	if slot_index >= process_slots.size():
		return

	var slot: TextureButton = process_slots[slot_index]

	slot.texture_normal = _get_trash_texture(trash_id)
	slot.tooltip_text = trash_id

func _clear_process_slot(
	slot_index: int
) -> void:

	if slot_index < 0:
		return

	if slot_index >= process_slots.size():
		return

	var slot: TextureButton = process_slots[slot_index]

	slot.texture_normal = null
	slot.tooltip_text = ""


func _clear_process_slots() -> void:

	for i in range(process_slots.size()):
		_clear_process_slot(i)

func _clear_result_slots() -> void:

	for i in range(result_slots.size()):

		var slot: TextureButton = result_slots[i]

		slot.texture_normal = null
		slot.tooltip_text = ""

func _setup_process_slots() -> void:
	for i in range(process_slots.size()):

		var slot: TextureButton = process_slots[i]

		if slot.has_method("setup"):
			slot.setup(self, i)

func _setup_result_slots() -> void:
	for i in range(result_slots.size()):
		var slot: TextureButton = result_slots[i]

		if slot.has_method("setup"):
			slot.setup(self, i)

func get_result_price(
	item_id: String
) -> int:

	match item_id:
		"Sampah Organik":
			return 50

		"Sampah Anorganik":
			return 50

		"Sampah B3":
			return 75

	return 0

func can_accept_trash(source_type: String) -> bool:

	if source_type != trash_type:
		return false

	if _get_empty_process_slot() == -1:
		return false

	return true

func receive_trash(
	data: Dictionary,
	_target_slot_index: int
) -> void:

	if not data.has("trash_id"):
		return

	if not data.has("trash_type"):
		return

	var trash_id: String = data["trash_id"]
	var source_type: String = data["trash_type"]

	if source_type != trash_type:
		return

	var berhasil: bool = try_add_trash(
		trash_id,
		source_type
	)

	if not berhasil:
		return

	if not data.has("bag_menu"):
		return

	var bag_menu = data["bag_menu"]

	if bag_menu == null:
		return

	if not data.has("bag_slot_index"):
		return

	var bag_slot_index: int = data["bag_slot_index"]

	if bag_menu.has_method("remove_item_at"):

		var berhasil_dihapus: bool = bag_menu.remove_item_at(
			bag_slot_index
		)

		if not berhasil_dihapus:
			print("Gagal menghapus item dari Trash Bag.")

func _on_back_button_pressed() -> void:
	visible = false

	if opened_by_tong != null:
		if opened_by_tong.has_method("show_prompt_again"):
			opened_by_tong.show_prompt_again()
