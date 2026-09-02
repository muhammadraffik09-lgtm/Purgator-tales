extends CharacterBody2D

const kecepatan = 300
var arah = "diam"

func _physics_process(delta):
	gerak_player(delta)

func gerak_player(_delta):
	if Input.is_action_pressed("ui_right"):
		arah = "kanan"
		arah_player(true)
		velocity.x = kecepatan
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		arah = "kiri"
		arah_player(true)
		velocity.x = -kecepatan
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		arah = "atas"
		arah_player(true)
		velocity.x = 0
		velocity.y = -kecepatan
	elif Input.is_action_pressed("ui_down"):
		arah = "bawah"
		arah_player(true)
		velocity.x = 0
		velocity.y = kecepatan
	else:
		arah_player(false)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func arah_player(gerak):
	var arah_sekarang = arah
	var animasi = $AnimatedSprite2D
	
	if arah_sekarang == "kanan":
		animasi.flip_h = false
		if gerak:
			animasi.play("jalan_kanan")
		else:
			animasi.play("diam")
	elif arah_sekarang == "kiri":
		animasi.flip_h = true
		if gerak:
			animasi.play("jalan_kiri")
		else:
			animasi.play("diam")
	elif arah_sekarang == "atas":
		if gerak:
			animasi.play("jalan_atas")
		else:
			animasi.play("diam")
	elif arah_sekarang == "bawah":
		if gerak:
			animasi.play("jalan_bawah")
		else:
			animasi.play("diam")
func _ready():
	add_to_group("player")
	
	# Jika player baru keluar dari rumah
	if Global.is_spawning:
		# Cari node Marker2D yang ada di group "spawn_point"
		var spawn_node = get_tree().get_first_node_in_group("spawn_point")
		if spawn_node:
			global_position = spawn_node.global_position
		
		Global.is_spawning = false # Reset kembali statusnya
		
const DIALOGUE_FILE = preload("res://percakapan.dialogue")

	# Cek apakah player baru saja keluar dari rumah
