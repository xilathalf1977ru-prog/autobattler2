extends CommonLock
class_name Dying

func enter_update() -> void:
	ctx.sound(SoundComp.S.DIE)

func timeout() -> void:
	ctx.pawn.queue_free()
