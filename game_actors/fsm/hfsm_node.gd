@abstract
extends State
class_name HFSMNode

@export var default_state:ID

@export var __build_states:Array[State]

var states:Dictionary[ID,State]
var _state:State

func fsm_init(c:StateContext,_bb:BlackBoard,parent:State) -> void:
	super.fsm_init(c,_bb,parent)
	
	for st in __build_states:
		states[dict[st.nom()]] = st
		st.fsm_init(c,_bb,self)
		st.request_transition.connect(transition_to)

	__build_states.clear()

func control_flow_enter() -> void:
	enter_update()
	_state = states[default_state]
	_state.control_flow_enter()

func transition_to(new_state_id:int) -> void:
	var new_state:State = states[new_state_id]
	
	_state.control_flow_exit()
	
	bb.logg(
		"%s -> %s" % [_state.get_state_path(),new_state.get_state_path()])

	assert (_state != new_state)

	_state = new_state
	_state.control_flow_enter()
	
func exec(delta:float) -> void:
	_state.exec(delta)
	exec_update(delta)

func exec_update(delta:float) -> void:
	pass

func control_flow_exit() -> void:
	_state.control_flow_exit()
	exit_update()
