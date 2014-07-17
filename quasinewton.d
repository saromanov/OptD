module quasinewton;
import matrix;
import std.math;
import std.stdio;
import std.range;


////http://en.wikipedia.org/wiki/BFGS_method
//http://terminus.sdsu.edu/SDSU/Math693a_f2013/Lectures/18/lecture.pdf
class BFGS(T){

float[string] variables;

T[][] computeMatrix(T)(T[][] matr, T[] diff, T[] outfunc){
	T[] ch = matr.product(diff).product(diff.T()).product(diff);
	T[] zn = diff.T().product(matr).product(diff);
	T[] one = outfunc.product(outfunc.T());
	T[] two = outfunc.T().product(diff);
}

T[][] initMatrix(T)(T[] diff, T[] output) nothrow in {
	assert(diff.length > 0);
	assert(output.length > 0);
} body {
	int len = output.length;
	auto result = new T[][](len, len);
	return result;
}
public:
	this(){

	}
	void addVariable(string varname, float value){
		variables[varname] = value;
	}

	void addFunc(T delegate(T value) func){

	}

	T[][] run(T[] x0, float epsilon, T function(T) func, T[] function(T[]) dfunc, float[string] vars,
	int iters){
	T[][] aprhessian = new T[][](iters, iters);
	T[][]direction = new T[][](iters, iters);
	T[][] hessian = new T[][](iters, vars.keys.length);
	T[][] values = new T[][](iters, iters);
	values[0] = x0;
	//hessian = initMatrix(values, values);
	for(int i = 0;i < iters;++i){
		direction[i] = hessian.product(dfunc(values[i]));
		/*values[i + 1] = values[i] + direction[i].product(epsilon);
		T[] diff = values[i + 1] - values[i];
		T outfunc = dfunc(values[i + 1]) - dfunc(values[i]);*/

		}
	return values;
	}

}
