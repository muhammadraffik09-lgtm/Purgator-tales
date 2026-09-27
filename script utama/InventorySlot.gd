extends TextureButton

@onready var item_icon: TextureRect = $ItemIcon


func setup(item_texture: Texture2D) -> void:
	if item_icon == null:
		return

	item_icon.texture = item_texture
	item_icon.visible = item_texture != null
