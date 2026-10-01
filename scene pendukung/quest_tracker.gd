extends Control

const TARGET_COIN: int = 1000

@onready var quest_title: Label = $QuestContent/QuestTitle
@onready var quest_desc: Label = $QuestContent/QuestDesc
@onready var quest_progress: Label = $QuestContent/QuestProgress


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Objective utama belum ditampilkan selama tutorial.
	visible = false

	TutorialManager.tutorial_finished.connect(
		_on_tutorial_finished
	)

	CoinManager.coin_changed.connect(
		_on_coin_changed
	)


func _on_tutorial_finished() -> void:
	show_coin_objective()


func show_coin_objective() -> void:
	quest_title.text = "Tujuan Utama"

	quest_desc.text = (
		"Dapatkan 1000 Coin untuk menyelesaikan game."
	)

	_update_coin_progress()

	visible = true


func _on_coin_changed(_amount: int) -> void:
	if not visible:
		return

	_update_coin_progress()


func _update_coin_progress() -> void:
	var current_coin: int = CoinManager.get_coins()

	quest_progress.text = (
		str(current_coin)
		+ " / "
		+ str(TARGET_COIN)
		+ " Coin"
	)
