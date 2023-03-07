function GuiButton(_sprite, _subimg, xx, yy, _actionFunc) constructor {
	x = xx;
	y = yy;
	sprite_index = _sprite;
	subimg = _subimg;
	var w = sprite_get_width(sprite_index);
	var h = sprite_get_height(sprite_index);
	var xOff = sprite_get_xoffset(sprite_index);
	var yOff = sprite_get_yoffset(sprite_index);
	xx -= xOff;
	yy -= yOff;
	rectangle = new Rectangle(xx, yy, xx+w, yy+h);
	clickAction = _actionFunc;
	static draw = function() {
		draw_sprite(sprite_index, subimg, x, y);
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
				var b = buttons[i];
				draw_sprite(b.sprite_index, b.subimg, b.x, b.y);
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
	instance_destroy(obj_guiScreenPar);
	return hasClosedScreens;
}