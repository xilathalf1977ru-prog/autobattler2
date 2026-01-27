extends TargetEvaluator
class_name MetaEvaluator

@export var meta:String
func evaluate(targets:Array[TargetWeight],ctx:TargetEvaluationContext) -> void:
	for target in targets:
		target.w += float(target.pawn.meta.has(meta)) * value
