@abstract
extends Resource
class_name State

enum ID
{
#leaf
	IDLE,
	MOVE,
	CHASE,
	ATTACK,
	SWING,
	COMBAT_CAST,
#node
	OFFENSIVE,
	COMBAT,
	RETREAT,
	TRAVEL,
	DYING,
#global
	ROOT
}

static var dict = {
	(Idle as Script).get_global_name() : ID.IDLE,
	(Move as Script).get_global_name() : ID.MOVE,
	(Chase as Script).get_global_name() : ID.CHASE,
	(RangedChase as Script).get_global_name() : ID.CHASE,
	
	(Attack as Script).get_global_name() : ID.ATTACK,
	(Swing as Script).get_global_name() : ID.SWING,
	(CombatCast as Script).get_global_name() : ID.COMBAT_CAST,
	
	(Offensive as Script).get_global_name() : ID.OFFENSIVE,
	(Combat as Script).get_global_name() : ID.COMBAT,
	(Retreat as Script).get_global_name() : ID.RETREAT,
	(Travel as Script).get_global_name() : ID.TRAVEL,
	(Dying as Script).get_global_name() : ID.DYING
}

var ctx:StateContext
var bb:BlackBoard

var _parent:State
@warning_ignore("unused_signal")
signal request_transition(new_state:int)

func fsm_init(c:StateContext,_bb:BlackBoard,parent:State) -> void:
	ctx = c
	bb = _bb
	_parent = parent
	init()

func init() -> void:pass

func control_flow_enter() -> void:enter_update()
func enter_update() -> void: pass

func control_flow_exit() -> void:exit_update()
func exit_update() -> void:pass

func exec(delta:float) -> void: pass

func nom() -> String:
	return get_script().get_global_name()

func get_state_path() -> String:
	var res:String = nom()
	var cur:State = _parent
	while cur != null:
		res = "%s:%s" % [cur.nom(), res]
		cur = cur._parent
	return res 

func logg(s:String) -> void:
	bb.logg(get_state_path() + ":: " + s)
