@tool
extends Node2D

@export var root: HFSMNode

@export var transitions: Dictionary[String,PackedStringArray]

const NODE_SIZE := Vector2(256, 38+38 + 10 + 10)
const H_SPACING := 40
const V_SPACING := 10

@export var positions:Dictionary[String,Rect2] # State -> Rect2
@export var scripts:Dictionary[String,State]

func _ready() -> void:
	go()

@export_tool_button("go") var _asdf = go
func go():
	positions.clear()
	transitions.clear()
	scripts.clear()
	_collect_transitions(root,"")
	_layout(root, 0, 0,"")
	queue_redraw()
	
func _collect_transitions(state: State,prefix:String) -> void:
	transitions[nom(state)] = _parse_request_transitions(state)

	if state is HFSMNode:
		for child in state.__build_states:
			_collect_transitions(child,nom(state))

func _layout(state: State, depth: int, y: int,prefix) -> int:
	var x := depth * (NODE_SIZE.x + H_SPACING)
	var rect := Rect2(Vector2(x, y), NODE_SIZE)
	var full_name = prefix + nom(state)
	positions[full_name] = rect
	scripts[full_name] = state
	if state is HFSMNode:
		var child_y := y
		var first_child_y := y
		var last_child_y := y

		for child in state.__build_states:
			child_y = _layout(child, depth + 1, child_y, full_name)
			last_child_y = child_y - V_SPACING - NODE_SIZE.y

		var center_y := (first_child_y + last_child_y) * 0.5
		positions[full_name].position.y = center_y

		return child_y
	else:
		return y + NODE_SIZE.y + V_SPACING


func _draw():
	for state:String in positions.keys():
		var rect := positions[state]
		var script = scripts[state]

		draw_rect(rect, Color(0.15, 0.15, 0.15), true)
		draw_rect(rect, Color.WHITE, false, 2)
		

		draw_string(
		ThemeDB.fallback_font,
		rect.position + Vector2(10, 38),
		nom(scripts[state]),
		HORIZONTAL_ALIGNMENT_LEFT,
		NODE_SIZE.x - 20,
		16
		)
		
		var str:String = " -> ["
			
		for tr in transitions[nom(script)]:
			str += tr + " "
		str += "]"
	
		draw_string(
		ThemeDB.fallback_font,
		rect.position + Vector2(10, 38+38),
		str,
		HORIZONTAL_ALIGNMENT_LEFT,
		NODE_SIZE.x - 20,
		16
		)
		
		if script and script is LeafState:
			var pos = Vector2(rect.position.x + rect.size.x, rect.position.y)
			if script.visual_data:
				draw_texture(script.visual_data.texture,pos)

	for state in positions.keys():
		var script = scripts[state]
		if script is HFSMNode:
			var from_rect := positions[state]
			for child in script.__build_states:
				var to_rect := positions[state + nom(child)]
				draw_line(
				from_rect.position + Vector2(from_rect.size.x, from_rect.size.y / 2),
				to_rect.position + Vector2(0, to_rect.size.y / 2),
				Color.WHITE,
				2
				)

func _parse_request_transitions(state: State) -> PackedStringArray:
	var res:PackedStringArray
	
	var script:Script = state.get_script()
	var source:String = script.source_code

	var regex := RegEx.new()
	regex.compile(
		"request_transition\\.emit\\s*\\(\\s*ID\\.([A-Z_]+)\\s*\\)"
	)


	for result in regex.search_all(source):
		var id_name := result.get_string(1)
		if not res.has(id_name):
			res.append(id_name)
	return res

func nom(s:State) -> String:return s.get_script().get_global_name()
