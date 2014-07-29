import std.stdio;
import std.typecons;
import std.range;
import matrix;

//Implementation of Berndt–Hall–Hall–Hausman algorithm
//http://en.wikipedia.org/wiki/BHHH_algorithm



T [] BHHH(T)(T function(T) dfunc, T[string] variables, int iters_limit){
	int iter = 0;
	//Init values for sep size
	T[] lambdas = StepSize(iters_limit, 0.75);
	int varlength = variables.keys.length;
	T[][] result = new T[][](iters_limit+1, varlength);
	result[0] = variables.values.array;
	while(iter < iters_limit){
		//Compute new values
		auto grad = new T[][](varlength, varlength);
		int c = 0;

		//Need to AD
		foreach(ref i; variables.keys){
			//TODO: Need some change for compute gradient
			auto data = new T[](varlength); 
			foreach(ref j; 0 .. varlength){
				data[j] = dfunc(variables[i]);
			}
			grad[c] = data;
			c += 1;
		}
		result[iter+1] = result[iter].minus(lambdas[iter].product(grad));
		iter += 1;

	}
	return result[result.length-1];
}

unittest {
	double[string] variables;
	variables["A"] = 0.025;
	variables["B"] = 0.999;
	auto func = function(double x){ return 2 * x;};
	auto bhhh = BHHH!double(func, variables, 100);
}

//Append line search
T[] StepSize(T)(int count, T value=0){
	if(value is 0)
		return repeat(1e-5,10).array;
	
	return count.iota.map!(x => value).array;
}
