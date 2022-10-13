extends CanvasLayer
# warning-ignore-all:return_value_discarded

onready var hero_stats_bar: Control = $HeroStatsBar
onready var round_counter: Control = $RoundCounter
var lock_round_counter = false

func _init() -> void:
	EventBus.connect("fight_started",self,"fight_started")
	EventBus.connect("fight_won",self,"fight_won")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hide_Stats"):
		hero_stats_bar.visible = !hero_stats_bar.visible
		if not lock_round_counter:
			round_counter.visible = !round_counter.visible
			

func fight_started():
	round_counter.visible = hero_stats_bar.visible
	lock_round_counter = false

func fight_won():
	round_counter.visible = false
	lock_round_counter = true
