@icon("res://editor_assets/spawner_icon.svg")
@tool
@abstract
extends Sprite2D
class_name Spawner

static var frac_colors:Dictionary[int,Color] = {
	0:Color.RED,
	1:Color.BLUE,
	2:Color.VIOLET,
	3:Color.YELLOW
}

static var frac_names:Dictionary[int,PackedStringArray]= {
   0: [
   	"Rage","Brut","Skull","Fang","Ash","Blood","Iron","Ruin","Claw","Gore",
   	"Hammer","Wrath","Spike","Grim","Crash","Maul","Break","Howl","Ripper","Scar"
   ],
   1: [
   	"Aqua","Pulse","Nova","Wave","Ion","Flux","Spark","Stream","Arc","Bolt",
   	"Signal","Echo","Glide","Shift","Phase","Core","Beam","Drift","Surge","Flow"
   ],
   2: [
   	"Void","Hex","Shade","Viper","Crow","Night","Venom","Witch","Oblivion","Feral",
   	"Specter","Ghost","Curse","Rune","Blight","Phantom","Reaper","Noir","Abyss","Whisper"
   ],
   3: [
   	"Gold","Sun","Pride","Flare","Crown","Valor","Shield","Glory","Lion","Banner",
   	"Radiant","Honor","Blaze","Torch","Aegis","Triumph","Regal","Bright","Halo","Oath"
   ]
}

static var frac_labels:Dictionary[int,String]= {
   0: "RED",
   1: "BLUE",
   2: "VIOLET",
   3: "YELLOW"
}

@export var actor_scene:PackedScene

@export var fraction:int:
	set(val):
		fraction = val
		queue_redraw()

@export var mng:BattleMng
@export var data:UnitSpawnerData:
	set(val):
		data = val
		if data:
			upd_draw()
			name = data.nom

@export var auto_activate:bool = 0
func _ready() -> void:
	if auto_activate and not Engine.is_editor_hint():
		if not mng.is_world_ready:
			await mng.world_ready
		spawn()

func upd_draw() -> void:
	centered = false
	texture = data.spawner_texture
	offset = Vector2(
		-texture.get_width()/(2.0 * hframes),
		-texture.get_height())
	queue_redraw()

func _draw() -> void:
	modulate = frac_colors[fraction]
	draw_circle(Vector2.ZERO,data.vision,Color.WHITE,0,1)

func spawn() -> void:
	var actor:Alived = actor_scene.instantiate()
	_pre_enter_execute(actor)
	
	add_sibling(actor)
	
	_spawn_execute(actor)
	
	register(actor)
	queue_free()

@abstract
func _spawn_execute(actor:Alived) -> void

func start_yield(val:float) -> void:
	get_tree().create_timer(val).timeout.connect(spawn)

func register(actor:Alived) -> void:
	if data.is_building:
		mng.teams[fraction].register_building(actor)
	else:
		mng.teams[fraction].register_unit(actor)

func _pre_enter_execute(actor:Alived) -> void:
	actor.global_position = global_position
	actor.set_fraction(fraction)
	actor.set_collision_layer_value(fraction + 1,1)
	actor.mng = mng
	var idx:int = hash(actor) % frac_names[fraction].size()
	if not data.is_building:
		actor.name = "%s %s [%s]" % [
			data.nom,
			frac_names[fraction][idx],
			frac_labels[fraction]
			]
