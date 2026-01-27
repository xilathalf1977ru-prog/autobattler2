@tool
extends Line2D
class_name NavRoadSegment

@export var road_width:float = 10

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
	
	for i in points.size():
		var p:Vector2 = points[i] 
		
		var dir:Vector2
		var miter_scale = 1.0

		if i == 0:
			dir = points[i + 1] - p
		elif i == get_point_count()-1:
			dir = p - points[i - 1]
		else:
			var prev:Vector2 = (p - points[i - 1]).normalized()
			var next:Vector2 = (points[i + 1] - p).normalized()
			dir = (prev + next).normalized()
			
			var angle = prev.angle_to(next)
			miter_scale = 1.0 / cos(angle * 0.5)

		var perp = Vector2(-dir.y,dir.x).normalized()
		
		outline.append(p + perp * road_width * miter_scale)
	
	for i in range(points.size() - 1,-1,-1):
		var p:Vector2 = points[i]
		
		var dir:Vector2
		var miter_scale = 1.0
		
		if i == 0:
			dir = p - points[i + 1]
		elif i == get_point_count()-1:
			dir = -p + points[i - 1]
		else:
			var prev = (points[i - 1] - p).normalized()
			var next = (p - points[i + 1]).normalized()
			dir = (prev + next).normalized()

			var angle = prev.angle_to(next)
			miter_scale = 1.0 / cos(angle * 0.5)
			
		var perp = Vector2(-dir.y,dir.x).normalized()
		
		outline.append(p + perp * road_width * miter_scale)

	queue_redraw()

func _draw() -> void:
	draw_polyline(outline,Color.YELLOW,1)
	draw_line(outline[0], outline[outline.size() - 1],Color.YELLOW,1)
