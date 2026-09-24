extends Control

@onready var character_info_panel: Control = $Panel/CharacterInfoPanel
@onready var tab_content: Control = $Panel/TabContent
@onready var achievement_content: Control = $Panel/TabContent/AchievementContent
@onready var skill_content: Control = $Panel/TabContent/SkillContent


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_show_tab(0)


func _on_tab_bar_tab_changed(tab: int) -> void:
	_show_tab(tab)


func _show_tab(tab: int) -> void:
	character_info_panel.visible = tab == 0

	tab_content.visible = tab != 0

	achievement_content.visible = tab == 1
	skill_content.visible = tab == 2


func _on_back_button_pressed() -> void:
	if not UITransitionManager.try_transition():
		return

	visible = false
