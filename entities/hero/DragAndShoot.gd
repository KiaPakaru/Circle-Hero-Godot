extends RigidBody2D
class_name DragAndShoot

var drag_start_pos: Vector2
var drag_end_pos: Vector2
var is_shooting_allowed: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("sleeping_state_changed",self,"_on_Hero_sleeping_state_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	checkForShotInput()

	if not is_shooting_allowed:
		pass


func checkForShotInput():
	if is_shooting_allowed:
		if Input.is_action_just_pressed("Mouse_Left"):
			drag_start_pos = get_global_mouse_position()
		if Input.is_action_just_released("Mouse_Left"):
			drag_end_pos = get_global_mouse_position()
			executeShot()

func executeShot():
	var direction = drag_start_pos - drag_end_pos
	apply_central_impulse(direction.normalized() * 30 * HeroStats.stats.strength)
	is_shooting_allowed = false;

func _on_Hero_sleeping_state_changed():
	if sleeping:
		is_shooting_allowed = true
