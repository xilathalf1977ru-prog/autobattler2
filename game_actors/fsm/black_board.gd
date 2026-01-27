extends RefCounted
class_name BlackBoard

var current_target_position:Vector2
var choosen_spell:Spell

var l:String

func logg(s:String) -> void:
	l += str(Engine.get_process_frames()) +"::  "+ s + "\n"
