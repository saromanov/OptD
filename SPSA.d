import std.range, std.math, std.random, std.stdio, std.array, std.functional;
import matrix;


class AutoParamChainging
{
private:
	double _step;
	double _currplus, _currminus;
public:
	this(double value, double step){
		_step = step;
		_currplus = value;
		_currminus = value;
	}

	double nextPlus(){
		_currplus += _step;
		return _currplus;
	}

	double nextMinus(){
		_currminus -= _step;
		return _currminus;
	}

}

private struct Parameters
{
	double aparam, cparam, lambda1, lambda2;
	this(double ap, double cp, double l1, double l2){
		aparam = ap; cparam = cp; lambda1 = l1; lambda2 = l2;
	}
}

class SPSA (T){
	//Area for private parameters
	Parameters params;
public:
	this(double ap, double cp, double l1, double l2){
		params = Parameters(ap, cp, l1, l2);
	}

	//http://www.jhuapl.edu/ISSO/PDF-txt/Txt-Cp7/spsa_basic_constrained.txt
	void run(double[] startvalue, double alpha1, double alpha2, double theta, int p, int iters){
		auto alphachan = new AutoParamChainging(alpha1, 1e-6);
		auto result = uninitializedArray!(double[][])(startvalue.length, iters);
		auto lowertheta = (-1000).repeat().take(p);
		auto uppertheta = 1000.repeat().take(p);
		auto theta = 1.repeat().take(p);
		int n = 100;
		result[0] = startvalue;

		//Iters or some cases
		foreach(immutable i; 0 .. iters){
			theta = lowertheta;
			foreach(immutable k; 0 .. n){

				auto a1 = calcS(params.lambda1, params.lambda2+i+1, alpha1);
				auto c1 = calcS(params.cparam,i,alpha2);
				auto delta = 2 * round(uniform(0.0,1.0))-1;
				auto maxvalue = loss(theta.plus(c1 * delta));
				auto minvalue = loss(theta.plus(-(c1 * delta)));
				/*auto diff = (maxvalue - minvalue)/(2 * c1 * delta);
				theta = theta - a1 * diff;*/
				//theta = min(theta, theta);

			}

			auto lossdata = lossfinal(theta);
			auto loss_squre = pow(lossdata, 2);

		}
	}



//Area for private functions
private:
	//Loss function
	double loss(double x){
		return x;
	}

	//Loss final function
	double lossfinal(double x){
		return x;
	}

	auto calcS(double numerator, double value, double power){
		return numerator/pow(value, power);
	}

	void checkParameters(double alpha1, double alpha2, double theta, double p, int iters){
		assert(alpha1 != 0 && alpha2 != 0 && theta != 0 && p != 0 && iters > 0);
	}

}

pure nothrow unittest
{
	double [] startvalues = [15,15];
	auto spsa = new SPSA!double(1.0,1.0,0.5,0.5);
	spsa.run(startvalues, 0.5,0.5,0.5,2.0,100);
}

pure nothrow unittest
{
	double [] startvalues = [15,15];
	auto spsa = new SPSA!double(1.0,1.0,0.5,0.5);
	spsa.run(startvalues, 0.5,0.5,0,2.0,100);
}


//Need a loss function
double CostFunc(double value, double[string] params){
	return (params["A"] * value)/params["B"];
}
