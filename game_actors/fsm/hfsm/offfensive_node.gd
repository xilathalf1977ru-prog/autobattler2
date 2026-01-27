extends HFSMNode
class_name Offensive

func enter_update() -> void:
	ctx.pawn.hp.low.connect(on_low_hp)
	
	bb.current_target_position = ctx.mng.get_invasion_point(ctx.fraction)
	logg("Set target_point to invasion")

func on_low_hp() -> void:
	logg("Low HP")
	request_transition.emit(ID.RETREAT)

func exit_update() -> void:
	ctx.pawn.hp.low.disconnect(on_low_hp)
	
func exec_update(delta:float) -> void:
	handle_ally_cast(delta)
	
func handle_ally_cast(delta:float) -> void:
	if not ctx.ally():return
	#candidates
	var candidates:Array[Spell] = ctx.spells.get_spells()
	
	if candidates.is_empty():return
	#---selector---
	candidates = select(candidates,"for ally")

	var choosen:Spell = candidates.pick_random()
	ctx.spells.execute_cast(choosen,ctx.ally())

func select(candidates:Array[Spell],meta:String) -> Array[Spell]:
	var res:Array[Spell]
	for c in candidates:
		if c.meta.has(meta):
			res.append(c)
	return res
			
