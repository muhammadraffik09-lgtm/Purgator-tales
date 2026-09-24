extends CharacterBody2D

const kecepatan = 300
var arah = "diam"

const TRASH_BAG_CAPACITY := 20

var trash_bag_items: Array[Dictionary] = []

signal trash_bag_changed

func _physics_process(delta):
	gerak_player(delta)
	

func gerak_player(_delta):
	if get_viewport().gui_get_focus_owner() is LineEdit:
		arah_player(false)
		velocity.x = 0
		velocity.y = 0
		return

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

func add_trash_to_bag(
	trash_id: String,
	trash_type: String
) -> bool:

	if trash_bag_items.size() >= TRASH_BAG_CAPACITY:
		return false

	var trash_data: Dictionary = {
		"id": trash_id,
		"type": trash_type
	}

	trash_bag_items.append(trash_data)

	trash_bag_changed.emit()

	print(
		"Sampah masuk Karung: ",
		trash_id,
		" | ",
		trash_type
	)

	print(
		"Karung: ",
		trash_bag_items.size(),
		"/",
		TRASH_BAG_CAPACITY
	)

	return true

func is_trash_bag_full() -> bool:
	return trash_bag_items.size() >= TRASH_BAG_CAPACITY


func get_trash_bag_count() -> int:
	return trash_bag_items.size()

const DIALOGUE_FILE = preload("res://percakapan.dialogue")

@onready var tilemap: TileMapLayer = $objek
