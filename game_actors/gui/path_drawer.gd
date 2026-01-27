extends Node2D
class_name PathDrawer

@export var size:float = 2
var data:PackedVector2Array

func upd(_data:PackedVector2Array) -> void:
	var d:PackedVector2Array
	d.resize(_data.size())
	for i in _data.size():
		d[i] = to_local(_data[i])
	data = d
	queue_redraw()

func _draw() -> void:
	if data.size() < 2:return
	var c:PackedColorArray
	for i in data.size():
		var cc = Color.BROWN if i%2 == 0 else Color.BLUE_VIOLET
		c.append(cc)
		draw_circle(data[i],size * 3,cc * 2)
	draw_polyline_colors(data,c,size)
