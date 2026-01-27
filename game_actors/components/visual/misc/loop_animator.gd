extends Animator
class_name LoopAnimator

func _process(delta: float) -> void:
	_acc += delta
	
	if _acc > spf:
		_acc = 0
		
		if sp.frame + 1 == sp.hframes:
			sp.frame = 0
		else:
			sp.frame += 1
