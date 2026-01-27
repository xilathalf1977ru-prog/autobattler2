extends VisualComp
class_name UnitVisual
##Rotation and animation

enum AnimaType
{
	LOOP,
	ONE_SHOT
}

var animators:Dictionary[AnimaType,Animator]
var cur_animator:Animator

func _ready() -> void:
	var l: = LoopAnimator.new(sp)
	var on := OneShotAnimator.new(sp)
	add_child(l)
	add_child(on)
	animators[AnimaType.LOOP] = l
	animators[AnimaType.ONE_SHOT] = on
	cur_animator = l
	
## L B R T
func calc_dir(vel:Vector2) -> void:
	var angle := (vel * Vector2(1,-1)).angle()
	#PI - base turn
	#tau - full + sign
	angle = fmod(angle + PI + TAU, TAU)
	
	#TAU / sectors % sectors
	var dir = roundi(angle / (PI * 0.5)) % 4
	match dir:
		0:
			sp.flip_h = 1
			cast_point.position.x = abs(cast_point.position.x) * -1
		1:
			pass
		2: 
			cast_point.position.x = abs(cast_point.position.x)
			sp.flip_h = 0
		3:
			pass

func set_tex(d:StateVisualData) -> void:
	cur_animator.stop()
	
	if animators[d.anima] != cur_animator:
		cur_animator = animators[d.anima]
	
	sp.texture = d.texture

	sp.offset = Vector2(
		-sp.texture.get_width()/(2.0 * d.frames),
		-sp.texture.get_height())
	
	sp.hframes = d.frames
	sp.frame_coords.x = 0
	if sp.hframes > 1:
		cur_animator.start()

func get_area() -> Vector2:
	return sp.texture.get_size() / Vector2(sp.hframes,sp.vframes)
