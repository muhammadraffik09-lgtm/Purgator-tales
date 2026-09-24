extends Area2D

@export_enum("Organik", "Anorganik", "B3")
var trash_type: String = "Organik"

@export_enum(
	"Kumpulan Tanah",
	"Pisang",
	"Botol Plastik",
	"Kantong Sampah",
	"Baterai",
	"Jarum Suntik"
)
var trash_id: String = "Kumpulan Tanah"

@onready var trash_sprite: Sprite2D = $TrashSprite


func _ready() -> void:
	_update_trash_sprite()


func _update_trash_sprite() -> void:
	match trash_id:
		"Kumpulan Tanah":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Kumpulan Tanah (Orga).png"
			)

		"Pisang":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Pisang (Orga).png"
			)

		"Botol Plastik":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Botol_Plastik (Anor).png"
			)

		"Kantong Sampah":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Kantong Sampah (Anor).png"
			)

		"Baterai":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Baterai (B3).png"
			)

		"Jarum Suntik":
			trash_sprite.texture = preload(
				"res://Asset/Icon UI/Item/Jarum Suntik (B3).png"
			)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if not body.has_method("add_trash_to_bag"):
		return

	var berhasil_masuk: bool = body.add_trash_to_bag(
		trash_id,
		trash_type
	)

	if not berhasil_masuk:
		print("Karung Sampah penuh!")
		return

	print(
		"Sampah diambil: ",
		trash_id,
		" | ",
		trash_type
	)

	queue_free()
