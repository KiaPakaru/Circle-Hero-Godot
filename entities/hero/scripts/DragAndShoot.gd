extends RigidBody2D
class_name DragAndShoot

var drag_start_pos: Vector2
var drag_end_pos: Vector2
var is_shooting_allowed: bool = true;
var shot_not_allowed = false
var bypass_shot_lock = false

onready var trajectory_line = $TrajectoryLine

func _init():
	EventBus.connect("next_round_started",self,"make_ready_for_shot")


func _process(_delta):
	checkForShotInput()


func _physics_process(_delta):
	#calculate trajectory
		if Input.is_action_pressed("Mouse_Left") and not shot_not_allowed and is_shooting_allowed:
			var direction = drag_start_pos - get_global_mouse_position()
			trajectory_line.calculate_trajectory(direction.normalized())


func checkForShotInput():
		# cancel shot
		if Input.is_action_just_pressed("Mouse_Right"):
			shot_not_allowed = true
			trajectory_line.reset_trajectory()
		
		# if drag started before hero was still
		if shot_not_allowed and Input.is_action_just_released("Mouse_Left"):
			shot_not_allowed = false
		
		# drag process
		elif is_shooting_allowed:
			$ReadyIndicator.visible = true
			if Input.is_action_just_pressed("Mouse_Left"):
				drag_start_pos = get_global_mouse_position()
				
			if Input.is_action_just_released("Mouse_Left"):
				drag_end_pos = get_global_mouse_position()
				if drag_end_pos != drag_start_pos:
					executeShot()
				trajectory_line.reset_trajectory()
		
		# if drag started before hero was still
		elif Input.is_action_just_pressed("Mouse_Left"):
			shot_not_allowed = true


func executeShot():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	var direction = drag_start_pos - drag_end_pos
	apply_central_impulse(direction.normalized() * 30 * GlobalVariables.hero_stats.strength)
	if not bypass_shot_lock:
		is_shooting_allowed = false
		$ReadyIndicator.visible = false
	AudioManager.play_type(AudioManager.sound_type.dash)


func make_ready_for_shot():
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		is_shooting_allowed = true
