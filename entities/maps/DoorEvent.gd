extends Area2D

var map_type
onready var icon = $DoorIcon

func _ready() -> void:
	map_type = Maps.map_types.fight
	
	match map_type:
		Maps.map_types.fight:
			icon.texture = load("res://entities/_shared/ui/icons/Skull.png")
		Maps.map_types.shop:
			icon.texture = load("res://entities/_shared/ui/icons/Shop.png")

func _on_DoorEvent_body_entered(body: Node) -> void:
	if body.name == "Hero":
		EventBus.emit_signal("load_map",map_type)
