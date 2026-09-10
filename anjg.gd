extends CharacterBody2D

var speed: float = 100.0
var target_marker: Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# Cari marker jika belum ketemu
	if not is_instance_valid(target_marker):
		target_marker = get_tree().get_first_node_in_group("anjing_target")
		return

	var marker_pos: Vector2 = target_marker.global_position
	
	if global_position.distance_to(marker_pos) > 15.0:
		var direction: Vector2 = global_position.direction_to(marker_pos)
		velocity = direction * speed
		
		# Panggil fungsi penentu animasi pergerakan
		play_move_animation(direction)
	else:
		velocity = Vector2.ZERO
		# Panggil fungsi penentu animasi diam
		play_idle_animation()

	move_and_slide()

# Fungsi untuk menentukan animasi saat berjalan
func play_move_animation(dir: Vector2) -> void:
	# Cek apakah gerakan dominan secara horizontal (kiri/kanan) atau vertikal (atas/bawah)
	if abs(dir.x) > abs(dir.y):
		# Bergerak Kanan / Kiri
		sprite.play("jalan") # Atau "walk_right"
		sprite.flip_h = dir.x < 0 # Flip gambar jika ke kiri
	else:
		# Bergerak Atas / Bawah
		sprite.flip_h = false
		if dir.y < 0:
			sprite.play("walk_up")   # Jalan ke atas
		else:
			sprite.play("walk_down") # Jalan ke bawah

# Fungsi untuk menentukan animasi saat berhenti (idle)
func play_idle_animation() -> void:
	# Memasang animasi idle sesuai arah terakhir animasi berjalan
	if sprite.animation.begins_with("walk_up"):
		sprite.play("idle_up")
	elif sprite.animation.begins_with("walk_down"):
		sprite.play("idle_down")
	else:
		sprite.play("idle") # Atau "idle_right"
