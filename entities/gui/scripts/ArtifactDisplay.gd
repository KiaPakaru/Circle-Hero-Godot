extends Control

var artifact_icon = preload("res://entities/artifacts/Artifact.tscn")

func _ready() -> void:
	EventBus.connect("new_artifact_equipped", self, "new_artifact_equipped")

func new_artifact_equipped(artifact):
	var icon = artifact_icon.instance()
	icon.set_artifact(artifact)
	add_child(icon)
