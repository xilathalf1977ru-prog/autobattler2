
#----#----#
UmlDraw -> clear: clear all data, may no delete nodes if they not in boxes
UmlDraw -> go: 
	collect scripts from res://, 
	fill classes, 
	setup class_boxes
UmlDraw -> place: place all boxes at rectangle layout

UmlDraw -> find: drawing wide white line from (0,0) to specified class
UmlDraw -> print_vars: reload vars field in class_box and print var if true
UmlDraw -> print_funcs: reload funcs fieldin class_box and print funcs if true

#----#----#
ClassBox -> locked: prevent placing from another ClassBox
ClassBox -> draw_depends: draw yellow-orange arrows to depends

ClassBox -> parent: link to parent ClassBox, always draw sky-blue arrow

ClassBox -> place parent: place whole extends line at top of self
ClassBox -> place depends: place all dep in right of self
ClassBox -> place inherit:place all inherit in bottom at self

ClassBox -> placed_*_forced: placing through lock
