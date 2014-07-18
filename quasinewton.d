module quasinewton;
import matrix;
import std.math;
import std.stdio;
import std.range;


////http://en.wikipedia.org/wiki/BFGS_method
//http://terminus.sdsu.edu/SDSU/Math693a_f2013/Lectures/18/lecture.pdf
class BFGS(T){
alias T function(T) OFUNC;
T[string] variables;

T[][] computeMatrix(T)(T[][] matr, T[] diff, T[] outfunc){
	T[] ch = matr.product(diff).product(diff.T()).product(diff);
	T[] zn = diff.T().product(matr).product(diff);
	T[] one = outfunc.product(outfunc.T());
	T[] two = outfunc.T().product(diff);

}

public:
	OFUNC _dfunc;
	this(){

	}
	void addVariable(string varname, float value){
		variables[varname] = value;
	}

	void addFunc(OFUNC func){
		this._dfunc = func;
	}

	T[] computeValues(T)(T[] values, OFUNC dfunc){
		return map!(dfunc)(values).array;
	}
	T[][] run(float epsilon, int iters){
	T[][] aprhessian = new T[][](iters, iters);
	T[][] hessian = eye!T(variables.values.length);
	T[][] values = new T[][](iters+1, variables.values.length);
	values[0] = variables.values.array;
	T funcminus(T x,T y){
		return x-y;
		};
	for(int i = 0;i < iters;++i){
		auto newvalues = computeValues!T(values[i], _dfunc);
		auto direction = hessian.product(newvalues);
		values[i + 1] = values[i].minusVec(direction.productVec(epsilon));
		T[] diff = values[i + 1].minusVec(values[i]);
		T[] outfunc = computeValues!T(values[i+1], _dfunc).minusVec(newvalues);

		}
	return values;
	}

}
