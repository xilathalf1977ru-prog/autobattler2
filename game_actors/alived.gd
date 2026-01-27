@abstract
extends CharacterBody2D
class_name Alived
##alived, pickable,fractioned

@export var buff_handler:BuffHandler
@export var sound:SoundComp

@export var visual:VisualComp

var hp:VitalProperty
var stats:AliveStat

var fraction:int
var mng:BattleMng

#meta
var meta:PackedStringArray
##is queqed to free
var alive:bool = 1

signal died(who:Alived)

func get_apply_point(v:Node) -> Vector2:
	var sz:Vector2 = visual.get_area()
	var h:int = hash(v)
	var x:float = fposmod(h,sz.x)
	var y:float = fposmod(h + hash(self),sz.y)
	return visual.global_transform * (Vector2(x,y) + visual.sp.offset)

func set_fraction(i:int) -> void:
	fraction = i

func append_buff(buff:BuffSkill,c:SkillExecutionContext) -> void:
	buff_handler.append(buff,c)
	
func apply_buff(buff:BuffSkill,c:SkillExecutionContext) -> void:
	if not buff_handler.buffs.has(buff):
		append_buff(buff,c)

@abstract
func apply_damage(val:float) -> void

@abstract
func on_died() -> void

func die() -> void:
	if alive:
		alive = 0
		collision_layer = 0
		on_died()
		buff_handler.off()
		died.emit(self)
