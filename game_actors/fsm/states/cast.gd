extends CommonLock
class_name CombatCast

func exit_update() -> void:
	ctx.spells.execute_targeted_cast(bb.choosen_spell,ctx.targeter.get_target())

func timeout() -> void:
	request_transition.emit(ID.CHASE)
