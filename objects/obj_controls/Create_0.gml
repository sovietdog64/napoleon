
textList = [
	new GuiText(0,0,"W/A/S/D - Move",c_white,1,1,0,fnt_hud),
	new GuiText(0,RESOLUTION_H*0.1,"Left click - Attack/Consume",c_white,1,1,0,fnt_hud),
	new GuiText(0,RESOLUTION_H*0.2,"Hold Left - Charge bow",c_white,1,1,0,fnt_hud),
	new GuiText(0,RESOLUTION_H*0.3,"I - Inventory/Crafting",c_white,1,1,0,fnt_hud),
]

screen = new GuiScreen(
	0,0,RESOLUTION_W,RESOLUTION_H,
	[
		new GuiButton(spr_exit, 0, RESOLUTION_W-128,0, function() {
			instance_destroy();
			instance_create_depth(0,0,0,obj_mainMenuScreen);
		})
	],
	textList,-1,0
)