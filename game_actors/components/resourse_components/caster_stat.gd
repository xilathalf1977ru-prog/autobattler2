extends Resource
class_name CasterStat

enum WeaponType
{
	PHYS,
	MAGICK,
	ULTRA
}

@export var power:float = 1
@export var attack_bonus:float
@export var weapon_type:WeaponType

func level_up(rank:int) -> void:
	power = 1.0 + (power_at(rank) - power_at(rank - 1))/100.0
	attack_bonus = bonus_at(rank) - bonus_at(rank - 1)
	
func power_at(i:int) -> float:
	return (100.0 + i * 4.0)

func bonus_at(i:int) -> float:
	return i/3
