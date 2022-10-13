extends Node

# hero
var hero_stats: HeroStatsResource setget set_hero_stats
var hero_max_health: int
var trajectory_distance = 100

# fight management
var current_round: int = 1 setget set_round_counter
var fight_room: int = 1

#general
var current_biome = Maps.biomes.catacombs
var current_size = Maps.map_sizes.small

# testing. will be removed later
func _init() -> void:
	hero_stats = load("res://entities/hero/assets/resources/Knight.tres")
	hero_max_health = hero_stats.health

func _ready() -> void:
# warning-ignore:return_value_discarded
	EventBus.connect("next_round_started",self,"increment_round")
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
