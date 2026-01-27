extends Node
class_name Targeter

@export var unit:Caster
@export var evaluators:Array[TargetEvaluator]

var _target:Alived

var targets:Array[Alived]

signal target_setted
signal target_lost

func setup(vis:VisionComp) -> void:
	if evaluators.is_empty():
		logg("Disabled, missing evaluators")
		return
	
	vis.enemy_enter.connect(on_enemy_enter)
	vis.enemy_exit.connect(on_enemy_exit)

func set_target(t:Alived) -> void:
	if _target:
		_target.died.disconnect(on_target_died)
		
	_target = t
	_target.died.connect(on_target_died)

	assert(is_instance_valid(t))
	assert(not t.is_queued_for_deletion())

	target_setted.emit()
	logg("tareget set")

func get_target() -> Alived: return _target

## can be call from MOVE -> RETREAT when target already is null
func set_null_target() -> void:
	if _target:
		_target.died.disconnect(on_target_died)
	_target = null
	target_lost.emit()

func on_target_died(_S) -> void:
	logg("tareget die")
	match targets.size():
		1:set_null_target()
		_:find_best_target()
	
func on_enemy_exit(u:Alived) -> void:
	targets.erase(u)

	if u == _target:
		find_best_target()

func on_enemy_enter(u:Alived) -> void:
	targets.append(u)
	if _target == null:
		set_target(u)

func find_best_target() -> void:
	var datas:Array[TargetWeight]
	
	for e in targets:
		if not e.alive:continue
		datas.append(TargetWeight.new(e,0))
	
	if datas.is_empty():
		set_null_target()
	else:
		for s in evaluators:
			s.evaluate(datas,TargetEvaluationContext.new(unit))
		
		set_target(_max(datas))

func _min(ds:Array[TargetWeight]) -> Alived:
	var min_val:float = INF
	var obj:Alived
	for d in ds:
		if d.w < min_val:
			min_val = d.w
			obj = d.e
	assert(obj)
	return obj

func _max(ds:Array[TargetWeight]) -> Alived:
	var max_val:float = -INF
	var obj:Alived
	for d:TargetWeight in ds:
		if d.w > max_val:
			max_val = d.w
			obj = d.pawn
	assert(obj)
	return obj

func logg(s:String) -> void:
	unit.fsm.bb.logg(name + ": " + s)
	
