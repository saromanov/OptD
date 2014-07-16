module quasinewton;
import matrix;

T[][] computeMatrix(T[][] matr, T[] diff, T[] outfunc){
	T[] ch = matr.product(diff).product(diff.T()).product(diff);
	T[] zn = diff.T().product(matr).product(diff);
	T[] one = outfunc.product(outfunc.T());
	T[] two = outfunc.T().product(diff);
}

//http://en.wikipedia.org/wiki/BFGS_method
//http://terminus.sdsu.edu/SDSU/Math693a_f2013/Lectures/18/lecture.pdf
T[] BFGS(T)(T x0, float elsilon, T function(T) func,
	T function(T) dfunc, float[string] vars,
	int iters){
	T[][] aprhessian = new T[][](iters, iters);
	T[]direction = new T[](iters);
	T[][] hessian = new T[][](iters, vars.keys.length);
	T[] values = new T[](iters);
	T[0] = x0;
	for(int i = 0;i < iters;++i){
		direction[i] = aprhessian[i] * dfunc(T[i]);
		T[i + 1] = T[i] + alpha * direction[i];
		T diff = T[i + 1] - T[i];
		T outfunc = dfunc(T[i + 1]) - dfunc(T[i]);

	}
}