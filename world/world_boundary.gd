@tool
extends Node2D
class_name WorldBOundary

@export var margin:Vector2 = Vector2(15,15)
@onready var t:StaticBody2D = $Top
@onready var b:StaticBody2D = $Bottom
@onready var l:StaticBody2D = $Left
@onready var r:StaticBody2D = $Right

@onready var bg:Sprite2D = $BG

@export_tool_button("place") var __asdf = place
func place() -> void:
	l.global_position = Vector2(0,0) + Vector2(margin.x,0)
	t.global_position = Vector2(0,0) + Vector2(0,margin.y)
	
	var sz:Vector2 = bg.get_rect().size
	
	r.global_position = sz + Vector2(-margin.x,0)
	b.global_position = sz + Vector2(0,-margin.y)
	queue_redraw()

func _draw() -> void:
	var rect:Rect2
	rect.position = Vector2(l.global_position.x,t.global_position.y)
	rect.end = Vector2(r.global_position.x,b.global_position.y)
	draw_rect(rect,Color.BLACK,0,4)
