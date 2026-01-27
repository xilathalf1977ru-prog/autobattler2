extends Node2D
class_name VisualComp
##Static visual comp

@onready var sp:Sprite2D = $Sprite2D
@export var cast_point:Node2D

func setup() -> void:
	sp.scale *= randfn(1,0.05)
	sp.self_modulate = Color(
		randf_range(0.9,1),
		randf_range(0.9,1),
		randf_range(0.9,1)
	)
func set_tex(d:StateVisualData) -> void:
	sp.texture = d.texture
	sp.offset = Vector2(
		-sp.texture.get_width()/(2.0),
		-sp.texture.get_height())

func get_area() -> Vector2:
	return sp.texture.get_size()
