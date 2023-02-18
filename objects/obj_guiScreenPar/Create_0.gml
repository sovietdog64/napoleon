///@description Only ONE screen can be displayed at a time

//Close all other screens when this one is being shown
for(var i=0; i<instance_number(obj_guiScreenPar); i++) {
	var inst = instance_find(obj_guiScreenPar, i);
	if(inst != id)
		instance_destroy(inst);
}

global.screenOpen = true;