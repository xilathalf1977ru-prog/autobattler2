@abstract
extends Node2D
class_name SkillScene

var context:SkillExecutionContext

@warning_ignore("unused_signal")
signal target_reached(c:SkillExecutionContext)

@abstract
func start(c:SkillExecutionContext) -> void

@abstract
func finish() -> void
