extends PanelContainer

# Jangan gunakan $MarginContainer/Label secara langsung
var label: Label

func _ready():
	# Cari node Label secara fleksibel saat node dimuat
	label = find_child("Label", true, false) as Label

func show_message(text: String, duration: float = 3.0):
	if label == null:
		label = find_child("Label", true, false) as Label
	
	if label:
		label.text = text
		show()
		await get_tree().create_timer(duration).timeout
		if is_instance_valid(self):
			queue_free()
	else:
		print("Error: Node Label tidak ditemukan di dalam scene ini!")
