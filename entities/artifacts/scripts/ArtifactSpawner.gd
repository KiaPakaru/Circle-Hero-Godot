extends Position2D

export var from_choose_map: bool = false
var artifact = GlobalVariables.get_artifact()

func _ready() -> void:
	$Content/Artifact.set_artifact(artifact)
	if from_choose_map:
		EventBus.connect("new_artifact_equipped",self,"destroy_me")
	
	var color
	print(artifact.rarity)
	match artifact.rarity:
		"common":
			color = "c9c9c9"
		"uncommon":
			color = "3fff11"
		"rare":
			color = "027dff"
		"epic":
			color = "ff00ef"
		"mythical":
			color = "ffc500"
			$Content/Light2D.energy = 1.2
	$Content/Light2D.color = color

func _on_Area2D_body_entered(body: Node) -> void:
	if "Hero" in body.name:
		GlobalVariables.add_artifact(artifact)
		queue_free()

func destroy_me(_artifact):
	queue_free()
