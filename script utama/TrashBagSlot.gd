extends TextureButton

var hover_active := false

var trash_data: Dictionary = {}

@onready var item_icon: TextureRect = $ItemIcon


func _ready() -> void:
	item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func setup(_menu: Control, _index: int) -> void:
	pass


func set_item(data: Dictionary) -> void:
	trash_data = data

	if trash_data.is_empty():
		clear_item()
		return

	var trash_id: String = str(trash_data.get("id", ""))

	item_icon.texture = _get_trash_texture(trash_id)
	item_icon.visible = item_icon.texture != null

	tooltip_text = (
		trash_id
		+ "\nKategori: "
		+ str(trash_data.get("type", ""))
	)


func clear_item() -> void:
	trash_data = {}

	item_icon.texture = null
	item_icon.visible = false

	tooltip_text = ""


func _get_drag_data(_at_position: Vector2):
	if trash_data.is_empty():
		return null

	var preview := TextureRect.new()

	preview.texture = item_icon.texture
	preview.custom_minimum_size = Vector2(64, 64)
	preview.size = Vector2(64, 64)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	set_drag_preview(preview)

	return {
		"source": self,
		"trash_id": trash_data.get("id", ""),
		"trash_type": trash_data.get("type", "")
	}


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

func _on_mouse_entered() -> void:
	hover_active = true


func _on_mouse_exited() -> void:
	hover_active = false

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return

	if event.keycode == KEY_K and hover_active:
		var menu := get_tree().get_first_node_in_group("trash_bag_menu")

		if menu:
			menu.visible = true
