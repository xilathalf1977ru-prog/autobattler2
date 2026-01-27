extends Area2D
class_name VisionComp

signal ally_enter(who:Alived)
signal ally_exit(who:Alived)
signal enemy_enter(who:Alived)
signal enemy_exit(who:Alived)

@onready var unit:Alived = get_parent()

func _ready() -> void:
	body_entered.connect(enter)
	body_exited.connect(exit)

func set_range(val:float) -> void:
	var shape = CircleShape2D.new()
	shape.radius = val
	get_child(0).shape = shape
	
func get_range() -> float:
	return get_child(0).shape.radius

func enter(u:Alived) -> void:
	if u.fraction != unit.fraction:
		enemy_enter.emit(u)
	else:
		if u != unit:
			ally_enter.emit(u)

func exit(u:Alived) -> void:
	if u.fraction != unit.fraction:
		enemy_exit.emit(u)
	else:
		if u != unit:
			ally_exit.emit(u)
