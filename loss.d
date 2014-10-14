import std.functional, std.range;

T squared(T)(T[] v1, T[] v2) in{
	assert(v1.length > 0 && v2.length > 0 && v1.length == v2.length);
	}body{
		int len = v1.length;
		return sum(v1.length.iota.map!(x => pow(v1[x] - v2[x])).array)/v1.length;
	}

T hinge(T)(T[] v1, T[] v2) in{
	assert(v1.length > 0 && v2.length > 0 && v1.length == v2.length);
	}body {
		int len = v1.length;
		return sum(v1.length.iota.map!(x => max(0, 1 - v1[x] * v2[x])).array);
	}