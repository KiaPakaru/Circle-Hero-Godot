extends Node2D

signal round_over

var enemy_node
var current_round: int = 1
var spawn_points: Array
var hero_spawn

func _on_FightScene_tree_entered():
	load_level()
	load_hero()
	load_enemies()

func load_level():
	var scene = load("res://scenes/fightScene/Maps/Catacombs1.tscn")
	var map = scene.instance()
	hero_spawn = map.get_node("HeroSpawn")
	spawn_points = map.get_node("SpawnPoints").get_children()
	add_child(map)

func load_hero():
	var scene = load("res://entities/hero/Hero.tscn")
	var player = scene.instance()
	player.position = hero_spawn.position
	add_child(player)
	player.connect("shot_finished",self,"next_round")

func load_enemies():
	var enemiesToLoad = {"Skeleton": 2, "Wolf": 2}
	enemy_node = $Enemies
	# for every enemy type
	for item in enemiesToLoad:
		# for amount of this enemy type 
		for i in enemiesToLoad[item]:
			# load enemy type
			var scene = load("res://entities/enemies/Enemy.tscn")
			var enemy = scene.instance()
			enemy.enemy_name = item
			
			# find free position
			# get random number in spawn array size
			randomize()
			var spawn_index = randi()%(spawn_points.size())
			enemy.position = spawn_points[spawn_index].position
			spawn_points.remove(spawn_index)
			
			enemy_node.add_child(enemy)
			enemy.connect("tree_exited",self,"check_hero_won")
# warning-ignore:return_value_discarded
			connect("round_over",enemy,"on_round_over")

func next_round():
	current_round += 1
	emit_signal("round_over")

func check_hero_won():
	if enemy_node.get_child_count() == 0:
		print("Won")
