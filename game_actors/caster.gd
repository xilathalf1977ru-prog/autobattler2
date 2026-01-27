extends Alived
class_name Caster
##only no target spells

@export var cast_point:Node2D

var caster_stats:CasterStat

func get_cast_point() -> Vector2:
	return cast_point.global_position

func apply_damage(val:float) -> void:
	hp.force_decrease(val)
	#sound.exec(SoundComp.S.HURT)

func on_died() -> void:
	queue_free()
