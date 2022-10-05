extends Label

export var is_hero_stat = false
export var value: String
export var singal_to_listen: String

func _ready() -> void:
	EventBus.connect(singal_to_listen,self,"change_stat")
	change_stat()

func change_stat() -> void:
	if is_hero_stat:
		text = str(GlobalVariables.hero_stats.get(value))
	else:
		text = str(GlobalVariables.get(value))
