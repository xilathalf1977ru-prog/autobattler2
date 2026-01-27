extends Chase
class_name RangedChase

@export var backstep_factor:float = 0.7

func exec(delta:float) -> void:
	
	var target:Alived = ctx.target()
	ctx.nv.update_moving_target(target)
	
	var vec:Vector2 = target.global_position - ctx.pawn.global_position
	var dist_sq:float = vec.length_squared()
	var attack_rng:float = ctx.attack_comp.range_sq()
	
	if dist_sq > attack_rng:
		ctx.move(speed * ctx.nv.get_next_point_dir())
	elif dist_sq < (attack_rng * backstep_factor):
		ctx.move(speed  * -vec.normalized() )
	else:
		ctx.targeter.find_best_target()
		if is_have_a_good_spell(delta,dist_sq):
			request_transition.emit(ID.COMBAT_CAST)
		else:
			##rotation
			ctx.move(vec.normalized())
			request_transition.emit(ID.SWING)
