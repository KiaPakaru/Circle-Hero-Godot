extends Node

signal hero_stats_changed

var stats: HeroStatsResource setget set_stats
var trajectory_distance = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = load("res://entities/hero/resources/Knight.tres")
	emit_signal("hero_stats_changed")

func set_stats(value):
	stats = value
	emit_signal("hero_stats_changed")
