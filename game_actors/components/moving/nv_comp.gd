extends Timer
class_name NavComp

#one for all pawns
var reached_threshold:float = 25

@export var unit:Alived
var _target:Vector2

var _params:NavigationPathQueryParameters2D = NavigationPathQueryParameters2D.new()
var _res: NavigationPathQueryResult2D = NavigationPathQueryResult2D.new()

signal target_reached
signal new_path

func _ready() -> void:
	_params.map = NavigationServer2D.get_maps().front()
	timeout.connect(_upd)

func set_target_manual(v:Vector2) -> void:
	_target = v
	_upd()

func update_moving_target(u:Node2D) -> void:
	_target = u.global_position
	
func set_target(u:Unit) -> void:
	_target = u.global_position
	_upd()

var is_calc:bool = 0
func _upd() -> void:
	is_calc = 0
	_params.start_position = unit.global_position
	_params.target_position = _target
	NavigationServer2D.query_path(
		_params,
		_res,
		_path_calculated
	)

func _path_calculated() -> void:
	is_calc = 1
	new_path.emit()

##path size always >= 2 [pos,...,dest]
func get_next_point() -> Vector2:
	#rework to NV.map_get_path
	var next = _res.path[1]
	if _res.path.size() == 2:
		if (
			(unit.global_position - next).length_squared() < reached_threshold * reached_threshold
			):
				target_reached.emit()
	else:
		if (
			(unit.global_position - next).length_squared() < reached_threshold * reached_threshold
			):
			var tmp = _res.path.duplicate()
			tmp.remove_at(1)
			_res.path = tmp
			return _res.path[1]
	return next

func get_next_point_dir() -> Vector2:
	return (get_next_point() - unit.global_position).normalized()

func off() -> void:
	stop()

func on() -> void:
	_upd()
	start()

func is_active() -> bool:return !is_stopped()
