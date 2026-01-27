extends SkillScene
class_name OnTargetProjectile

@onready var fx = $Part

func start(c:SkillExecutionContext) -> void:
	if not c.target.alive:
		queue_free()
		return
	
	global_position = c.target.global_position
	
	context = c
	reparent(c.target)

	fx.finished.connect(finish)
	fx.restart()
	target_reached.emit(context)

func finish() -> void:
	queue_free()
