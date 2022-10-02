extends RigidBody2D

var enemy_name = "Skeleton"
var health
var max_next_hit
var attack_damage
var current_next_hit

signal enemy_stats_loaded(attack_damage,max_next_hit,max_health)
signal enemy_damage_taken(new_health)
signal enemy_next_hit_changed(new_next_hit)

func _ready():
# warning-ignore:return_value_discarded
	connect("sleeping_state_changed",self,"_on_Enemy_sleeping_state_changed")
	load_enemy_stats()

func load_enemy_stats():
	var stats = load("res://entities/enemies/resources/" + enemy_name + ".tres")
	$Sprite.texture = stats.enemy_sprite
	health = stats.health
	attack_damage = stats.attack_damage
	max_next_hit = stats.max_next_hit
	current_next_hit = max_next_hit
	emit_signal("enemy_stats_loaded",attack_damage,max_next_hit,health)

func _on_Enemy_body_entered(body):
	if "Enemy" in body.name:
		health = clamp(health - HeroStats.stats.strength, 0, health)
		emit_signal("enemy_damage_taken",health)
	
	elif "Hero" in body.name:
		health = clamp(health - HeroStats.stats.attack_damage, 0, health)
		emit_signal("enemy_damage_taken",health)

func _on_Enemy_sleeping_state_changed():
	if sleeping:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0

func on_round_over():
	# if enemy is dead
	if health <= 0:
		queue_free()
		return
	
	# if enemy will attack
	current_next_hit -= 1
	if current_next_hit == 0:
		HeroStats.stats.health -= attack_damage
		current_next_hit = max_next_hit
	
	emit_signal("enemy_next_hit_changed",current_next_hit)
