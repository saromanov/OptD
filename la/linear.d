import std.numeric, std.range;


double[] zeros(int n){
	return 0.0.rep(n);
}

unittest {
	auto z = 10.zeros;
	assert(z == [0,0,0,0,0,0,0,0,0,0]);
}


double[] ones(int n){
	return 1.0.rep(n);
}

unittest {
	auto z = 10.ones;
	assert(z == [1,1,1,1,1,1,1,1,1,1]);
}



T [] rep(T)(T n, int p) in {
	assert(p > 0);
}body {
	return n.repeat().take(p).array;
}
