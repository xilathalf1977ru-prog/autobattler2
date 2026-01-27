@icon("res://editor_assets/skill_icon.svg")
extends Resource
class_name Skill

@export var target_effects:Array[Effect]

func _apply_to_target(c:SkillExecutionContext) -> void:
	for e in target_effects:
		e.execute(c)

func execute(c:SkillExecutionContext) -> void:
	_apply_to_target(c)
