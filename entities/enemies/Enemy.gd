extends RigidBody2D

var stats: EnemyStats
var enemy_name = "Skeleton"

func _ready():
	stats = load("res://entities/enemies/resources/" + enemy_name + ".tres")
	$Sprite.texture = stats.enemy_sprite

func _on_Enemy_body_entered(body):
	#print("Colission Detected with " + body.name)
	
	if "Enemy" in body.name:
		stats.health = clamp(stats.health - HeroStats.stats.strength, 0, stats.health)
		
	elif "Hero" in body.name:
		stats.health = clamp(stats.health - HeroStats.stats.attack_damage, 0, stats.health)
	
	print(stats.health)
