@tool
extends Node2D
class_name UmlDrawerTool

const SCAN_ROOT := "res://"

const VARIANT_TYPE_NAME := {
   0: "void",
   1: "bool",
   2: "int",
   3: "float",
   4: "String",
   5: "Vector2",
   6: "Vector2i",
   7: "Rect2",
   8: "Rect2i",
   9: "Vector3",
   10: "Vector3i",
   11: "Transform2D",
   12: "Vector4",
   13: "Vector4i",
   14: "Plane",
   15: "Quaternion",
   16: "AABB",
   17: "Basis",
   18: "Transform3D",
   19: "Projection",
   20: "Color",
   21: "String",
   22: "NodePath",
   23: "RID",
   24: "Object",
   25: "Callable",
   26: "Signal",
   27: "Dictionary",
   28: "Array",
   29: "PackedByteArray",
   30: "PackedInt32Array",
   31: "PackedInt64Array",
   32: "PackedFloat32Array",
   33: "PackedFloat64Array",
   34: "PackedStringArray",
   35: "PackedVector2Array",
   36: "PackedVector3Array",
   37: "PackedColorArray",
   38: "PackedVector4Array",
   39: "Max"
}

@export var find:String:
	set(val):
		find = val
		queue_redraw()

@export var print_vars:bool = 1:
	set(val):
		print_vars = val
		for b:ClassBoxTool in boxes.values():
			b.set_vars(val)
			
@export var print_funcs:bool = 1:
	set(val):
		print_funcs = val
		for b:ClassBoxTool in boxes.values():
			b.set_funcs(val)

@export var box_scene:PackedScene

@export var classes:Dictionary[String,Dictionary]
@export var boxes:Dictionary[String,ClassBoxTool]

func _ready() -> void:
	go()

@export_tool_button("clear") var __gas = clear
func clear() -> void:
	for box in boxes.values():
		box.queue_free()
	
	classes.clear()
	boxes.clear()

@export_tool_button("go") var __asd = go
func go():
	collect_classes()
	await build_boxes()
	
	for ch:ClassBoxTool in boxes.values():
		ch.upd_depends()

@export_tool_button("place") var __asg = place
func place() -> void:
	var x_line:float = 3000
	var x:float = 0
	var y:float = 0
	var level:Array[float] = [0]
	var tmp_boxes:Array[ClassBoxTool] = boxes.values().filter(func(x):return !x.locked)
	
	tmp_boxes.sort_custom(func(a,b):return a.size.y > b.size.y)

	for i in tmp_boxes.size():
		var box:ClassBoxTool = tmp_boxes[i]
		box.global_position = Vector2(x,y)
		
		level.append(box.size.y)
		x += box.size.x

		if x > x_line:
			x = 0
			y += level.max()
			level = [0]

func collect_classes() -> void:
	var files:Array[String]
	_scan_dir(SCAN_ROOT, files)
	
	var script_files:Array[String]
	
	for file:String in files:
		if not file.ends_with(".gd"):continue
		var script:Script = load(file)
		var class_nom:String = script.get_global_name()
		if class_nom == "":continue
		script_files.append(file)

	for file:String in script_files:
		var script:Script = load(file)
		var class_nom:String = script.get_global_name()

		var base_name:String
		var base:Script = script.get_base_script()
		if base:
			base_name = base.get_global_name()
		
		var vars:Array[String] = get_properties(script.get_script_property_list())

		var funcs := []
		for m:Dictionary in script.get_script_method_list():
			if m.flags & METHOD_FLAG_VIRTUAL or m.name.begins_with("__"):
				continue

			var args:Array[String] = get_properties(m.args,0)
			var ret:String = bbcoded_type(get_property_type(m.return))
			var sig:String = ret + " " + m.name + "(" + ", ".join(args) + ")"
			##not overloaded
			if not funcs.has(sig):funcs.append(sig)
		
		classes[class_nom] = {
		"nom":class_nom,
		"is_abstract":script.is_abstract(),
		"base": base_name,
		"vars": vars,
		"funcs": funcs,
		}
	
	for file:String in script_files:
		var script:Script = load(file)
		var class_nom:String = script.get_global_name()
		var class_data:Dictionary = classes[class_nom]
		var deps:Array[String] = []

		for p:Dictionary in script.get_script_property_list():
			if p.name.begins_with("__"): continue
			if not (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE): continue

			# базовый тип
			var base_type := get_property_type(p)
			if classes.has(base_type) and not deps.has(base_type):
				if class_data.base != base_type:
					deps.append(base_type)

			# Array[T]
			if p.type == TYPE_ARRAY and p.hint == PROPERTY_HINT_TYPE_STRING:
				var parts:PackedStringArray= p.hint_string.split(":")
				if parts.size() > 1:
					var inner := parts[1]
					if classes.has(inner) and not deps.has(inner):
						if class_data.base != inner:
							deps.append(inner)

			# Dictionary[K;V]
			if p.type == TYPE_DICTIONARY and p.hint == PROPERTY_HINT_TYPE_STRING:
				var kv:PackedStringArray = p.hint_string.split(";", false, 2)
				if kv.size() == 2:
					for part in kv:
						var sub := part.split(":")
						if sub.size() > 1:
							var t := sub[1]
							if classes.has(t) and not deps.has(t):
								if class_data.base != t:
									deps.append(t)

		classes[class_nom]["depends"] = deps


func get_properties(data:Array[Dictionary], need_name:bool = true) -> Array[String]:
	var res:Array[String] = []
	for p:Dictionary in data:
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE):continue
		if p.name == "buildings":
			pass
		var type := parse_property_type(p)
		
		if need_name:res.append("%s : %s" % [p.name, type])
		else:res.append(type)
	return res


func parse_property_type(p:Dictionary) -> String:
	var base := bbcoded_type(get_property_type(p))
	
	var inner:String
	if p.type == TYPE_ARRAY:
		#exported arrays, may be nested
		if p.hint == PROPERTY_HINT_TYPE_STRING:
			inner = parse_array_hint(p.hint_string)
			return "%s[%s]" % [base, inner]
		
		#non export arrays
		if p.hint == PROPERTY_HINT_ARRAY_TYPE:
			return "%s[%s]" % [base, p.hint_string]

	if p.type == TYPE_DICTIONARY and p.hint == PROPERTY_HINT_TYPE_STRING:
		inner = parse_dictionary_hint(p.hint_string)
		return "%s[%s]" % [base, inner]

	return base



func parse_dictionary_hint(hint_string:String) -> String:
	var kv:PackedStringArray = hint_string.split(";", false, 2)
	return "%s : %s" % [
			parse_array_hint(kv[0]),
			parse_array_hint(kv[1])
		]
func parse_array_hint(hint:String) -> String:
	var parts:PackedStringArray = hint.split(":")
	
	if parts.size() > 2:
		return "Enum Hint"
	
	var first:String = parts[0]
	if "24" in first:
		var _hint = first.split("/")[1]
		##resourse
		if _hint == "17":
			return "[color=ORANGE]%s[/color]" % parts[1]
			
		##node link
		if _hint == "34":
			return "[color=ROYAL_BLUE]%s[/color]" % parts[1]
		
		
		if _hint == "31":
			return bbcoded_type(parts[1])
			
	else:
		return VARIANT_TYPE_NAME[int(first)]
	return "sos"


func resolve_type(t:int) -> String:
	# builtin
	if VARIANT_TYPE_NAME.has(t):
		return bbcoded_type(VARIANT_TYPE_NAME[t])
	
	# кастомный класс
	for c in classes.keys():
		if classes[c].get("type_id", -1) == t:
			return bbcoded_type(c)
	
	return bbcoded_type("Variant")


func get_property_type(p:Dictionary) -> String:
	var property_type:String = p.class_name
	if property_type == "":
		property_type = VARIANT_TYPE_NAME[p.type]
	return property_type

func bbcoded_type(t:String) -> String:
	return "[color=spring_green]" + t + "[/color]"
	
func _scan_dir(path: String, out: Array) -> void:
	var dir := DirAccess.open(path)

	for file_name: String in dir.get_files():
		out.append(path.path_join(file_name))

	for dir_name: String in dir.get_directories():
		_scan_dir(path.path_join(dir_name), out)
	
class Tr:
	var base:String = ""
	var nom:String = "FORGET"
	var children:Array[Tr]
	var deep:int = 0

	func _to_string() -> String:
		return "\n" + "_".repeat(deep) + nom + (str(children) if not children.is_empty() else "")

func build_boxes() -> void:
	for tree:Tr in build_trees():
		_build_tree_recursive(tree,null)

func build_trees() -> Array[Tr]:
	var nodes:Dictionary[String,Tr]
	
	for derived_nom: String in classes.keys():
		var base_nom: String = classes[derived_nom].base
		
		var new_node = Tr.new()
		new_node.base = base_nom
		new_node.nom = derived_nom
		new_node.deep = 0
		
		if nodes.has(derived_nom):
			continue

		if nodes.has(base_nom):
			new_node.deep = nodes[base_nom].deep + 1
			nodes[base_nom].children.append(new_node)

		elif base_nom != "":
			var new_base_node = Tr.new()
			new_base_node.nom = base_nom
			new_base_node.children.append(new_node)
			new_node.deep = 1
			nodes[base_nom] = new_base_node
			
		nodes[derived_nom] = new_node
	
	for node:Tr in nodes.values():
		if node.base != "":
			nodes.erase(node.nom)
	return nodes.values()

func _build_tree_recursive(node:Tr,parent_box:ClassBoxTool) -> void:
	var box:ClassBoxTool = add_class_box(node)
	
	if parent_box:
		box.parent = parent_box
		if not parent_box.inherits.has(box):
			parent_box.inherits.append(box)

	for child:Tr in node.children:
		_build_tree_recursive(child,box,)

func add_class_box(tr:Tr) -> ClassBoxTool:
	var box:ClassBoxTool = boxes.get(tr.nom)
	if not box:
		box = box_scene.instantiate()
		add_child(box)
		box.name = tr.nom
		boxes[tr.nom] = box
		box.owner = self
		box.boxes = boxes
	box.set_data(classes[tr.nom],print_vars,print_funcs)
	return box

func _draw() -> void:
	var p:ClassBoxTool = boxes.get(find)
	if p:
		draw_line(Vector2.ZERO,p.global_position,Color.WHITE,16)
