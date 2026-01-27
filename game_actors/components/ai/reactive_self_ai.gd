extends Timer
class_name ReactiveSelfAI

@export var caster:Caster
@export var spells:SpellsHandler

func _ready() -> void:
	timeout.connect(upd)
	start()

func upd() -> void:
	var candidates:Array[Spell] = spells.handle_spells(wait_time)
	
	if candidates.is_empty():return
	#---selector---
	var choosen:Spell = candidates.pick_random()

	if choosen:
		spells.execute_cast(choosen,caster)
