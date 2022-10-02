extends DragAndShoot
class_name Hero

signal shot_finished
var is_inital_sleep = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = HeroStats.stats.hero_sprite

func _on_Hero_sleeping_state_changed():
	if sleeping and not is_inital_sleep:
		shot_finished()
		emit_signal("shot_finished")
	else:
		is_inital_sleep = false


func on_body_entered(body):
	if "Enemy" in body.name:
		HeroStats.stats.health += int(round(HeroStats.stats.attack_damage * HeroStats.stats.life_steal / 100))
