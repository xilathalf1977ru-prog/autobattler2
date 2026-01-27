@tool
extends Node2D

@export var factor: float = 1.0

@export_tool_button("exec") var ___asdaf = go
func go() -> void:
	var source:String = "res://assets/.res/units"
	var dest:String = "res://assets//units"
	var dirs = DirAccess.get_directories_at(source)
	
	for dir in dirs:
		var in_path:String = source.path_join(dir)
		var out_path:String = dest.path_join(dir)
		execute(in_path,out_path)

func execute(in_dir:String,out_dir:String) -> void:
	var files: PackedStringArray = DirAccess.get_files_at(in_dir)
	for filename in files:
		
		if filename.get_extension() != "png":continue

		var input_path := in_dir.path_join(filename)
		var img := Image.new()
		img.load(input_path)

		var new_w := int(img.get_width() * factor)
		var new_h := int(img.get_height() * factor)
		img.resize(new_w, new_h, Image.INTERPOLATE_LANCZOS)

		var output_path := out_dir.path_join(filename)
		
		if not DirAccess.dir_exists_absolute(out_dir):
			DirAccess.make_dir_absolute(out_dir)
	
		img.save_png(output_path)
		create_visual_resource(output_path)
		print("new pic: ", output_path)

func create_visual_resource(png_path: String) -> void:
	var tex := load(png_path) as Texture2D

	var w := tex.get_width()
	var h := tex.get_height()

	var frames := 1
	if w != h:
		frames = w / h

	var res := StateVisualData.new()
	res.texture = tex
	res.frames = frames
	res.anima = UnitVisual.AnimaType.LOOP

	var tres_path := png_path.get_basename() + ".tres"
	ResourceSaver.save(res, tres_path)
