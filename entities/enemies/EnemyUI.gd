extends Control

onready var damage_text = $Panel/Stats/AttackDamage
onready var next_hit_text = $Panel/Stats/RoundsToNextHit
onready var health_bar = $ProgressBar

var max_next_hit
var current_next_hit

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	get_parent().connect("enemy_stats_loaded",self,"load_initial_stats")
# warning-ignore:return_value_discarded
	get_parent().connect("enemy_damage_taken",self,"update_health_bar")
# warning-ignore:return_value_discarded
	get_parent().connect("enemy_next_hit_changed",self,"update_next_hit")

func load_initial_stats(attack_damage,next_hit,max_health):
	damage_text.text = str(attack_damage)
	max_next_hit = next_hit
	current_next_hit = next_hit
	next_hit_text.text = str(next_hit)
	health_bar.max_value = max_health
	health_bar.value = max_health
	
func update_next_hit(new_next_hit):
	next_hit_text.text = str(new_next_hit)

func update_health_bar(new_health):
	health_bar.value = new_health
