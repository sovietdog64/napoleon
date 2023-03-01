function Vector2(xx, yy) constructor {
	x = xx;
	y = yy;
	
	static addVec = function(vec) {
		x += vec.x;
		y += vec.y;
	}
	
	static subtractVec = function(vec) {
		x -= vec.x;
		y -= vec.y;
	}
	
	static divideVec = function(vec) {
		x /= vec.x;
		y /= vec.y;
	}
	
	static negate = function() {
		x *= -1;
		y *= -1;
	}
	
	static zero = function() {
		x = 0;
		y = 0;
	}
	
	static copy = function() {
		return new Vector2(x, y);
	}
	
	static isEqualTo = function(vec) {
		return x == vec.x && y == vec.y;
	}
	
	static flip = function() {
		var xx = x;
		x = y;
		y = xx;
	}
	
	static normalize = function() {
		x = sign(x);
		y = sign(y);
	}
	
}

function Vec2Zero() : Vector2(0,0) constructor {}