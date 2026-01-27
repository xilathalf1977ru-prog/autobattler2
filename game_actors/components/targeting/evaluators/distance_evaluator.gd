extends TargetEvaluator
class_name DistanceTargetevaluator

func evaluate(targets:Array[TargetWeight],ctx:TargetEvaluationContext) -> void:
	
	var from:Vector2 = ctx.unit.get_cast_point()
	
	for t in targets:
		var to:Vector2 = t.pawn.get_apply_point(ctx.unit)
		
		var dist:float = (from - to).length_squared()
		t.w += dist * 1e-5 * value
