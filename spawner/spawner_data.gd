extends Resource
class_name UnitSpawnerData

#---util----
@export var nom:String = "UNIT TYPE NOM"
@export var spawner_texture:Texture2D

#---alived----
@export var is_building:bool = 0
@export var max_hp:float = 50
@export var sound_data:Dictionary[SoundComp.S,SoundData]
@export var is_melee_tank:bool = 0
@export var meta:PackedStringArray

#---self-caster----
@export var spells:Dictionary[Spell,bool]

#---static----
@export var texture:StateVisualData

#---combat-caster---
@export var vision:float

#---unit---
@export var fsm_root:Root
@export var attack:Skill
@export var attack_range:float

@export var max_rang:int
