@tool
extends Spawner
class_name UnitSpawner

func _spawn_execute(actor:Alived) -> void:
	actor.hp = VitalProperty.new()
	actor.hp.max_val = data.max_hp
	actor.hp.fill()
	actor.hp.out.connect(actor.die)
	
	actor.sound.sound_data = data.sound_data
	actor.stats = AliveStat.new()
	
	actor.visual.setup()
	actor.meta = data.meta

	#---self-caster---
	actor = actor as Caster
	actor.caster_stats = CasterStat.new()
	var spells_handler:SpellsHandler = actor.get_node("SpellsHandler")
	for spell in data.spells:
		var is_immediatly_rechraged:bool =  data.spells[spell]
		var init_cd:float = 0.0 if is_immediatly_rechraged else spell.cd
		spells_handler.spells[spell] = init_cd
	
	#---targeted-caster---
	var vis:VisionComp = actor.get_node("VisionComp")
	vis.set_range(data.vision)
	
	var targeter:Targeter = actor.get_node("EnemyTargeter")
	var ally_targeter:Targeter = actor.get_node("AllyTargeter")
	
	if targeter:
		targeter.setup(vis)

	if ally_targeter:
		ally_targeter.setup(vis)

	#---Unit---
	actor = actor as Unit
	assert(data.vision > data.attack_range)
	
	actor.rank = RankComp.new()
	actor.rank.limit = data.max_rang
	actor.rank.level_upped.connect(actor.level_up)

	
	var attack:AttackComp = actor.get_node("AttackComp")
	attack.base_skill = data.attack.duplicate_deep(1)
	attack.cast_range = data.attack_range
	
	#---setup_mover---
	var mover:MoveComp
	if data.is_melee_tank:
		mover = ForcerMoveComp.new()
	else:
		mover = MoveComp.new()

	mover.name = "MoveComp"
	actor.add_child(mover)
	mover.unit = actor
	mover.visual = actor.visual
	var nv:NavComp = actor.get_node("NavComp")
	nv.on()
	
	#---setup fsm context---
	var ctx:StateContext = StateContext.new()
	
	ctx.attack_comp = attack
	ctx.mng = mng
	ctx.pawn = actor
	ctx.mover = mover
	ctx.nv = nv
	ctx.spells = spells_handler
	ctx.targeter = targeter
	ctx.fraction = fraction
	ctx.visual = actor.visual
	ctx.ally_targeter = ally_targeter

	#make unique in fsm, for no-spawner instantiation
	actor.fsm.root = data.fsm_root
	actor.fsm.start(ctx)

	#---GUI---
	actor.get_node("GUI").setup()
	
