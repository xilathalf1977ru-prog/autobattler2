extends TargetEvaluator
class_name HPEvaluator

func evaluate(targets:Array[TargetWeight],ctx:TargetEvaluationContext) -> void:
	for t in targets:
		t.w += float(t.pawn.hp.percentage()) * value
