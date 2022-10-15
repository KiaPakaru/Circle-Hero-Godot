extends Node
# warning-ignore-all:unused_signal

# hero
signal hero_stats_changed
signal move_hero(new_pos, lock_shot)

# fight management
signal fight_started
signal next_round_started
signal fight_won
signal enemy_died

# artifacts
signal new_artifact_equipped(artifact)

# map
signal load_map(type)

# gui
signal update_round_counter
