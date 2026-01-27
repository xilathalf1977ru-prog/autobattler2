extends CommonLock
class_name Attack

func enter_update() -> void:
	ctx.attack()
	ctx.sound(SoundComp.S.ATTACK)

func timeout() -> void:
	request_transition.emit(ID.CHASE)
