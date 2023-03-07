var inst = instance_create_depth(x,y-64,depth,obj_chest);
inst.monkey = [id];
monkey2 = [inst.monkey];
saveRoom2();
//clipboard_set_text(json_stringify(global.levelData));