extends RigidBody2D
# warning-ignore-all:return_value_discarded

signal enemy_stats_loaded(attack_damage,max_next_hit,max_health)
signal enemy_damage_taken(new_health)
signal enemy_next_hit_changed(new_next_hit)

var enemy_name = "Skeleton"
var health
var max_next_hit
var attack_damage
var current_next_hit

func _init() -> void:
	EventBus.connect("next_round_started",self,"on_next_round")
	connect("sleeping_state_changed",self,"_on_Enemy_sleeping_state_changed")

func _ready():
	load_enemy_stats()

func load_enemy_stats():
	var stats = load("res://entities/enemy/assets/resources/" + enemy_name + ".tres")
	$Sprite.texture = stats.enemy_sprite
	health = stats.health
	attack_damage = stats.attack_damage
	max_next_hit = stats.max_next_hit
	current_next_hit = max_next_hit
	emit_signal("enemy_stats_loaded",attack_damage,max_next_hit,health)

func _on_Enemy_body_entered(body):
	if "Enemy" in body.name:
		health = clamp(health - GlobalVariables.hero_stats.strength, 0, health)
		emit_signal("enemy_damage_taken",health)
	
	elif "Hero" in body.name:
		health = clamp(health - GlobalVariables.hero_stats.attack_damage, 0, health)
		emit_signal("enemy_damage_taken",health)

func _on_Enemy_sleeping_state_changed():
	if sleeping:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0

func on_next_round():
	# if enemy is dead
	if health <= 0:
		queue_free()
		return
	
	# if enemy will attack
	current_next_hit -= 1
	if current_next_hit == 0:
		GlobalVariables.hero_stats.health -= attack_damage
		current_next_hit = max_next_hit
	
	emit_signal("enemy_next_hit_changed",current_next_hit)
