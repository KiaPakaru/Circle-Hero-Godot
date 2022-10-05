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

func position_hero():
	EventBus.emit_signal("move_hero", hero_spawn.position)

func load_enemies():
	var enemiesToLoad = {"Skeleton": 1, "Wolf": 0}
	# for every enemy type
	for item in enemiesToLoad:
		# for amount of this enemy type 
		for i in enemiesToLoad[item]:
			# load enemy type
			var enemy = enemy_scene.instance()
			enemy.enemy_name = item
			
			# find free position
			# get random number in spawn array size
			randomize()
			var spawn_index = randi()%(enemy_spawns.size())
			enemy.position = enemy_spawns[spawn_index].position
			enemy_spawns.remove(spawn_index)
			
			enemies.add_child(enemy)

func check_if_won():
	#wait one second
	yield(get_tree().create_timer(1), "timeout")
	
	if enemies.get_child_count() == 0:
		EventBus.emit_signal("fight_won")
		GlobalVariables.current_round = 1
		print("Won")
