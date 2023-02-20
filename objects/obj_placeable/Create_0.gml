sprite_index = item.placedSprite;
rightClick = item.rightClickAction;
leftClick = item.leftClickAction;
solid = item.solid;
hp = item.hp;
maxHp = hp;
prevHp = hp;

alarm_set(0, room_speed*5)

if(!is_method(rightClick))
	rightClick = function(){};
if(!is_method(leftClick))
	leftClick = function(){};