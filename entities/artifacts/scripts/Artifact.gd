extends Control

var artifact: ArtifactData
var tooltip_active = false

func set_artifact(data):
	artifact = data
	$Icon.texture = artifact.sprite


func _on_ArtifactIcon_mouse_entered() -> void:
	tooltip_active = true
	EventBus.emit_signal("show_tooltip",rect_global_position + Vector2(8,0),Vector2(0,20),artifact.description)

func _on_ArtifactIcon_mouse_exited() -> void:
	tooltip_active = false
	EventBus.emit_signal("hide_tooltip")


func _on_Artifact_tree_exited() -> void:
	if tooltip_active:
		EventBus.emit_signal("hide_tooltip")
