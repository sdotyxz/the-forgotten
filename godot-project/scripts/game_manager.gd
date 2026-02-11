class_name GameManager
extends Node

## The Forgotten - Game Manager
## 管理游戏状态、关卡加载和物品收集

# Signals
signal item_collected(item_name: String)
signal level_completed(level: int)
signal all_items_found()

# Game State
var current_level: int = 1
var max_levels: int = 5
var items_to_find: Array[String] = []
var items_found: Array[String] = []
var is_game_active: bool = false

# Level Data
var level_data = {
	1: {
		"name": "空旷早晨",
		"items": ["钥匙", "手机", "书籍"],
		"difficulty": "easy"
	},
	2: {
		"name": "少量顾客",
		"items": ["钥匙", "手机", "书籍", "耳机"],
		"difficulty": "normal"
	},
	3: {
		"name": "午餐高峰",
		"items": ["钥匙", "手机", "书籍", "耳机", "眼镜"],
		"difficulty": "normal"
	},
	4: {
		"name": "打烊凌乱",
		"items": ["钥匙", "手机", "书籍", "耳机", "眼镜"],
		"difficulty": "hard"
	},
	5: {
		"name": "夜间模式",
		"items": ["钥匙", "手机", "书籍", "耳机", "眼镜", "包包"],
		"difficulty": "hard"
	}
}

func _ready():
	start_level(1)

func start_level(level: int):
	current_level = level
	var data = level_data.get(level, level_data[1])
	
	items_to_find = data["items"].duplicate()
	items_found.clear()
	is_game_active = true
	
	print("关卡 ", level, " - ", data["name"])
	print("寻找物品: ", items_to_find)

func collect_item(item_name: String) -> bool:
	if not is_game_active:
		return false
	
	if item_name in items_to_find and not item_name in items_found:
		items_found.append(item_name)
		item_collected.emit(item_name)
		
		print("找到物品: ", item_name)
		print("进度: ", items_found.size(), "/", items_to_find.size())
		
		if items_found.size() >= items_to_find.size():
			complete_level()
		
		return true
	
	return false

func complete_level():
	is_game_active = false
	level_completed.emit(current_level)
	print("关卡完成! ", current_level)
	
	if current_level >= max_levels:
		all_items_found.emit()
		print("游戏通关!")
	else:
		# 自动进入下一关（或显示完成界面）
		await get_tree().create_timer(2.0).timeout
		start_level(current_level + 1)

func get_progress() -> Dictionary:
	return {
		"level": current_level,
		"found": items_found.size(),
		"total": items_to_find.size(),
		"items": items_to_find,
		"collected": items_found
	}
