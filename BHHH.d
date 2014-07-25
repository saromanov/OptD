import std.stdio;
import la;

//Implementation of Berndt–Hall–Hall–Hausman algorithm
//http://en.wikipedia.org/wiki/BHHH_algorithm

alias T function(T,T) OFUNC;

T [][] BHHH(T)(T x0, OFUNC dfunc, int iters_limit){
	int iter = 1;
	T[] result = new T[](iters_limit.length);
	while(iter < iters_limit){
		auto grad = dfunc(x0,x0);
		auto result1 = grad.prod(grad).inv();
		
	}
}
