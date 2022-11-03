extends Camera2D

onready var noise = OpenSimplexNoise.new()

var decay_rate: float = 10
var noise_shake_strength: float = 30.0
var noise_shake_speed: float = 30.0
var noise_i: float = 0.0
var shake_strength: float = 0.0

func _ready() -> void:
	EventBus.connect("shake_camera",self,"shake_camera")
	randomize()
	noise.seed = randi()
	noise.period = 2

func shake_camera(strength: float,speed: float,decay: float) -> void:
	noise_shake_speed = speed
	decay_rate = decay
	shake_strength = strength

func _process(delta: float) -> void:
	# fade out shake over time
	shake_strength = lerp(shake_strength, 0, decay_rate * delta)
	
	offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
