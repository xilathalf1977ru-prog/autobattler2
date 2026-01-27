extends HFSMNode
class_name Retreat

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = 6.0
	
	_timer.timeout.connect(timeout)
	_timer.name = nom() + " timer"
	ctx.pawn.add_child(_timer)

func enter_update() -> void:
	ctx.pawn.hp.full.connect(on_hp_full)

	bb.current_target_position = ctx.pawn.mng.get_home_point(ctx.fraction)
	logg("Set target point to home")
	_timer.start()
	logg("Retreat timer start")

func on_hp_full() -> void:
	logg("Full hp")
	request_transition.emit(ID.OFFENSIVE)

func exit_update() -> void:
	ctx.pawn.hp.full.disconnect(on_hp_full)
	_timer.stop()
	
func timeout() -> void:
	logg("Retreat timer timeout")
	request_transition.emit(ID.OFFENSIVE)
	
