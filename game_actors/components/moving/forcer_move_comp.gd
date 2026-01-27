extends MoveComp
class_name ForcerMoveComp

func _physics_process(delta: float) -> void:
	if unit.move_and_slide():
		var kc:KinematicCollision2D = unit.get_last_slide_collision()
		var n := kc.get_normal()
		var col = kc.get_collider()
		if col is CharacterBody2D:
			col.velocity = col.velocity.slide(n)
	if is_stopped:
		unit.velocity *= 0.9
