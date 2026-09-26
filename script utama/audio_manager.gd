extends Node

@onready var bgm_player: AudioStreamPlayer = $BGMPlayer
@onready var ui_click: AudioStreamPlayer = $UIClick
@onready var pickup_sampah: AudioStreamPlayer = $PickupSampah
@onready var jalan: AudioStreamPlayer = $Jalan

const MAIN_MENU_BGM = preload("res://Audio/BGM/MainMenu.ogg")
const GAMEPLAY_BGM = preload("res://Audio/BGM/Gameplay.ogg")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_ui_click() -> void:
	ui_click.play()


func play_pickup_sampah() -> void:
	pickup_sampah.play()


func play_jalan() -> void:
	if not jalan.playing:
		jalan.play()


func stop_jalan() -> void:
	if jalan.playing:
		jalan.stop()

func play_main_menu_bgm() -> void:
	if bgm_player.stream == MAIN_MENU_BGM and bgm_player.playing:
		return

	bgm_player.stream = MAIN_MENU_BGM
	bgm_player.play()

func play_gameplay_bgm() -> void:
	if bgm_player.stream == GAMEPLAY_BGM and bgm_player.playing:
		return

	bgm_player.stream = GAMEPLAY_BGM
	bgm_player.play()
