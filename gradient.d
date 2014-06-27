module gradient;

alias float function(double) Func;
alias float function(double, double) Subgradient;
alias double[] Arr;


template Grad(T){
	T[] gradient(T x0, float alpha, uint iters, Func dfunc,float stepsize=1e-3){
		double[] result = new double[](iters+1);
		result[0] = x0;
		for(int i = 0;i < iters;++i){
			result[i+1] = result[i] - alpha * dfunc(result[i]); 
		}
		return result;
	}

	T[] subgradient(T x0, Func alpha, uint iters, real function(real) subgrad){
		double[] result = new double[](iters+1);
		T bestvalue;
		result[0] = x0;
		for(int i = 0;i < iters;++i){
			T current = result[i] - alpha(result[i]) * subgrad(result[i]);
			result[i+1] = current;
			if(current < bestvalue)
				bestvalue = current; 
		}
		return result;
	}
}


double[] GradientDescent(double x0, float alpha, uint iters, 
	Func dfunc){
	return Grad!double.gradient(x0, alpha, iters, dfunc);
}


//http://en.wikipedia.org/wiki/Subgradient_method
//http://see.stanford.edu/materials/lsocoee364b/01-subgradients_notes.pdf
double[] SubGradientDescent(double x0, Func alpha, uint iters, 
	real function(real) subgrad, 
	float stepsize=1e-3){
	return Grad!double.subgradient(x0, alpha, iters, subgrad);
}

