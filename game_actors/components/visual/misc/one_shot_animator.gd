extends Animator
class_name OneShotAnimator

func _process(delta: float) -> void:
	_acc += delta
	if _acc > spf:
		if sp.frame == sp.hframes - 1:
			stop()
