extends DragAndShoot
class_name Hero

var first_sleep = true

func _init():
	EventBus.connect("move_hero",self,"move_hero")

func _ready():
	$Sprite.texture = GlobalVariables.hero_stats.hero_sprite #split?

func _on_Hero_sleeping_state_changed():
	if sleeping and not first_sleep:
		EventBus.emit_signal("next_round_started")
	else:
		first_sleep = false

func move_hero(new_position):
	position = new_position

func on_body_entered(body):
	if "Enemy" in body.name:
		# lifesteal
		GlobalVariables.hero_stats.health += int(round(GlobalVariables.hero_stats.attack_damage * GlobalVariables.hero_stats.life_steal / 100))
