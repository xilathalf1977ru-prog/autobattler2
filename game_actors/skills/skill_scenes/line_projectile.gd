extends SkillScene
class_name LineProjectile

@export var speed:float = 500

var target_point:Vector2
var _timer:Timer

func _ready() -> void:
	set_process(0)
	_timer = Timer.new()
	_timer.timeout.connect(timeout)
	add_child(_timer)

func start(c:SkillExecutionContext) -> void:
	if not c.target.alive:
		queue_free()
		return
	c.target.died.connect(on_target_died,CONNECT_ONE_SHOT)
	
	global_position = c.cast_point
	target_point = c.target.get_apply_point(self)
	_timer.wait_time = target_point.distance_to(global_position)/speed
	
	
	rotation = (c.target.get_apply_point(self) - c.caster.get_cast_point()).angle()
	
	context = c
	queue_redraw()
	_timer.start()

func timeout() -> void:
	finish()

func on_target_died(_f:Alived) -> void:
	queue_free()

func finish() -> void:
	target_reached.emit(context)
	queue_free()

func _draw() -> void:
	draw_line(Vector2.ZERO,target_point * global_transform,Color.WHEAT)
