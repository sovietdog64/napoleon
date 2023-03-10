/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

preview = surface_create(RESOLUTION_W, RESOLUTION_H);

updatePreview = function() {
	var fileName = "preview" + string(global.saveNum);
	if(!file_exists(fileName)) {
		preview = -1;
		return;
	}
	
	var buf = buffer_load(fileName);
	buffer_set_surface(buf,preview,0);
	
}

global.saveNum = 0;
updatePreview();

buttonList = [
	new GuiButton(spr_exit,0,0,0,function() {game_end()}),
	new GuiButton(spr_save1,0,RESOLUTION_W-150,RESOLUTION_H*0.1,function() {
		global.saveNum = 0;								  
		updatePreview();
		obj_mainMenuScreen.textList[1].str = "Save #: " + string(global.saveNum+1);
	}),													  
	new GuiButton(spr_save2,0,RESOLUTION_W-150,RESOLUTION_H*0.27,function() {
		global.saveNum = 1;	
		updatePreview();
		obj_mainMenuScreen.textList[1].str = "Save #: " + string(global.saveNum+1);
	}),													 
	new GuiButton(spr_save3,0,RESOLUTION_W-150,RESOLUTION_H*0.45,function() {
		global.saveNum = 2;
		updatePreview();
		obj_mainMenuScreen.textList[1].str = "Save #: " + string(global.saveNum+1);
	}),
	new GuiButton(spr_start,0,RESOLUTION_W-150, RESOLUTION_H*0.7,function() {
		var fileName = "saveData" + string(global.saveNum) + ".sav";
		if(file_exists(fileName)) {
			loadGame();
		}
		else {
			global.saveGame = true;
			obj_saveLoad.skipRoomLoad = true;
			global.loadedOverworld = false;
			room_goto(terrainGenTest);
		}
		audio_stop_all();
	}),
	new GuiButton(spr_controls,0,0,RESOLUTION_H*0.8,function() {
		instance_destroy();
		instance_create_depth(0,0,0,obj_controls);
	})
]

textList = [
	new GuiText(RESOLUTION_W*0.2,RESOLUTION_H*0.4,"Load/Make a save",c_white,2,2,0,fnt_hud),
	new GuiText(RESOLUTION_W*0.2,RESOLUTION_H*0.5,"Save #: " + string(global.saveNum+1),c_white,1,1,0,fnt_hud),
]

screen = new GuiScreen(
	0,0,RESOLUTION_W, RESOLUTION_H,
	buttonList,textList,
	-1,0
)