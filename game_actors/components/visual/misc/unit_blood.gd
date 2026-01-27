extends TextureRect
class_name UnitBlood

func set_blood(val:float) -> void:
	modulate.a = 1.0 - val**2
