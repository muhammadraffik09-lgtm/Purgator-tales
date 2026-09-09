extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# Pastikan saat game mulai, layar hitam dalam posisi tidak terlihat
	color_rect.modulate.a = 0.0

func fade_in(duration: float = 1.0) -> void:
	color_rect.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float = 1.0) -> void:
	color_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
