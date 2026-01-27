extends Effect
class_name HealEffect

@export var val:float

func execute(c:SkillExecutionContext) -> void:
	var heal:float = val
	
	heal += c.caster_stats.attack_bonus
	c.add_exp(heal)
	
	var h = c.target.hp._val
	c.target.hp.force_increase(val)
	var hh = c.target.hp._val
	c.target.mng.fx.add_text(
		c.target.global_position,"++ %s -> %s++" % [str(h).pad_decimals(1),str(hh).pad_decimals(1)])
