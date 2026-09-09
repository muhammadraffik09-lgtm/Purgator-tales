extends Area2D

var player_in_bed = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_bed = true
		print("Tekan 'Ctrl+Z' untuk tidur")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_bed = false

func _unhandled_input(event):
	if player_in_bed and event.is_action_pressed("Tidur"):
		mulai_tidur()

func mulai_tidur():
	print("Karakter sedang tidur... Memulihkan HP / Mengubah waktu.")
	# Tambahkan efek fade-in/out atau animasi tidur di sini
	# Untuk berpindah scene dengan animasi fade otomatis
	#LayarHitam1.change_scene_to_file("res://Living_room.tscn")

# Atau panggil manual jika hanya ingin fade saja
	await LayarHitam1.fade_in()
# lakukan sesuatu...
	await LayarHitam1.fade_out()
