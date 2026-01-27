@tool
extends Node2D

@export var root:Root

@export_tool_button("go") var __asg = go
func go() -> void:
	if root:
		print("not empty")
		return
	
	root = Root.new()
	
	root.default_state = State.ID.OFFENSIVE
	
	var move:State = Move.new()
	var attack:State = Attack.new()
	var chase:State = Chase.new()
	var cast:State = CombatCast.new()
	var idle:State = Idle.new()
	var swing:State = Swing.new()
	var dying:State = Dying.new()
	
	var offensive:State = Offensive.new()
	offensive.default_state = State.ID.COMBAT
	var travel:State = Travel.new()
	travel.default_state = State.ID.MOVE
	var retreat:State = Retreat.new()
	retreat.default_state = State.ID.MOVE
	var combat:State = Combat.new()
	combat.default_state = State.ID.CHASE
	
	var s:Array[State] 
	s = [attack,swing,cast,chase]
	combat.__build_states = s
	s = [move,idle]
	travel.__build_states = s
	s = [combat,travel]
	offensive.__build_states = s
	s = [move,idle]
	retreat.__build_states = s
	s =  [offensive,retreat,dying]
	root.__build_states =s
