extends HFSMNode
class_name Combat

func enter_update() -> void:
	ctx.targeter.target_lost.connect(on_target_lost)
	logg("Target lost connected")
	
func on_target_lost() -> void:
	logg("Target lost")
	request_transition.emit(ID.TRAVEL)

func exit_update() -> void:
	ctx.targeter.target_lost.disconnect(on_target_lost)
	logg("Target lost disconnected")
	
