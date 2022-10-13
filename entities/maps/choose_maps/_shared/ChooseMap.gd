extends Node2D

onready var hero_spawn = $HeroSpawn

func _ready():
	position_hero()
	
func position_hero():
	EventBus.emit_signal("move_hero", hero_spawn.position, true)
