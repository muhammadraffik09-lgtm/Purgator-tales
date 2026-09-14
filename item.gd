extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Memastikan bahwa yang menyentuh item adalah Player
	if body.is_in_group("player"):
		# Tambahkan logika permainan di sini (misal: tambah skor/HP)
		
		# Hapus item dari scene/layar
		queue_free()
