extends Node2D

onready var rich_text: RichTextLabel = $ToolTipBox/Text

func _ready() -> void:
	EventBus.connect("show_tooltip",self,"show_tooltip")
	EventBus.connect("hide_tooltip",self,"hide_tooltip")

func show_tooltip(pos, offset, text):
	position = pos + offset
	rich_text.bbcode_text = text
	visible = true


func hide_tooltip():
	visible = false
	position = Vector2.ZERO
