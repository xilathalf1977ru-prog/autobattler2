@tool
extends Control
class_name PropertyBar
## only UI component

@onready var val_bar:ColorRect = $Val
@onready var tmp_bar:ColorRect = $Tmp

@export var _max_val:float
var _cur:float

#@export var sas:float:
	#set(val):
		#_set_cur(val)
		#sas = _cur

##get max val and connect modified() signal
func setup(prop:VitalProperty) -> void:
	_max_val = prop.max_val
	prop.modified.connect(_set_cur)
	prop.low.connect(on_low)
	prop.full.connect(on_full)
	resize()
	#bad
	_set_cur(prop._val)

func _set_cur(new_val:float) -> void:
	
	#upd bars must be earlier condition check
	var old_val:float = _cur
	
	_cur = clamp(new_val,0,_max_val)
	_upd_bars()
	
	if new_val < old_val:
		set_process(1)
	else:
		set_process(0)
		#for this
		tmp_bar.size.x = val_bar.size.x

func _ready() -> void:
	set_process(0)

func _upd_bars() -> void:
	val_bar.size.x = size.x * _cur/_max_val

func _process(delta: float) -> void:
	tmp_bar.size.x += (val_bar.size.x - tmp_bar.size.x - 5.0) * delta
	
	if (tmp_bar.size.x - val_bar.size.x < 1):
		tmp_bar.size = val_bar.size
		set_process(0)

func on_low() -> void:
	val_bar.color = Color.RED

func on_full() -> void:
	val_bar.color = Color("00ff22")
	
@warning_ignore("unused_private_class_variable")
@export_tool_button("resize") var ___asdds = resize
func resize() -> void:
	tmp_bar.size.y = size.y
	val_bar.size.y = size.y
	tmp_bar.position.x = 0
	val_bar.position.x = 0
	_upd_bars()
