module nd;

import std.range, std.functional;

//Numerical differentiation


public {
	/*
		Simple implementation of numerical differentiation
	*/
	T ND(T)(T function(T x) func, T h, T value){
		return ((func(value + h) - func(value - h))/2 * h) * 100;
	}

	T ND2(T) (T function (T x) func, T h, T value){
		return (func(value + h) - func(value))/h;
	}

	unittest {
		assert(ND2(1, 0.1, 5), 0);
	}
}