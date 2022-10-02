extends RigidBody2D
class_name DragAndShoot

onready var trajectory_line = $TrajectoryLine

var drag_start_pos: Vector2
var drag_end_pos: Vector2
var is_shooting_allowed: bool = true;
var shot_not_allowed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		if Input.is_action_just_pressed("Mouse_Left"):
			drag_start_pos = get_global_mouse_position()
		if Input.is_action_just_released("Mouse_Left"):
			drag_end_pos = get_global_mouse_position()
			executeShot()
			trajectory_line.reset_trajectory()
	
	# if drag started before hero was still
	elif Input.is_action_just_pressed("Mouse_Left"):
		shot_not_allowed = true

func executeShot():
	var direction = drag_start_pos - drag_end_pos
	apply_central_impulse(direction.normalized() * 30 * HeroStats.stats.strength)
	is_shooting_allowed = false;

func shot_finished():
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		is_shooting_allowed = true
