extends TextureButton


var item_data: Dictionary = {}


func set_item(data: Dictionary) -> void:

	item_data = data

	if item_data.is_empty():
		texture_normal = null
		tooltip_text = ""
		return

	var item_id: String = item_data["id"]

	texture_normal = _get_item_texture(item_id)

	tooltip_text = item_id


func clear_item() -> void:

	item_data = {}

	texture_normal = null
	tooltip_text = ""


func _get_item_texture(item_id: String) -> Texture2D:

	match item_id:

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
