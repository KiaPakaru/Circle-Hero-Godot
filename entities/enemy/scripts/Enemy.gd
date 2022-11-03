extends RigidBody2D

signal enemy_stats_loaded(attack_damage,max_next_hit,max_health)
signal enemy_damage_taken(new_health)
signal enemy_next_hit_changed(new_next_hit)
signal enemy_damage_changed(new_damage)

var enemy_name = "Skeleton"
var health setget damage_taken
var max_next_hit
var attack_damage
var current_next_hit
var is_poisoned = false

func _init() -> void:
	EventBus.connect("next_round_started",self,"on_next_round")
	connect("sleeping_state_changed",self,"_on_Enemy_sleeping_state_changed")

func _ready():
	load_enemy_stats()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	rotation_degrees = 0

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
		damage_taken(GlobalVariables.hero_stats.strength)
	
	elif "Hero" in body.name:
		damage_taken(GlobalVariables.hero_stats.attack_damage)
		
		if(GlobalVariables.is_artfiact_equipped("Poisoned Dagger")):
			is_poisoned = true
		
		if(GlobalVariables.is_artfiact_equipped("Decay")):
			attack_damage -= 2
			emit_signal("enemy_damage_changed",attack_damage)
		
		if(GlobalVariables.is_artfiact_equipped("Dragon born")):
			set_linear_velocity(get_linear_velocity()*2)

func _on_Enemy_sleeping_state_changed():
	if sleeping:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0

func damage_taken(amount):
	health = clamp(health - amount, 0, health)
	emit_signal("enemy_damage_taken",health)

func on_next_round():
	if is_poisoned:
		damage_taken(10)
	
	# if enemy is dead
	if health <= 0:
		if GlobalVariables.is_artfiact_equipped("Golden gloves"):
			GlobalVariables.coins += 3
		queue_free()
		EventBus.emit_signal("enemy_died")
		return
	
	current_next_hit -= 1
	# if enemy will attack
	if current_next_hit == 0:
		randomize()
		if (randi()%100 + 1 > GlobalVariables.hero_stats.luck
			or GlobalVariables.is_artfiact_equipped("Trinity of resistance")):
				if GlobalVariables.is_artfiact_equipped("Emerald shield"):
					GlobalVariables.hero_stats.health -= (attack_damage - 2)
				else:
					GlobalVariables.hero_stats.health -= attack_damage
		current_next_hit = max_next_hit
	
	emit_signal("enemy_next_hit_changed",current_next_hit)
