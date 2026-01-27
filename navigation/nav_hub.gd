@tool
extends Node2D
class_name NavRoadHub

@export var road_width:float = 25
@export var pts_count:int = 5

@export var outline:PackedVector2Array


func get_polygon() -> PackedVector2Array:
	var pols:Array[PackedVector2Array]
	var res:PackedVector2Array = outline.duplicate()
	
	for i in res.size():
		res[i] = global_transform * res[i]
		
	for ch in get_children():
		ch.rebake()
		pols.append(ch.get_polygon())
	
	for i in pols.size():
		var s = Geometry2D.merge_polygons(res,pols[i])
		if not s.is_empty():
			res = s[0]

	return res

@warning_ignore("unused_private_class_variable")
@export_tool_button("bake") var __asdasf = rebake
func rebake() -> void:
	outline.clear()
	for i in pts_count:
		var p = road_width *  Vector2.UP.rotated(float(i)/pts_count * TAU)
		outline.append(p)
	queue_redraw()

func _draw() -> void:
	draw_polyline(outline,Color.YELLOW,1)
	draw_line(outline[0], outline[outline.size() - 1],Color.YELLOW,1)
