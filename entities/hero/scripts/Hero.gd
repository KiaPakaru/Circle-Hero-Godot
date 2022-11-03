extends DragAndShoot
class_name Hero

var first_sleep_of_fight = true
var first_shot = true

var initial_position
var position_move_requested

func _init():
	EventBus.connect("move_hero",self,"move_hero")

func _ready():
	$Sprite.texture = GlobalVariables.hero_stats.hero_sprite

func _on_Hero_sleeping_state_changed():
	if sleeping and not first_sleep_of_fight:
		EventBus.emit_signal("next_round_started")
		first_shot = false
	else:
		first_sleep_of_fight = false

func move_hero(new_position, lock_shot):
	set_initial_values()
	bypass_shot_lock = lock_shot
	initial_position = new_position
	position = initial_position
	position_move_requested = true
	sleeping = false

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	rotation_degrees = 0
	if position_move_requested:
		state.transform = Transform2D(0, initial_position)
		state.linear_velocity = Vector2.ZERO
		position_move_requested = false

func on_body_entered(body):
	if "Enemy" in body.name:
		# lifesteal
		if first_shot and GlobalVariables.is_artfiact_equipped("Scythe of Erethos"):
			print("scythe_hit")
			GlobalVariables.hero_stats.health += int(round(GlobalVariables.hero_stats.attack_damage))
		else:
			GlobalVariables.hero_stats.health += int(round(GlobalVariables.hero_stats.attack_damage * GlobalVariables.hero_stats.life_steal / 100))
		
		AudioManager.play_type(AudioManager.sound_type.hero_attack)
		EventBus.emit_signal("shake_camera",10.0,30.0,10.0)

func set_initial_values() -> void:
	first_sleep_of_fight = true
	first_shot = true
	make_ready_for_shot()
