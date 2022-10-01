extends Node2D

var current_round: int = 0
var spawn_points: Array
var hero_spawn
var enemy_node

func _on_FightScene_tree_entered():
	load_level()
	load_hero()
	load_enemies()

func load_level():
	var scene = load("res://scenes/FightScene/Maps/Catacombs1.tscn")
	var map = scene.instance()
	hero_spawn = map.get_node("HeroSpawn")
	spawn_points = map.get_node("SpawnPoints").get_children()
	add_child(map)

func load_hero():
	var scene = load("res://entities/hero/Hero.tscn")
	var player = scene.instance()
	player.position = hero_spawn.position
	add_child(player)

func load_enemies():
	var enemiesToLoad = {"Skeleton": 2, "Wolf": 2}
	add_child(Node2D.new())
	enemy_node = get_child(get_child_count()-1)
	for item in enemiesToLoad:
			for i in enemiesToLoad[item]:
				# load enemy type
				var scene = load("res://entities/enemies/Enemy.tscn")
				var enemy = scene.instance()
				enemy.enemy_name = item
				
				# find free position
				randomize()
				var spawn_index = randi()%(spawn_points.size())
				enemy.position = spawn_points[spawn_index].position
				spawn_points.remove(spawn_index)
				
				enemy_node.add_child(enemy)

