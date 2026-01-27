@tool
extends Node2D
class_name BattleMng

@export var teams:Dictionary[int,Team]
@export var size:Vector2 = Vector2(1920,1080)

@onready var fx:FXMng = $FXMng
@onready var nv:NvMng = $Nv

var is_world_ready:bool = 0
signal world_ready

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _ready() -> void:
	await NavigationServer2D.map_changed
	print("first")
	await NavigationServer2D.map_changed
	print("second")
	is_world_ready = 1
	print("world ready")
	world_ready.emit()
	
func rebake_nv() -> void:
	nv.rebake()

func get_invasion_point(f:int) -> Vector2:
	return teams[f].get_invasion_point()

func get_home_point(f:int) -> Vector2:
	return teams[f].get_home_point()
