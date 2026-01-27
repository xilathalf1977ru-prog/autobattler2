@tool
extends Node2D

@export var bezier:BezieCurve

func _ready() -> void:
	bezier = BezieCurve.new()
	bezier.setup(global_position,$P.global_position)

func _process(delta: float) -> void:
	bezier.upd($P.global_position)
	queue_redraw()

func _draw() -> void:
	draw_polyline(bezier.get_pts(),Color.WHEAT)
