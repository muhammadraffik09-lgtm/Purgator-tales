extends Control

const QUEST_ENTRY_SCENE = preload("res://scene pendukung/QuestEntry.tscn")

@onready var active_quest_container: VBoxContainer = $QuestScroll/QuestList/ActiveQuestContainer
@onready var completed_quest_container: VBoxContainer = $QuestScroll/QuestList/CompletedQuestContainer


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	QuestManager.quest_added.connect(_on_quest_added)
	QuestManager.quest_completed.connect(_on_quest_completed)

	_refresh_quests()


func _on_quest_added(quest: Dictionary):
	_add_active_quest(quest)


func _on_quest_completed(quest: Dictionary):
	_refresh_quests()


func _refresh_quests():
	_clear_container(active_quest_container)
	_clear_container(completed_quest_container)

	for quest in QuestManager.active_quests:
		_add_active_quest(quest)

	for quest in QuestManager.completed_quests:
		_add_completed_quest(quest)


func _add_active_quest(quest: Dictionary):
	var quest_entry = QUEST_ENTRY_SCENE.instantiate()

	active_quest_container.add_child(quest_entry)

	quest_entry.setup_quest(quest, false)


func _add_completed_quest(quest: Dictionary):
	var quest_entry = QUEST_ENTRY_SCENE.instantiate()

	completed_quest_container.add_child(quest_entry)

	quest_entry.setup_quest(quest, true)


func _clear_container(container: VBoxContainer):
	for child in container.get_children():
		child.queue_free()


func _on_back_button_pressed():
	visible = false
