import std.stdio;
import std.typecons;
import la;

//Implementation of Berndt–Hall–Hall–Hausman algorithm
//http://en.wikipedia.org/wiki/BHHH_algorithm

alias T function(T,T) OFUNC;

T [][] BHHH(T)(T x0, OFUNC dfunc, int iters_limit){
	int iter = 1;
	T[] lambdas = StepSize(iters_limit, 0.75);
	T[] result = new T[](iters_limit.length);
	while(iter < iters_limit){
		auto grad = dfunc(x0,x0);
		auto result1 = grad.prod(grad).inv();
		result1[iter + 1] = result1[iter].prod(lambdas[iter]);
		iter += 1;

	}
}

//Append line search
T[] StepSize(T)(int count, T value=null){
	if(value is null)
		return count.iota.array;
	else 
		count.iota.map!(x => value).array;
}