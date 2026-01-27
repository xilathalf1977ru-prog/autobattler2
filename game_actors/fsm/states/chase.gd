extends LeafState
class_name Chase

##chasing_speed low of move speed(sprint)
@export var speed:float = 150

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = 0.2
	
	_timer.timeout.connect(chasing_handle)
	_timer.name = nom() + " timer"
	ctx.pawn.add_child(_timer)
	

func enter_update() -> void:
	_timer.start()
	ctx.mover.start()
	logg("Mover Start")

func exec(delta:float) -> void:
	ctx.nv.update_moving_target(ctx.target())
	
	ctx.mover.move(speed * ctx.nv.get_next_point_dir())

	var dist_sq:float = (
		ctx.pawn.get_cast_point() - ctx.targeter.get_target().global_position
		).length_squared()
	
	if is_have_a_good_spell(delta,dist_sq):
		request_transition.emit(ID.COMBAT_CAST)
		return

	if (dist_sq < ctx.attack_comp.range_sq()):
			request_transition.emit(ID.SWING)

func exit_update() -> void:
	_timer.stop()
	ctx.mover.stop()
	logg("Mover Stop")

func chasing_handle() -> void:
	ctx.targeter.find_best_target()

func is_have_a_good_spell(delta:float,dist_sq:float) -> bool:
	#candidates
	var candidates:Array[Spell] = ctx.spells.handle_spells(delta)
	
	if candidates.is_empty():return false
	#---selector---
	var choosen:Spell = candidates.pick_random()
	
	if choosen.meta.has("for ally"):return false
	bb.choosen_spell = choosen
	return true
