function Button(_sprite, _subimg, xx, yy, _actionFunc) constructor {
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
}

function GuiScreen(_x1, _y1, _x2, _y2, _buttons, _backgroundSpr, _subimg) constructor {
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	subimg = _subimg;
	sprite_index = _backgroundSpr;
	rectangle = new Rectangle(x1, y1, x2, y2);
	drawScreen = function() {
		drawSpritePosNineSlice(sprite_index, subimg, x1 ,y1, x2, y2);
	}
	buttons = _buttons;
}