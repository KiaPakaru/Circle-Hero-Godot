extends Node

onready var hero = preload("res://entities/hero/Hero.tscn")

func _init() -> void:
# warning-ignore:return_value_discarded
	EventBus.connect("load_map",self,"load_map")

func load_map(type) -> void:
	var map_path = Maps.get_map(type)
	
	$MapTransition/AnimationPlayer.play("MapTransition")
	
	# remove old map if existent
	if get_child_count() != 2:
		yield($MapTransition/AnimationPlayer, "animation_finished")
		get_child(0).queue_free()
	
	var map = load(map_path).instance()
	add_child(map)
	move_child(map,0)
	$MapTransition/AnimationPlayer.play_backwards("MapTransition")

func spawn_hero() -> void:
	add_child(hero.instance())
	move_child($MapTransition,2)
