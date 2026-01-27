extends Node
class_name SpellsHandler

@export var unit:Caster

var spells:Dictionary[Spell,float]
func execute_cast(spell:Spell,target:Alived) -> void:
	spell.execute(unit,target)
	spells[spell] = spell.cd

func execute_self_cast(spell:Spell) -> void:
	spell.execute(unit,unit)
	spells[spell] = spell.cd

func handle_spells(delta:float) -> Array[Spell]:
	var candidates:Array[Spell]

	for spell in spells:
		if _process_spell(spell,delta):
			candidates.append(spell)
	
	return candidates

func get_spells() -> Array[Spell]:
	var candidates:Array[Spell]

	for spell in spells:
		if spells[spell] == 0.0:
			candidates.append(spell)
	
	return candidates

func _process_spell(s:Spell,delta:float) -> bool:
	spells[s] -= delta
	if spells[s] < 0:
		spells[s] = 0
	
	return spells[s] == 0
	
