extends Position2D

var artifact = GlobalVariables.get_artifact()

func _ready() -> void:
	$Sprite.texture = artifact.sprite



func _on_Area2D_body_entered(body: Node) -> void:
	if "Hero" in body.name:
		GlobalVariables.add_artifact(artifact)
		queue_free()
