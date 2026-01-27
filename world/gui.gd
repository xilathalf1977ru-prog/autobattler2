extends CanvasLayer


func _ready() -> void:
	$"../TeamRed".team_changed.connect(func():on_changed($"../TeamRed","Red"))
	$"../TeamBlue".team_changed.connect(func():on_changed($"../TeamBlue","Blue"))

func on_changed(s:Team,dest:String) -> void:
	var units = s.units.size()
	var buildings = s.buildings.size()
	var total = units + buildings
	
	get_node(dest + "/1/1/UnitsCount").text = str(units)
	get_node(dest + "/1/2/BuildCount").text = str(buildings)
	get_node(dest + "/1/3/TotalCount").text = str(total)
