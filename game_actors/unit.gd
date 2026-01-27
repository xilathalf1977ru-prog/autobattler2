extends Caster
class_name Unit

var rank:RankComp
@export var fsm:FSM
@export var blood_fx:UnitBlood

func set_fraction(i:int) -> void:
	fraction = i
	##get fraction color and draw

func apply_damage(val:float) -> void:
	hp.force_decrease(val)
	blood_fx.set_blood(hp.percentage())

	rank.add_exp(val * 0.5)
	sound.exec(SoundComp.S.HURT)

func add_exp(val:float) -> void:
	rank.add_exp(val)

func on_died() -> void:
	#
	fsm.root.bb.logg("DIE")
	#
	fsm.root.transition_to(State.ID.DYING)

func level_up(i:int) -> void:
	stats.level_up(i)
	caster_stats.level_up(i)

	if name.find("[R") != -1:
		name = name.substr(0, name.find("[R")).strip_edges()

	name = "%s [R%s]" % [name, rank.rank]
