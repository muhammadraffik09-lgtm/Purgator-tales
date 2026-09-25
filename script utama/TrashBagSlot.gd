extends TextureButton


var trash_data: Dictionary = {}
var bag_slot_index: int = -1
var bag_menu: Control = null


func setup(menu: Control, index: int) -> void:
	bag_menu = menu
	bag_slot_index = index


func set_item(data: Dictionary) -> void:
	trash_data = data

	if trash_data.is_empty():
		texture_normal = null
		tooltip_text = ""
		return

	texture_normal = _get_trash_texture(
		trash_data["id"]
	)

	tooltip_text = (
		trash_data["id"]
		+ "\nKategori: "
		+ trash_data["type"]
	)


func clear_item() -> void:
	trash_data = {}
	texture_normal = null
	tooltip_text = ""


func _get_drag_data(_at_position: Vector2):
	if trash_data.is_empty():
		return null

	if bag_slot_index < 0:
		return null

	var preview := TextureRect.new()

	preview.texture = texture_normal
	preview.custom_minimum_size = Vector2(64, 64)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	set_drag_preview(preview)

	return {
		"source": self,
		"bag_menu": bag_menu,
		"bag_slot_index": bag_slot_index,
		"trash_id": trash_data["id"],
		"trash_type": trash_data["type"]
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
