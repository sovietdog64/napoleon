var inst = instance_place(x, y+TILEW, obj_tree)
if(inst != id && inst != noone) 
	depth = inst.depth+1;

// Inherit the parent event
event_inherited();