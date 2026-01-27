extends Node
class_name MoveComp

@export var visual: UnitVisual
@export var unit: Alived

var is_stopped:bool = 1
func move(_mov: Vector2) -> void:
	unit.velocity = _mov
	visual.calc_dir(_mov)

func start() -> void:
	is_stopped = 0
func stop() -> void:
	unit.velocity *= 0
	is_stopped = 1

func _physics_process(delta: float) -> void:
	unit.move_and_slide()
	if is_stopped:
		unit.velocity *= 0.9
