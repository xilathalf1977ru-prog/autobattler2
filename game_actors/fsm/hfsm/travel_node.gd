extends HFSMNode
class_name Travel

func enter_update() -> void:
	ctx.targeter.target_setted.connect(on_target_setted)
	logg("Target setter connect")

func on_target_setted() -> void:
	logg("Target setted")
	request_transition.emit(State.ID.COMBAT)

func exit_update() -> void:
	ctx.targeter.target_setted.disconnect(on_target_setted)
	logg("Target setter disconnect")
	
