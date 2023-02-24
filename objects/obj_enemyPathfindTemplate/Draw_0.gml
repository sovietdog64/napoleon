draw_self();
if(hp == 0)
	return;
{//Drawing health bar
	draw_healthbar(
		bbox_left, bbox_top-20,
		bbox_right, bbox_top,
		hp/maxHp,
		c_black,
		c_red,c_green,
		0,
		false,
		true
	)
}