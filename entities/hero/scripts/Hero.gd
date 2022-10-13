extends DragAndShoot
class_name Hero

var first_sleep_of_fight = true

var initial_position
var position_move_requested

func _init():
# warning-ignore:return_value_discarded
	EventBus.connect("move_hero",self,"move_hero")

func _ready():
	$Sprite.texture = GlobalVariables.hero_stats.hero_sprite

func _on_Hero_sleeping_state_changed():
	if sleeping and not first_sleep_of_fight:
		EventBus.emit_signal("next_round_started")
		print("trigger")
	else:
		first_sleep_of_fight = false

func move_hero(new_position, lock_shot):
	first_sleep_of_fight = true
	bypass_shot_lock = lock_shot
	initial_position = new_position
	position = initial_position
	position_move_requested = true
	sleeping = false

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if position_move_requested:
		state.transform = Transform2D(0, initial_position)
		state.linear_velocity = Vector2.ZERO
		position_move_requested = false

func on_body_entered(body):
	if "Enemy" in body.name:
		# lifesteal
		GlobalVariables.hero_stats.health += int(round(GlobalVariables.hero_stats.attack_damage * GlobalVariables.hero_stats.life_steal / 100))
