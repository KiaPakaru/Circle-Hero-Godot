extends Control

onready var health_text = $Bar/VBoxContainer/StatContainer/Health/Value
onready var attack_damage_text = $Bar/VBoxContainer/StatContainer/AttackDamage/Value
onready var strength_text = $Bar/VBoxContainer/StatContainer/Strength/Value
onready var life_steal_text = $Bar/VBoxContainer/StatContainer/Lifesteal/Value
onready var mana_text = $Bar/VBoxContainer/StatContainer/Mana/Value
onready var luck_text = $Bar/VBoxContainer/StatContainer/Luck/Value

func _ready():
# warning-ignore:return_value_discarded
	HeroStats.connect("hero_stats_changed",self,"stat_change")
	stat_change()

func stat_change():
	health_text.text = str(HeroStats.stats.health)
	attack_damage_text.text = str(HeroStats.stats.attack_damage)
	strength_text.text = str(HeroStats.stats.strength)
	life_steal_text.text = str(HeroStats.stats.life_steal)
	mana_text.text = str(HeroStats.stats.mana)
	luck_text.text = str(HeroStats.stats.luck)
