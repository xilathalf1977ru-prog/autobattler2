extends Resource
class_name VitalProperty

@export var max_val:float = 100
@export var low_threshold:float = 0.3

var _val:float

var is_low:bool = 0

signal modified(val:float)
signal low
signal out
signal full

func fill() -> void:
	_val = max_val
	modified.emit(_val)
	full.emit()

func has(amount:float) -> bool:
	return 1 if (_val - amount) > 0 else 0

func percentage() -> float:
	return _val/max_val

func force_increase(amount:float) -> void:
	_val += amount
	
	if percentage() > low_threshold:
		is_low = 0
		
		if _val >= max_val:
			full.emit()
			_val = max_val

	modified.emit(_val)

func force_decrease(amount:float) -> void:
	_val -= amount
	
	if percentage() < low_threshold:
		if not is_low:
			low.emit()

		if _val < 0:
			out.emit()
			_val = 0

	modified.emit(_val)
