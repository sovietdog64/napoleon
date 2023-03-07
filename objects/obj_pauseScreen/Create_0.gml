/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var buttonList = [
	new GuiButton(spr_saveBtn, 0, 0,0, function() {
		saveGame();
	}),
	new GuiButton(spr_loadBtn, 0, 0,RESOLUTION_W*0.2, function() {
		loadGame();
	})
]

screen = new GuiScreen(
	0,0, RESOLUTION_W, RESOLUTION_H,
	buttonList,[],
	-1,0
)