extends Control


@onready var organic_amount: Label = $Panel/ItemList/OrganicRow/MarginContainer/HBoxContainer/Amount
@onready var inorganic_amount: Label = $Panel/ItemList/AnorganicRow/MarginContainer/HBoxContainer/Amount
@onready var b3_amount: Label = $Panel/ItemList/B3Row/MarginContainer/HBoxContainer/Amount


@onready var organic_sell_button: TextureButton = $Panel/ItemList/OrganicRow/MarginContainer/HBoxContainer/OrganicSellButton
@onready var inorganic_sell_button: TextureButton = $Panel/ItemList/AnorganicRow/MarginContainer/HBoxContainer/InorganicSellButton
@onready var b3_sell_button: TextureButton = $Panel/ItemList/B3Row/MarginContainer/HBoxContainer/b3SellButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	visible = false

	InventoryManager.inventory_changed.connect(_on_inventory_changed)

	_refresh_sell_menu()


func _on_inventory_changed() -> void:
	_refresh_sell_menu()


func _refresh_sell_menu() -> void:
	var organic_count: int = InventoryManager.get_item_count(
		"Sampah Organik"
	)

	var inorganic_count: int = InventoryManager.get_item_count(
		"Sampah Anorganik"
	)

	var b3_count: int = InventoryManager.get_item_count(
		"Sampah B3"
	)


	organic_amount.text = "Jumlah: " + str(organic_count)
	inorganic_amount.text = "Jumlah: " + str(inorganic_count)
	b3_amount.text = "Jumlah: " + str(b3_count)


	organic_sell_button.disabled = organic_count <= 0
	inorganic_sell_button.disabled = inorganic_count <= 0
	b3_sell_button.disabled = b3_count <= 0


func _on_close_button_pressed() -> void:
	visible = false


func _on_organic_sell_button_pressed() -> void:
	_sell_item("Sampah Organik", 50)


func _on_inorganic_sell_button_pressed() -> void:
	_sell_item("Sampah Anorganik", 50)


func _on_b3_sell_button_pressed() -> void:
	_sell_item("Sampah B3", 75)

func _sell_item(item_id: String, price: int) -> void:
	print("=== MULAI JUAL ===")
	print("Item: ", item_id)
	print("Jumlah sebelum: ", InventoryManager.get_item_count(item_id))

	if not InventoryManager.has_item(item_id):
		print("GAGAL: Item tidak ditemukan di Inventory.")
		_refresh_sell_menu()
		return

	var berhasil: bool = InventoryManager.remove_item(item_id)

	print("remove_item berhasil: ", berhasil)
	print("Jumlah sesudah: ", InventoryManager.get_item_count(item_id))

	if not berhasil:
		print("GAGAL: remove_item() mengembalikan false.")
		return

	CoinManager.add_coins(price)

	print("Coin sekarang: ", CoinManager.get_coins())

	_refresh_sell_menu()

	print("=== SELESAI JUAL ===")
