extends Node2D

const enemy_scene = preload("res://entities/enemy/Enemy.tscn")

onready var hero_spawn = $HeroSpawn
onready var enemy_spawns = $EnemySpawns.get_children()
onready var enemies = $Enemies


func _init() -> void:
# warning-ignore:return_value_discarded
	EventBus.connect("enemy_died",self,"check_if_won")
	
func _ready():
	position_hero()
	load_enemies()
	EventBus.emit_signal("fight_started")

func position_hero():
	EventBus.emit_signal("move_hero", hero_spawn.position, false)

func load_enemies():
	randomize()
	var enemies_of_current_stage: Array = GlobalVariables.get_enemys_of_current_stage()
	var enemy_amount = clamp(GlobalVariables.current_fight - 1 + randi() % 3, 1, 10)
	# for every enemy type
	for i in enemy_amount:
		randomize()
		# load enemy type
		enemies_of_current_stage.shuffle()
		var enemy_to_load
		for e in enemies_of_current_stage:
			if e.stage == GlobalVariables.current_stage:
				enemy_to_load = e
				break
		
		var enemy = enemy_scene.instance()
		enemy.enemy_name = enemy_to_load.enemy_name
		
		# find free position
		# get random number in spawn array size
		var spawn_index = randi()%(enemy_spawns.size())
		enemy.position = enemy_spawns[spawn_index].position
		enemy_spawns.remove(spawn_index)
		
		enemies.add_child(enemy)

func check_if_won():
	#wait one second
	yield(get_tree().create_timer(1), "timeout")
	
	if enemies.get_child_count() == 0:
		EventBus.emit_signal("fight_won")
		EventBus.emit_signal("load_map", Maps.map_types.choose)
		GlobalVariables.current_round = 1
		GlobalVariables.current_fight += 1
