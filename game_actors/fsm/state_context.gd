extends RefCounted
class_name StateContext

var pawn:Caster
var mng:BattleMng
var fraction:int

var mover:MoveComp
var nv:NavComp

var spells:SpellsHandler

var targeter:Targeter
var attack_comp:AttackComp

var visual:VisualComp

var ally_targeter:Targeter

func attack() -> void:attack_comp.attack(target())

func move(m:Vector2) -> void:mover.move(m)

func target() -> Alived:return targeter.get_target()

func ally() -> Alived:return ally_targeter.get_target()

func sound(s:SoundComp.S) -> void:pawn.sound.exec(s)
