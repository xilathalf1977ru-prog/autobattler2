@icon("res://editor_assets/leaf.svg")
@abstract
extends State
class_name LeafState
##have VisualComp

@export var visual_data:StateVisualData

func control_flow_enter() -> void:
	assert(visual_data)
	ctx.visual.set_tex(visual_data)
	enter_update()
