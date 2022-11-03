extends Node

#HERO
var hero_stats: HeroStatsResource setget set_hero_stats
var hero_max_health: int
var trajectory_distance: int = 100

#FIGHT MANAGEMENT
var current_round: int = 1 setget set_round_counter
var current_fight: int = 1
var current_stage: int = 1
var all_enemies: Array

#ARTIFACTS
var all_artifacts: Array
var equipped_artifacts: Array

#CURRENCY
var coins: int = 0

#GENERAL
var current_biome = biomes.catacombs
var current_size = map_sizes.small

#MAPS
enum biomes{
	catacombs
}
enum map_sizes{
	small,
	medium,
	large
}
enum map_types{
	fight,
	choose,
	shop
}

onready var maps = [
	{"type": map_types.fight, "biome" : biomes.catacombs, "size" : "small", "path" : "res://entities/maps/fight_maps/catacombs/Catacombs1.tscn"},
	{"type": map_types.fight, "biome" : biomes.catacombs, "size" : "small", "path" : "res://entities/maps/fight_maps/catacombs/Catacombs2.tscn"},
	{"type": map_types.choose, "biome" : biomes.catacombs, "path" : "res://entities/maps/choose_maps/ChooseMap1.tscn"},
]

# testing. will be removed later
func _init() -> void:
	load_resources("res://entities/enemy/assets/resources",all_enemies)
	load_resources("res://entities/artifacts/resources",all_artifacts)
	
	hero_stats = load("res://entities/hero/assets/resources/Knight.tres")
	hero_max_health = hero_stats.health

func _ready() -> void:
	EventBus.connect("next_round_started",self,"increment_round")
	EventBus.connect("new_artifact_equipped",self,"new_artifact_equipped")
	current_biome = GlobalVariables.biomes.catacombs

func set_hero_stats(value):
	hero_stats = value
	hero_stats.health = clamp(hero_stats.health,0,hero_max_health)
	EventBus.emit_signal("hero_stats_changed")

func increment_round() -> void:
	current_round += 1
	EventBus.emit_signal("update_round_counter")

func set_round_counter(value):
	current_round = value
	EventBus.emit_signal("update_round_counter")

func load_resources(folder_path, array_to_fill) -> void:
	# open resource folder
	var dir = Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true)
	
	var file_name = dir.get_next()
	while(file_name!=""): 
		var resource = load(folder_path + "/" + file_name)
		array_to_fill.append(resource)
		file_name = dir.get_next()

func get_enemys_of_current_stage() -> Array:
	var enemies_of_stage: Array
	for enemy in all_enemies:
		if enemy.stage == current_stage:
			enemies_of_stage.append(enemy)
	return enemies_of_stage

func get_artifact() -> ArtifactData:
	randomize()
	#get rarity
	var rarity
	var value = rand_range(0,100)
	
	# 1%
	if value >= 99:
		rarity = "mythical"
	# 5%
	elif value >= 94:
		rarity = "epic"
	# 10%
	elif value >= 84:
		rarity = "rare"
	# 30%
	elif value >= 54:
		rarity = "uncommon"
	# 54%
	elif value < 54 :
		rarity = "common"
	
	print("chance was " + str(value) + ": " + rarity)
	
	#pick random artifact of this rarity
	var selected_artifact
	all_artifacts.shuffle()
	for a in all_artifacts:
		if a.rarity == rarity and not is_artfiact_equipped(a.name):
			selected_artifact = a
			break
	if(selected_artifact == null):
		printerr("No artifact of rarity " + rarity + " available")
		selected_artifact = all_artifacts[0]
	return selected_artifact

func add_artifact(artifact):
	equipped_artifacts.append(artifact)
	EventBus.emit_signal("new_artifact_equipped",artifact)

func is_artfiact_equipped(artifact_name) -> bool:
	for a in equipped_artifacts:
		if a.name == artifact_name:
			return true
	return false

func new_artifact_equipped(artifact):
	match artifact.name:
		"Crown of fortune":
			hero_stats.luck += 5
			EventBus.emit_signal("hero_stats_changed")
		"Forseeing Stone":
			trajectory_distance += trajectory_distance
		"Rune of strength":
			hero_stats.strength += 5
			EventBus.emit_signal("hero_stats_changed")
		"Rune of vitality":
			hero_stats.health += 10
			hero_max_health += 10
			EventBus.emit_signal("hero_stats_changed")
		"Rune of life steal":
			hero_stats.life_steal += 5
			EventBus.emit_signal("hero_stats_changed")
		"Kathanas necklace":
			hero_stats.attack_damage += 5
			EventBus.emit_signal("hero_stats_changed")
		"Trinity of resistance":
			hero_stats.attack_damage += 5
			hero_stats.life_steal += 5
			hero_stats.strength += 5
			EventBus.emit_signal("hero_stats_changed")

func get_map(type) -> String:
	# randomize maps
	randomize()
	maps.shuffle()
	
	# get machting map
	var map
	
	for i in maps.size():
		var current_map = maps[i]
		match type:
			map_types.fight:
				if (current_map.biome == GlobalVariables.current_biome
				and current_map.type == map_types.fight
				and current_map.size == "small"):
					map = current_map
					break
			map_types.choose:
					if (current_map.biome == GlobalVariables.current_biome
					and current_map.type == map_types.choose):
						map = current_map
						break
	
	return map.path
