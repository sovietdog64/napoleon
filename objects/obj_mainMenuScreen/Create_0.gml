/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var buttonList = [
	new GuiButton(spr_save1,0,RESOLUTION_W-150,RESOLUTION_H+100,function() {
		global.saveNum = 1;								  
	}),													  
	new GuiButton(spr_save2,0,RESOLUTION_W-150,RESOLUTION_H+200,function() {
		global.saveNum = 2;								  
	}),													 
	new GuiButton(spr_save3,0,RESOLUTION_W-150,RESOLUTION_H+300,function() {
		global.saveNum = 3;
	}),
	new GuiButton(spr_start,0,RESOLUTION_W-86, RESOLUTION_H*0.9,function() {
		var fileName = "saveData" + string(global.saveNum) + ".sav";
		if(file_exists(fileName))
			loadGame();
		else
			room_goto(terrainGenTest);
	})
]

var textList = [
	new GuiText(RESOLUTION_W*0.2,RESOLUTION_H*0.4,"Load/Make a save",c_white,2,2,0,fnt_hud)
]

screen = new GuiScreen(
	0,0,RESOLUTION_W, RESOLUTION_H,
	buttonList,textList,
	-1,0
)