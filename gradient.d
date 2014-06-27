module gradient;

alias float function(double) Func;
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
}


double[] GradientDescent(double x0, float alpha, uint iters, 
	Func dfunc, float stepsize=1e-3){
	return Grad!double.gradient(x0, alpha, iters, dfunc);
}

