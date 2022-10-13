extends Node

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
	{"type": map_types.fight, "biome" : biomes.catacombs, "size" : "small", "path" : "res://entities/maps/fight_maps/catacombs/Catacombs1.tscn"},
	{"type": map_types.choose, "biome" : biomes.catacombs, "path" : "res://entities/maps/choose_maps/ChooseMap1.tscn"},
]

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
