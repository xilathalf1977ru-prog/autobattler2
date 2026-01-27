@tool
extends NavigationRegion2D
class_name NvMng

@onready var world:BattleMng = get_parent()

@onready var nv_road:NavRoadRegion = $Road

@warning_ignore("unused_private_class_variable")
@export_tool_button("bake") var __asdasf = rebake
func rebake() -> void:
	var size = world.size
	var data := NavigationMeshSourceGeometryData2D.new()

	var p := navigation_polygon
	p.clear_polygons()
	p.clear_outlines()

	var outline = PackedVector2Array([
		Vector2(0, 0), 
		Vector2(0, size.y), 
		Vector2(size.x, size.y), 
		Vector2(size.x, 0)])

	p.add_outline(outline)
	
	data.add_obstruction_outline(nv_road.outline)
	for o in get_tree().get_nodes_in_group("nv_geom"):
		data.add_obstruction_outline(o.global_transform * o.vertices)

	NavigationServer2D.bake_from_source_geometry_data(p, data)
