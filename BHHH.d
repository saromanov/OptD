import std.stdio;
import std.typecons;
import std.range;
import la.matrix;

//Implementation of Berndt–Hall–Hall–Hausman algorithm
//http://en.wikipedia.org/wiki/BHHH_algorithm



T [][] BHHH(T)(T function(T,T) dfunc, T[string] variables, int iters_limit){
	int iter = 1;
	T[] lambdas = StepSize(iters_limit, 0.75);
	int varlength = variables.keys.length;
	writeln(varlength);
	T[][] result = new T[][](iters_limit+1, varlength);
	result[0] = variables.values.array;
	while(iter < iters_limit){
		auto newvalues = new T[](varlength);
		int c = 0;
		foreach(ref i; variables.keys){
			newvalues[c] = dfunc(variables[i], variables[i]);
			c += 1;
		}
		auto result1 = grad.prod(grad).inv();
		result1[iter + 1] = result1[iter].prod(lambdas[iter]);
		iter += 1;

	}
	return result;
}

unittest {
	double[string] variables;
	variables["A"] = 0.025;
	variables["B"] = 0.999;
	auto func = function(double x, double y){ return 2 * x;};
	auto bhhh = BHHH!double(func, variables, 100);
}

//Append line search
T[] StepSize(T)(int count, T value=0){
	if(value is 0)
		return repeat(1e-5,10).array;
	
	return count.iota.map!(x => value).array;
}
