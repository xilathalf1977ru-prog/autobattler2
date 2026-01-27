extends Node
class_name FXMng

@export var text:PackedScene

func add_text(p:Vector2, s:String) -> void:
	var t:TextFX = text.instantiate()
	add_child(t)
	t.global_position = p
	t.start(s)
