extends Node

signal quest_added(quest)
signal quest_completed(quest)

var active_quests: Array = []
var completed_quests: Array = []


var quest_bahan_alat := {
	"id": "quest_bahan_alat",
	"title": "Cari Bahan Untuk Membuat Alat",
	"description": "Kumpulkan bahan yang diperlukan untuk membuat alat.",
	"type": "main"
}


var quest_pedagang_desa := {
	"id": "quest_pedagang_desa",
	"title": "Temui Pedagang Desa",
	"description": "Temui pedagang desa dan bicaralah dengannya.",
	"type": "side"
}


func add_quest(quest: Dictionary):
	if active_quests.has(quest):
		return

	active_quests.append(quest)
	quest_added.emit(quest)


func complete_quest(quest: Dictionary):
	if not active_quests.has(quest):
		return

	active_quests.erase(quest)
	completed_quests.append(quest)
	quest_completed.emit(quest)


func has_quest(quest_id: String) -> bool:
	for quest in active_quests:
		if quest["id"] == quest_id:
			return true

	for quest in completed_quests:
		if quest["id"] == quest_id:
			return true

	return false
