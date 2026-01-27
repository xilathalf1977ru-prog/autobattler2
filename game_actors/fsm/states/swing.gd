extends CommonLock
class_name Swing

func enter_update() -> void:
	ctx.sound(SoundComp.S.SWING)
	
func timeout() -> void:
	request_transition.emit(ID.ATTACK)
