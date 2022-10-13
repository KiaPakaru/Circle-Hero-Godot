extends Control
# warning-ignore-all:return_value_discarded

onready var damage_text = $Panel/Stats/AttackDamage
onready var next_hit_text = $Panel/Stats/RoundsToNextHit
onready var health_bar = $ProgressBar

func _ready():
	get_parent().connect("enemy_stats_loaded",self,"load_initial_stats")
	get_parent().connect("enemy_damage_taken",self,"update_health_bar")
	get_parent().connect("enemy_next_hit_changed",self,"update_next_hit")

func _process(_delta):
	if Input.is_action_just_pressed("Hide_Stats"):
		visible = !visible

func load_initial_stats(attack_damage,next_hit,max_health):
	damage_text.text = str(attack_damage)
	next_hit_text.text = str(next_hit)
	health_bar.max_value = max_health
	health_bar.value = max_health
	
func update_next_hit(new_next_hit):
	next_hit_text.text = str(new_next_hit)

func update_health_bar(new_health):
	health_bar.value = new_health
