extends Resource
class_name AliveStat

enum ArmorType
{
	NO,
	PHYS,
	MAGICK,
	ULTRA
}

@export var def:float
@export var shield:float
@export var armor_type:ArmorType

func level_up(rank:int) -> void:
	def = def_at(rank) - def_at(rank - 1)
	shield = shield_at(rank) - shield_at(rank - 1)

func def_at(i:int) -> float:
	return (1.0 - 100.0/(100.0 + i * 6.0))

func shield_at(i:int) -> float:
	return i/4
