extends Panel

@onready var quest_name: Label = $QuestContent/QuestName
@onready var quest_description: Label = $QuestContent/QuestDescription
@onready var completed_icon: TextureRect = $CompletedIcon


func setup_quest(quest: Dictionary, completed: bool = false):
	quest_name.text = quest["title"]
	quest_description.text = quest["description"]

	completed_icon.visible = completed
