@tool
extends Spawner
class_name SelfCasterSpawner

func _spawn_execute(actor:Alived) -> void:
	actor.hp = VitalProperty.new()
	actor.hp.max_val = data.max_hp
	actor.hp.fill()
	actor.hp.out.connect(actor.die)
	
	actor.sound.sound_data = data.sound_data
	actor.stats = AliveStat.new()
	
	actor.meta = data.meta

	#---self-caster---
	actor = actor as Caster
	actor.caster_stats = CasterStat.new()
	var spells_handler:SpellsHandler = actor.get_node("SpellsHandler")
	for spell in data.spells:
		var is_immediatly_rechraged:bool =  data.spells[spell]
		var init_cd:float = 0.0 if is_immediatly_rechraged else spell.cd
		spells_handler.spells[spell] = init_cd
	
	#---static visual---
	actor.visual.set_tex(data.texture)
	#---GUI---
	actor.get_node("GUI").setup()
