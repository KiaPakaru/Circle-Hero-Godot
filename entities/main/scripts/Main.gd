extends Node

onready var world = $World
onready var gui = $GUI

func _ready() -> void:
	start_run()

func start_run():
	world.spawn_hero()
	world.load_map(GlobalVariables.map_types.fight)
