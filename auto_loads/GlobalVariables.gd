extends Node

# hero
var hero_stats: HeroStatsResource setget set_hero_stats
var trajectory_distance = 100

# fight management
var current_round: int = 1

# testing. will be removed later
func _init() -> void:
	hero_stats = load("res://entities/hero/assets/resources/Knight.tres")

func _ready() -> void:
	EventBus.connect("next_round_started",self,"increment_round")

func set_hero_stats(value):
	hero_stats = value
	EventBus.emit_signal("hero_stats_changed")

func increment_round() -> void:
	current_round += 1
