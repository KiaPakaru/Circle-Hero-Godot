extends DragAndShoot


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = HeroStats.stats.hero_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
