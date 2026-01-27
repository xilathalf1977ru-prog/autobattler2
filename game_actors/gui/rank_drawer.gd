@tool
extends Node2D
class_name RankDrawer

@export var rank:int:
	set(val):
		rank = val
		queue_redraw()

func upd(val:int) -> void:
	rank = val
	queue_redraw()

func _draw() -> void:
	var c = Color.DARK_OLIVE_GREEN
	var cc = Color.GOLD
	
	var s:int = 8
	var r:int = 5

	if rank < 4:
		var licka_count:int = rank % 4
		## lichka
		var top:Vector2 = Vector2(0,-s * (licka_count - 1 + licka_count%2) * 0.5)
		var left:Vector2 = Vector2(-s,top.y - s)
		var right:Vector2 = Vector2(s,top.y - s)
		for i in licka_count:
			draw_line(left,top,c,r)
			draw_line(top,right,c,r)
			@warning_ignore("integer_division")
			draw_line(left,top,cc,r/2)
			@warning_ignore("integer_division")
			draw_line(top,right,cc,r/2)
			top.y += s
			left.y += s
			right.y += s

	elif rank < 4 * 3 + 4:
		var ss = s * 0.5
		@warning_ignore("integer_division")
		var star_count:int = rank / 4
		var licka_count:int = rank % 4
		
		var offset:float = -(star_count - 1) * s * 0.5
		for i in star_count:
			var pos:Vector2 = Vector2(
				offset + i*s,
				s * (i%2) * (star_count%2)
				)
			##cap
			var romb:PackedVector2Array = [
				Vector2(0,-ss) + pos,
				Vector2(ss,0) + pos,
				Vector2(0,ss) + pos,
				Vector2(-ss,0) + pos,
				Vector2(0,-ss) + pos
			]
			draw_polyline(romb,c,r)
			@warning_ignore("integer_division")
			draw_polyline(romb,cc,r/2)
			
		## lichka
		var top:Vector2 = Vector2(0,-s * (licka_count - 1 + licka_count%2) * 0.5 - s * 2)  
		var left:Vector2 = Vector2(-s,top.y - s)
		var right:Vector2 = Vector2(s,top.y - s)
		for i in licka_count:
			draw_line(left,top,c,r)
			draw_line(top,right,c,r)
			@warning_ignore("integer_division")
			draw_line(left,top,cc,r/2)
			@warning_ignore("integer_division")
			draw_line(top,right,cc,r/2)
			top.y += s
			left.y += s
			right.y += s
	else:
		var rect:Rect2
		rect.position = -Vector2.ONE * s
		rect.size = Vector2.ONE * s * 2
		draw_rect(rect,cc)
		rect.position = -Vector2.ONE * s * 0.5
		rect.size = Vector2.ONE * s
		draw_rect(rect,c)
		
