import std.stdio, std.math, std.algorithm;
import std.array, std.container, std.random;

alias float function(double) Func;
alias double[] Arr;

double[] Gradient(double x0, float alpha, uint iters, 
	Func dfunc, float stepsize=1e-3){
	double[] result = new double[](iters+1);
	result[0] = x0;
	for(int i = 0;i < iters;++i){
		result[i+1] = result[i] - alpha * dfunc(result[i]); 
	}
	return result;
}

float func(double x){
	return pow(x,2);
}

float dfunc(double x){
	return 2 * x;
}



/*void main()
{
	writeln(Gradient(0.74, 0.1, 100, &dfunc));
}*/
