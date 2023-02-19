sprite_index = item.placedSprite;
rightClick = item.rightClickAction;
leftClick = item.leftClickAction;
solid = item.solid;

if(!is_method(rightClick))
	rightClick = function(){};
if(!is_method(leftClick))
	leftClick = function(){};