@tool
extends NavigationRegion2D
class_name NavRoadRegion


@export var outline:PackedVector2Array
@warning_ignore("unused_private_class_variable")
@export_tool_button("bake_segs_and_upd_polygon") var ___asdsad = get_polygon
func get_polygon() -> void:
	var pols:Array[PackedVector2Array]
	
	for ch in get_children():
		ch.rebake()
		pols.append(ch.get_polygon())
	
	outline = pols.pop_back()

	for i in pols.size():
		var s = Geometry2D.merge_polygons(outline,pols[i])
		if not s.is_empty():
			outline = s[0]

@warning_ignore("unused_private_class_variable")
@export_tool_button("bake") var __asdasf = rebake
func rebake() -> void:
	var data := NavigationMeshSourceGeometryData2D.new()
	var p := navigation_polygon
	p.clear_polygons()
	p.clear_outlines()
	
	p.add_outline(outline)
	
	for o in get_tree().get_nodes_in_group("nv_geom"):
		data.add_obstruction_outline(o.global_transform * o.vertices)

	NavigationServer2D.bake_from_source_geometry_data(p, data)
