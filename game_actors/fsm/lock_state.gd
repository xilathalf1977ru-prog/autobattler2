@abstract
extends LeafState
class_name CommonLock

@export
var lock_time:float = 0.2

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = lock_time
	
	_timer.timeout.connect(timeout)
	_timer.name = nom() + " timer"
	ctx.pawn.add_child(_timer)

func control_flow_enter() -> void:
	_timer.start()
	bb.logg(nom() + " timer started")
	super.control_flow_enter()

func control_flow_exit() -> void:
	_timer.stop()
	bb.logg(nom() + " timer stoped")
	exit_update()

@abstract
func timeout() -> void
