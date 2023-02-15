draw_set_color(c_black);
array_foreach(roads,
				function(_element, _index) {
					var l = _element;
					draw_line(l.x1, l.y1, l.x2, l.y2);
				});				