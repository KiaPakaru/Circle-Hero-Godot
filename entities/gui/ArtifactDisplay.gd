extends Control

func _ready() -> void:
	EventBus.connect("new_artifact_equipped", self, "new_artifact_equipped")

func new_artifact_equipped(artifact):
	var image = TextureRect.new()
	image.texture = artifact.sprite
	$HBoxContainer.add_child(image)
