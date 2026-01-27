extends RefCounted
class_name SkillExecutionContext

var caster:Caster
var cast_point:Vector2
var fraction:int
var caster_stats:CasterStat

var target:Alived

signal exp_gained(val:float)

func _init(c:Caster,t:Alived) -> void:
	caster = c
	cast_point = c.get_cast_point()

	if caster is Unit:
		exp_gained.connect(caster.add_exp)
		caster.died.connect(func(x):exp_gained.disconnect(x.add_exp))

	fraction = c.fraction
	caster_stats = c.caster_stats

	target = t

func add_exp(val:float) -> void:
	exp_gained.emit(val)
