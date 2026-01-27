extends Node2D
class_name BloodFX

@onready var fx:CPUParticles2D

func start() -> void:
	fx.emitting = 1

func finish() -> void:
	fx.one_shot = 1
	await fx.finished
	queue_free()
