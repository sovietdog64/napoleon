var inst = instance_create_depth(x,y,depth,obj_tree)
inst.testThing = [id];
otherTestThing = [inst];
saveRoom2();
clipboard_set_text(json_stringify(global.levelData))