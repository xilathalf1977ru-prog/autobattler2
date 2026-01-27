extends ActorGUI
class_name BuildGUI

@export var build:Caster
@export var hp_bar:PropertyBar
@export var spells:SpellsHandler
	
func setup() -> void:
	build.mouse_entered.connect(on)
	build.mouse_exited.connect(off)
	hp_bar.setup(build.hp)

func on() -> void:
	visible = 1 
	queue_redraw()

func off() -> void:
	visible = 0

func _draw() -> void:
	if not visible: return

	var color = Spawner.frac_colors[build.fraction]

	for s in spells.spells.keys():
		var r = s.cast_range
		draw_circle(Vector2.ZERO,r,color,0,1)
	
		for i in 36:
			var angle:float = float(i)/36 * TAU + spells.spells.keys().find(s)
			var base = Vector2.UP .rotated(angle)
			var start = Vector2.ZERO
			var end = base * r
			draw_line(start,end,color)

	var cp = to_local(build.get_cast_point())
	var offset:float = 10
	var n = cp + Vector2.UP * offset
	var s = cp + Vector2.DOWN * offset
	var w = cp + Vector2.LEFT * offset
	var e = cp + Vector2.RIGHT * offset
	draw_line(n,s,Color.WHEAT)
	draw_line(w,e,Color.WHEAT)
