extends Node

# hero
var hero_stats: HeroStatsResource setget set_hero_stats
var hero_max_health: int
var trajectory_distance: int = 100

# fight management
var current_round: int = 1 setget set_round_counter
var current_fight: int = 1
var current_stage: int = 1
var all_enemies: Array

# artifacts
var all_artifacts: Array
var equipped_artifacts: Array

#general
var current_biome = Maps.biomes.catacombs
var current_size = Maps.map_sizes.small

# testing. will be removed later
func _init() -> void:
	load_resources("res://entities/enemy/assets/resources",all_enemies)
	load_resources("res://entities/artifacts/resources",all_artifacts)
	
	hero_stats = load("res://entities/hero/assets/resources/Knight.tres")
	hero_max_health = hero_stats.health

func _ready() -> void:
# warning-ignore:return_value_discarded
	EventBus.connect("next_round_started",self,"increment_round")
	EventBus.connect("new_artifact_equipped",self,"new_artifact_equipped")
	current_biome = Maps.biomes.catacombs

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
# warning-ignore:unassigned_variable
	var enemies_of_stage: Array
	for enemy in all_enemies:
		if enemy.stage == current_stage:
			enemies_of_stage.append(enemy)
	return enemies_of_stage

func get_artifact() -> ArtifactData:
	#get rarity
	var rarity = "common"
	
	#pick random artifact of this rarity
	var selected_artifact
	randomize()
	all_artifacts.shuffle()
	for a in all_artifacts:
		if a.rarity == rarity and not is_artfiact_equipped(a.name):
			selected_artifact = a
			break
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
		"Crown of Fortune":
			hero_stats.luck += 5
			EventBus.emit_signal("hero_stats_changed")
		"Forseeing Stone":
			trajectory_distance += trajectory_distance
