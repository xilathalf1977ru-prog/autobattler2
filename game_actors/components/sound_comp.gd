extends AudioStreamPlayer2D
class_name SoundComp

enum S{
	ATTACK,
	HURT,
	SWING,
	DIE
}

@export var max_acc:int = 5

var sound_data:Dictionary[S,SoundData]

var _acc:int = 0
func exec(i:int) -> void:
	play_manual(sound_data[i])

func play_manual(d:SoundData) -> void:
	_acc += 1
	if not d.is_forced:
		if _acc == max_acc:
			_acc = 0
			return
			
		if playing:
			return
	else:
		_acc = 0
	
	###----
	if d.sounds.is_empty():
		return
	###----
	pitch_scale = randfn(1,0.05)
	stream = d.sounds.pick_random()
	play()
	
