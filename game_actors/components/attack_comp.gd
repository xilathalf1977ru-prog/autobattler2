extends Node
class_name AttackComp

var base_skill:Skill
var cast_range:float

@export var caster:Caster

func attack(target:Alived) -> void:
	if not (target and target.alive): return
	base_skill.execute(SkillExecutionContext.new(caster,target))

func range_sq() -> float: 
	return cast_range * cast_range
