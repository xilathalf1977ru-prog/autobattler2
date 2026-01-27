extends ColorRect

@export var mng:BattleMng = get_parent()

func _ready() -> void:
	mng.world_ready.connect(go)

func go() -> void:
	var tw = create_tween()
	tw.tween_property(self,"color",Color(Color(),0),2.0)
	tw.tween_callback(finish)
	$CPUParticles2D.restart()

func finish() -> void:
	queue_free()
