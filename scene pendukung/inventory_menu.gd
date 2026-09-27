extends Control

const INVENTORY_CAPACITY: int = 20

@onready var item_grid: GridContainer = $Panel/PanelBackground/ItemScroll/ItemGrid
@onready var close_button: TextureButton = $Panel/PanelBackground/CloseButton

var inventory_slots: Array[TextureButton] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_collect_slots()

	if InventoryManager.inventory_changed.is_connected(_refresh_inventory) == false:
		InventoryManager.inventory_changed.connect(_refresh_inventory)

	_refresh_inventory()


func _collect_slots() -> void:
	inventory_slots.clear()

	for child in item_grid.get_children():
		if child is TextureButton:
			var slot: TextureButton = child
			inventory_slots.append(slot)

	if inventory_slots.size() != INVENTORY_CAPACITY:
		push_warning(
            "Inventory membutuhkan 20 slot. Saat ini ditemukan: "
			+ str(inventory_slots.size())
		)


func _refresh_inventory() -> void:
	for i in range(inventory_slots.size()):
		var slot: TextureButton = inventory_slots[i]

		var item_icon: TextureRect = slot.get_node_or_null("ItemIcon")

		if item_icon == null:
			push_error(
                "ItemIcon tidak ditemukan pada InventorySlot ke-"
				+ str(i + 1)
			)
			continue

		if i < InventoryManager.items.size():
			var item: Dictionary = InventoryManager.items[i]

			var item_id: String = item.get("id", "")

			item_icon.texture = _get_item_texture(item_id)
			item_icon.visible = item_icon.texture != null
		else:
			item_icon.texture = null
			item_icon.visible = false


func _get_item_texture(item_id: String) -> Texture2D:
	match item_id:
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


func _on_close_button_pressed() -> void:
	if not UITransitionManager.try_transition():
		return

	AudioManager.play_ui_click()
	visible = false
