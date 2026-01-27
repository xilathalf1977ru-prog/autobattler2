@tool
extends Resource
class_name BezieCurve

@export var p0:Vector2
@export var p1:Vector2
@export var p2:Vector2

@export var height_factor:float = 0.5
@export var pts:PackedVector2Array
@export var samples:int = 16

func setup(v0:Vector2,v2:Vector2) -> void:
	p0 = v0
	p2 = v2
	upd(p2)

func upd(v2: Vector2) -> void:
	p2 = v2

	var mid := (p0 + p2) * 0.5
	var dist := p0.distance_to(p2)

	p1 = mid
	p1.y -= dist * height_factor

func sample(t:float) -> Vector2:
	return (
		(1 - t) ** 2 * p0 + 
		2*t*(1 - t) * p1 + 
		t**2 * p2
		)

func get_pts() -> PackedVector2Array:
	pts.clear()
	for i in samples:
		pts.append(sample(float(i)/(samples - 1)))
	return pts
