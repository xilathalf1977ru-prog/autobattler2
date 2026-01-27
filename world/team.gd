extends Node2D
class_name Team

@export var fraction:int
@export var current_enemy:Team

var units:Array[Alived]
var buildings:Array[Alived]

var home:Vector2
var home_radius:float

signal team_changed

func register_unit(x:Alived) -> void:
	units.append(x)
	x.died.connect(on_unit_die)
	team_changed.emit()
	
func register_building(x:Alived) -> void:
	buildings.append(x)
	x.died.connect(on_building_died)
	recalc_home_point()
	team_changed.emit()

func on_unit_die(x:Alived) -> void:
	units.erase(x)
	team_changed.emit()

func on_building_died(x:Alived) -> void:
	buildings.erase(x)
	team_changed.emit()
	if not  buildings.is_empty():
		recalc_home_point()

func recalc_home_point() -> void:
	var acc:Vector2 = Vector2.ZERO
	for build in buildings:
		acc += build.global_position
	
	home =  acc / buildings.size()
	
	var _acc:float
	for build in buildings:
		_acc += build.global_position.distance_to(home)
	
	home_radius = _acc / buildings.size() * 0.75
	queue_redraw()

func get_invasion_point() -> Vector2:
	return (current_enemy.home + 
	current_enemy.home_radius * Vector2.UP.rotated(TAU * randf()) * randf())

func get_home_point() -> Vector2:
	return home + home_radius * Vector2.UP.rotated(TAU * randf()) * randf()

func _draw() -> void:
	draw_circle(
		to_local(home),
		home_radius,
		Color(Spawner.frac_colors[fraction],0.2)
		)
