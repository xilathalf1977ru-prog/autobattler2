@icon("res://editor_assets/spell_icon.svg")
extends Resource
class_name Spell
##personal instance for caster

@export var nom:String = "FORGET SPELL NOM"
@export var sound:SoundData

@export var cd:float = 1.0
@export var cast_range:float

@export var _skill:Skill

@export var meta:PackedStringArray

func execute(c:Alived,t:Alived) -> void:
	if sound: c.sound.play_manual(sound)
	
	_skill.execute(SkillExecutionContext.new(c,t))
	
func range_sq() -> float: 
	return cast_range * cast_range
