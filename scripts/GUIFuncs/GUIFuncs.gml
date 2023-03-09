function GuiButton(_sprite, _subimg, xx, yy, _actionFunc = function() {}, _hoverText = "", sprXscale = 1, sprYscale = 1) constructor {
	x = xx;
	y = yy;
	sprite_index = _sprite;
	btnScaleX = sprXscale;
	btnScaleY = sprYscale;
	sprite_width = sprite_get_width(sprite_index) * btnScaleX;
	sprite_height = sprite_get_height(sprite_index) * btnScaleY;
	subimg = _subimg;
	var xOff = sprite_get_xoffset(sprite_index);
	var yOff = sprite_get_yoffset(sprite_index);
	xx -= xOff;
	yy -= yOff;
	rectangle = new Rectangle(xx, yy, xx+sprite_width, yy+sprite_height);
	hovered = false;
	clickAction = _actionFunc;
	hoverText = _hoverText;
	static draw = function() {
		hovered = rectangle.pointInRect(GUI_MOUSE_X, GUI_MOUSE_Y);
		draw_sprite_ext(sprite_index,0, x,y, btnScaleX, btnScaleY, 0,c_white,1)
		if(hovered) {
			draw_set_color(c_black);
			draw_rectangle(x,y, x+sprite_width,y+sprite_height, 1);
			if(hoverText != "") {
				draw_set_alpha(0.5);
				draw_rectangle(
					GUI_MOUSE_X, GUI_MOUSE_Y,
					GUI_MOUSE_X+string_width(hoverText)+20, GUI_MOUSE_Y+string_height(hoverText)+20,
					0
				)
				draw_set_alpha(1);
				
				var h = draw_get_halign()
				var v = draw_get_valign()
				
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_set_color(c_white);
				draw_text(GUI_MOUSE_X+10, GUI_MOUSE_Y+10, hoverText);
				
				draw_set_halign(h);
				draw_set_valign(v);
			}
		}
	}
}

function GuiTextExtColor(xx, yy, _str, _sep, _w, _xscale, _yscale, _angle, _c1, _c2, _c3, _c4, _alpha, _font) constructor {
	x = xx;
	y = yy;
	str = _str;
	sep = _sep;
	w = _w;
	xscale = _xscale;
	yscale = _yscale;
	angle = _angle;
	c1 = _c1;
	c2 = _c2;
	c3 = _c3;
	c4 = _c4;
	alpha = _alpha;
	font = _font;
	draw = function() {
		draw_set_font(font);
		draw_text_ext_transformed_color(x, y, str, sep, w, xscale, yscale, angle, c1, c2, c3, c4, alpha)
	}
}

function GuiText(xx, yy, _str, _color, _xscale, _yscale, _angle, _font) constructor {
	x = xx;
	y = yy;
	str = _str;
	color = _color;
	xscale = _xscale;
	yscale = _yscale;
	angle = _angle;
	font = _font;
	static draw = function() {
		draw_set_font(font);
		draw_set_color(color);
		draw_text_transformed(x, y, str, xscale, yscale, angle);
	}
}

function GuiScreen(_x1, _y1, _x2, _y2, _buttons, _texts, _backgroundSpr, _subimg) constructor {
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	subimg = _subimg;
	sprite_index = _backgroundSpr;
	rectangle = new Rectangle(x1, y1, x2, y2);
	buttons = _buttons;
	texts = _texts;
	
	
	static drawButtons = function() {
		if(is_array(buttons))
			for(var i=0; i<array_length(buttons); i++) {
				buttons[i].draw();
			}
	}
	
	static drawTexts = function() {
		if(is_array(texts))
			for(var i=0; i<array_length(texts); i++) {
				texts[i].draw();
			}
	}
	
	static drawScreen = function() {
		draw_set_alpha(0.5);
		draw_rectangle_color(
		0,0,
		RESOLUTION_W, RESOLUTION_H,
		c_black,c_black,c_black,c_black,
		0);
		draw_set_alpha(1);
		
		if(sprite_exists(sprite_index))
			drawSpritePosNineSlice(sprite_index, subimg, x1, y1, x2, y2);
		
		drawButtons();
		drawTexts();
	}
}

function closeAllScreens() {
	var hasClosedScreens = instance_exists(obj_inventory) || instance_exists(obj_guiScreenPar);
	instance_destroy(obj_inventory);
	with(obj_guiScreenPar) {
		if(object_index != obj_mainMenuScreen)
			instance_destroy();
	}
	return hasClosedScreens;
}