extends Node2D

func _on_Area2D_body_entered(body: Node) -> void:
	if "Hero" in body.name:
		GlobalVariables.coins += 10
		EventBus.emit_signal("coins_updated")
		AudioManager.play("pick_up.wav",-20.0, 1.0)
		queue_free()
