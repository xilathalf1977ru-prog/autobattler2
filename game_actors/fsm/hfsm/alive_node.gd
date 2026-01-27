extends HFSMNode
class_name AliveState

func enter_update() -> void:
	ctx.pawn.died.connect(on_died)
	logg("Died connected")
	
func on_died() -> void:
	request_transition.emit(ID.DYING)

func exit_update() -> void:
	ctx.pawn.died.disconnect(on_died)
	logg("Died disconnected")
	
func exec_update(delta:float) -> void:
	var spells =  ctx.spells.handle_spells(delta)
	
	if spells.is_empty(): return
	
	var max_o:Spell = null
	var max_val:float = -INF
	for s in spells:
		if s.value > max_val:
			max_val = s.value
			max_o = s

	ctx.spells.execute_self_cast(max_o)
