var str = ""
for(var r=0; r<ds_grid_width(dungeonMap); r++) {
	for(var c=0; c<ds_grid_height(dungeonMap); c++) {
		str += string(dungeonMap[# c,r] != 0);
	}
	str += "\n";
}
show_debug_message(str)