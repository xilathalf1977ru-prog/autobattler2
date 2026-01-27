extends Effect
class_name BuffEffect

@export var buff:BuffSkill

func execute(c:SkillExecutionContext) -> void:
	c.target.append_buff(buff,c)
