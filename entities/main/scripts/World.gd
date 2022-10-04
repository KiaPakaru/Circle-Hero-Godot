extends Node

var hero

func _init() -> void:
	hero = preload("res://entities/hero/Hero.tscn")

func load_map(resourcePath: String) -> void:
	var resource = load(resourcePath)
	var map = resource.instance()
	add_child(map)
	move_child(map,0)

func spawn_hero() -> void:
	add_child(hero.instance())
