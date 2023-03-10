/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var buttonList = [
	new GuiButton(spr_saveBtn, 0, RESOLUTION_W/2 - 64,RESOLUTION_H*0.4 - 32, function() {
		saveGame();
	}),
	new GuiButton(spr_loadBtn, 0, RESOLUTION_W/2 - 64,RESOLUTION_H*0.8 - 32, function() {
		loadGame();
	}),
	new GuiButton(spr_exit,0,RESOLUTION_W/2 - 64,RESOLUTION_H*0.6 - 32, function() {
		obj_saveLoad.skipRoomSave = true;
		room_goto(rm_mainMenu)
	})
]

screen = new GuiScreen(
	0,0, RESOLUTION_W, RESOLUTION_H,
	buttonList,
	[
		new GuiText(RESOLUTION_W/2, RESOLUTION_H*0.2, "PAUSED", c_white, 3,3,0,fnt_hud),
		new GuiText(RESOLUTION_W*0.2, RESOLUTION_H*0.2, "Save #: "+string(global.saveNum+1),c_yellow,1,1,0,fnt_hud)
	],
	-1,0
)