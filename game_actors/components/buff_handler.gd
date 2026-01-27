extends Timer
class_name BuffHandler

class BuffProcessor:
	var buff:BuffSkill
	var c:SkillExecutionContext
	var current_time:float = 0
	var total_time:float = 0
	
	func _init(b:BuffSkill,_c:SkillExecutionContext) -> void:
		buff = b
		c = _c
	
	func execute() -> void:
		buff.execute(c)

@export var unit:Alived

var _timer:Timer

var buffs:Array[BuffProcessor]
var enabled:bool = 1


func _ready() -> void:
	timeout.connect(tick)

func append(buff:BuffSkill,c:SkillExecutionContext) -> void:
	buffs.append(BuffProcessor.new(buff,c))
	if enabled and buffs.size() == 1:
		_timer.start()

##when die
func off() -> void:
	enabled = 0
	stop()

func tick() -> void:
	var q_to_del:Array
	var delta = wait_time

	for buff in buffs:
		buff.current_time += delta
		if buff.current_time > buff.buff.tick:
			buff.execute()
			buff.current_time -= buff.buff.tick
			
			buff.total_time += buff.buff.tick
			if buff.total_time > buff.buff.time:
				q_to_del.append(buff)
				
	for b in q_to_del:
		buffs.erase(b)
	
	if buffs.is_empty():
		_timer.stop()
