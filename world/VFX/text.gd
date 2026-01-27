extends Node2D
class_name TextFX

@onready var label:Label = $Label

func start(t:String) -> void:
	label.text = t
	label.size *= 0
	label.pivot_offset = label.size * 0.5
	label.rotation = PI * 0.05 * randf()
	label.position *= 0
	label.scale *= 0
	
	var x:float = label.position.x + randi_range(-24,24)
	var y:float = label.position.y - randi_range(120,180)
	
	
	var tw = create_tween()
	tw.tween_property(label,"scale",Vector2.ONE,0.5)
	tw.parallel().tween_property(label,"position",Vector2(x,y),1.2)
	tw.tween_callback(finish)

func finish() -> void:
	var tw = create_tween()
	tw.tween_property(label,"modulate",Color.TRANSPARENT,0.5)
	tw.tween_callback(queue_free)
