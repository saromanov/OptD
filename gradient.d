module gradient;
import std.stdio;
import std.math;

alias float function(double) Func;
alias float function(double, double) Subgradient;
alias real function(double, float) HProx;
alias double[] Arr;



//Stepsize function
float ConstStepLength(float k,float k1, float subgrad){
	return abs((k - (k1 + 1))/(pow(subgrad,2)));
}

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
		T bestvalue = x0;
		result[0] = x0;
		for(int i = 0;i < iters;++i){
			auto sub = subgrad(result[i]);
			T current = result[i] - ConstStepLength(result[i], bestvalue, sub) * sub;
			writeln(ConstStepLength(result[i], bestvalue, sub));
			result[i+1] = current;
			if(abs(current) < abs(bestvalue))
				bestvalue = current; 
		}
		return result;
	}

	T[] proximal(T x0, float alpha, uint iters, HProx hprox, Func dfunc){
		double[] result = new double[](iters+1);
		result[0] = x0;
		for(int i = 0;i < iters;++i){
			x[i + 1] = hprox(x[i] - alpha * dfunc(x[i], alpha));
		}
		return result;
	}
}

HProx ProxType(string t){
	if(t == "x1"){
		auto sign = function(double x){
			if(x == 0)
				return 0;
			if( x > 0)
				return 1;
			if(x < 0)
				return -1;
		};

		auto maxf = function(double x, double y){
			if(x >= y)
				return x;
			else
				return y;
		}
		return function(double x, float alpha) => sign(x) * maxf(0, abs(x) - alpha);
	}

	if(t == "x2"){

	}

	if(t == "xinf"){

	}

	return null;
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

//Proximal Gradient Descent
double[] ProximalGradientDescent(double x0, Func dfunc, uint iters,const string hproxtype, 
	Func dfunc,
	float stepsize=1e-3){
	return Grad!double.proximal(x0,stepsize, iters, ProxType(hproxtype), Func dfunc);
}


