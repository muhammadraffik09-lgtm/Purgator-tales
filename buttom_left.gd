extends Control

@onready var quest_tracker: Control = $QuestTracker

var quest_open: bool = false

const PANEL_OPEN_X := 64.0
const PANEL_CLOSED_X := -300.0
const SLIDE_DURATION := 0.3

var slide_tween: Tween


func _ready():
	# Posisi awal: panel sepenuhnya di luar layar
	quest_tracker.global_position.x = PANEL_CLOSED_X


func _on_quest_button_pressed():

	quest_open = !quest_open

	# Hentikan animasi sebelumnya jika masih berjalan
	if slide_tween:
		slide_tween.kill()

	# Buat animasi baru
	slide_tween = create_tween()
	slide_tween.set_trans(Tween.TRANS_QUAD)
	slide_tween.set_ease(Tween.EASE_OUT)

	if quest_open:
		# Slide dari kiri ke kanan
		slide_tween.tween_property(
			quest_tracker,
			"global_position:x",
			PANEL_OPEN_X,
			SLIDE_DURATION
		)

	else:
		# Slide dari kanan ke kiri
		slide_tween.tween_property(
			quest_tracker,
			"global_position:x",
			PANEL_CLOSED_X,
			SLIDE_DURATION
		)
