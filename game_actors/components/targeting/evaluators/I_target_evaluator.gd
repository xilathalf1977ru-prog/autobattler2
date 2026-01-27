@abstract
extends Resource
class_name TargetEvaluator

@export var value:float = 1.0

@abstract
func evaluate(targets:Array[TargetWeight],ctx:TargetEvaluationContext) -> void
