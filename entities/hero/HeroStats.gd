extends Node

var stats: HeroStatsResource

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = load("res://entities/hero/resources/Knight.tres")
