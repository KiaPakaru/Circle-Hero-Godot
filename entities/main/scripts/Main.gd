extends Node

onready var world = $World
onready var gui = $GUI

func _ready() -> void:
	start_run()

func start_run():
	world.spawn_hero()
	world.load_map("res://entities/maps/fight_maps/catacombs/Catacombs1.tscn")
