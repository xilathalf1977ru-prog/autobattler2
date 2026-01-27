extends Resource
class_name RankComp

var _exp:float = 0
var exp_to_next:float = 12 * pow(grow,1)

var grow:float = 1.4
var rank:int = 0
var limit:int = 16

signal level_upped(val:int)

var l:String

func add_exp(val:float) -> void:
	logg("%s:::%s -> %s" % [val,_exp,_exp + val])
	_exp += val
	while _exp > exp_to_next:
		level_up()

func level_up() -> void:
	if rank + 1 > limit:
		exp_to_next = INF
		return
	rank += 1
	exp_to_next = 12 * pow(grow, rank + 1)
	logg("level:::%s -> %s, next: %s" % [rank - 1,rank,exp_to_next])
	level_upped.emit(rank)

func logg(s:String) -> void:
	l += s + "\n"
