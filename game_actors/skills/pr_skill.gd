extends Skill
class_name ProjectileSkill

@export var skill_scene:PackedScene

func execute(c:SkillExecutionContext) -> void:
	var inst:SkillScene = skill_scene.instantiate()
	c.caster.add_sibling(inst)
	inst.target_reached.connect(_apply_to_target)
	inst.start(c)
