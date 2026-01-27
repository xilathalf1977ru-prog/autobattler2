@tool
extends PanelContainer
class_name ClassBoxTool

@export var locked:bool:
	set(val):
		locked = val
		var b = StyleBoxFlat.new()
		if locked:
			b.bg_color = Color("ff0000")
		else:
			b.bg_color = Color("727aa6")
		
		add_theme_stylebox_override("panel",b)

@export var draw_depends:bool = 0:
	set(val):
		draw_depends = val
		queue_redraw()
@export var data:Dictionary
@export var boxes:Dictionary[String,ClassBoxTool]
@export var inherits:Array[ClassBoxTool]

@export var parent:ClassBoxTool:
	set(val):
		if not val:return
		parent = val
		if not parent.item_rect_changed.is_connected(queue_redraw):
			parent.item_rect_changed.connect(queue_redraw)
		queue_redraw()

@export var depends:Array[String]
@export var deps:Array[ClassBoxTool]:
	set(val):
		deps = val
		for d in deps:
			if not d.item_rect_changed.is_connected(queue_redraw):
				d.item_rect_changed.connect(queue_redraw)
			queue_redraw()

@export_tool_button("place_parent") var __aaasdg = place_parent
func place_parent(is_forced:bool = 0) -> void:
	if parent:
		if parent.locked:
			if is_forced:parent.locked = 0
			else:return
		parent.global_position = Vector2(
			global_position.x + (size.x - parent.size.x) * 0.5,
			global_position.y - parent.size.y - 128
			)
		parent.place_parent(is_forced)
		parent.queue_redraw()

@export_tool_button("place_depends") var __aasg = place_depends
func place_depends(is_forced:bool = 0) -> void:
	var x:float = size.x + 32
	var sz = deps.size()
	for d:ClassBoxTool in deps:
		if d.locked:
			if is_forced:d.locked = 0
			else:continue
		d.global_position = Vector2(global_position.x + x + 32,global_position.y)
		x += d.size.x
		d.queue_redraw()

@export_tool_button("place_inherits") var __aasdg = place_inherits
func place_inherits(is_forced:bool = 0) -> void:
	var x:float = size.x
	for d:ClassBoxTool in inherits:
		if d.locked:
			
			if is_forced:
				d.locked = 0
			else:
				continue
		print(x + global_position.x + 32)
		d.global_position = Vector2(
			global_position.x + x + 32,
			global_position.y + size.y + 64
			)
		x += d.size.x + 32

	for d:ClassBoxTool in inherits:
		if d.locked:
			if is_forced:d.locked = 0
			else:continue
		d.global_position.x -= x * 0.5
		d.queue_redraw()

@export_tool_button("place_parent_forced") var __aaasdvvg = func():place_parent(1)
@export_tool_button("place_depends_forced") var __aassg = func():place_depends(1)
@export_tool_button("place_inherits_forced") var __aasdggs = func():place_inherits(1)

func set_nom() -> void:
	$"1/1/1/1/N".clear()
	var nom = (
		"[color=tan]" if data.is_abstract else "[color=cornflower_blue]"
		) + data.nom + "[/color]"
	$"1/1/1/1/N".append_text(nom)
	
	if data.base:
		$"1/1/1/1/N".append_text(" : " + "[color=dodger_blue]" + data.base + "[/color]")

func set_vars(vis:bool) -> void:
	$"1/1/1/1/V".clear()
	if vis:
		var str:String
		for st in data.vars:
			str += st + "\n"
		$"1/1/1/1/V".append_text(str)
	size = Vector2.ZERO
	
func set_funcs(vis:bool) -> void:
	$"1/1/1/1/M".clear()
	if vis:
		var str:String
		for st in data.funcs:
			str += st + "\n"
		$"1/1/1/1/M".append_text(str)
	size = Vector2.ZERO

func set_data(_data:Dictionary,a:bool,f:bool) -> void:
	data = _data
	set_nom()
	set_vars(a)
	set_funcs(f)

func upd_depends() -> void:
	var new_deps:Array[ClassBoxTool]
	for box_name in boxes:
		if data.depends.has(box_name):
			new_deps.append(boxes[box_name])
	deps = new_deps

func _draw() -> void:
	if parent:
		_draw_parent()
	if draw_depends:
		_draw_depends()

func _draw_parent() -> void:
	_draw_arrow(parent.global_position,parent.size,[Color.NAVY_BLUE,Color.AQUA])

func _draw_depends() -> void:
	for d:ClassBoxTool in deps:
		_draw_arrow(d.global_position,d.size,[Color.YELLOW,Color.ORANGE_RED])

func _draw_arrow(p:Vector2,s:Vector2,c:Array[Color]) -> void:
		var mod_s:Vector2
		var mod_t:Vector2
		
		if p.x + s.x < global_position.x:
			mod_s = size * Vector2(0,0.5)
			mod_t = s * Vector2(1,0.5)
		elif global_position.x + size.x < p.x:
			mod_s = size * Vector2(1,0.5)
			mod_t = s * Vector2(0,0.5)
		elif p.y + s.y < global_position.y:
			mod_s = size * Vector2(0.5,0)
			mod_t = s * Vector2(0.5,1)
		elif global_position.y + size.y < p.y:
			mod_s = size * Vector2(0.5,1)
			mod_t = s * Vector2(0.5,0)
		else:
			return

		var arrow_size:float = 32
		var w:float = 3
		var start = mod_s
		var end = (p + mod_t) * get_global_transform()
		var l1 = end + (start - end).normalized().rotated(PI * 0.15) * arrow_size
		var l2 = end + (start - end).normalized().rotated(-PI * 0.15) * arrow_size
		draw_polyline_colors([start,end],c,w)
		draw_line(end,l1,c[1],w + 1)
		draw_line(end,l2,c[1],w + 1)
