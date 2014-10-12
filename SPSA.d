import std.range, std.math, std.random, std.stdio, std.array, std.functional,
std.conv,std.algorithm;
import std.parallelism : parallel;
import matrix;
import linear;


alias Real = real;
alias LOSS = double[] delegate (double[]);
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


//Simple "store" for parameters.
//Betther than store it in SPSA class
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
	LOSS loss;


public:
	this(double ap, double cp, double l1, double l2){
		params = Parameters(ap, cp, l1, l2);
		loss = &defaultloss; 
	}

	//User defined loss function
	void setLoss(LOSS func){
		loss = &defaultloss;
	}

	//http://www.jhuapl.edu/ISSO/PDF-txt/Txt-Cp7/spsa_basic_constrained.txt
	private void runInner(double[] startvalue, double alpha1, double alpha2, double theta2, int p, int iters){
		auto alphachan = new AutoParamChainging(alpha1, 1e-6);
		auto result = uninitializedArray!(double[][])(startvalue.length, iters);
		auto lowertheta = (-1000.0).rep(p);
		auto uppertheta = 1000.0.rep(p);
		auto theta = p.ones;
		int n = 100;
		result[0] = startvalue;
		auto lossvalue = 1;

		//Iters or some cases
		foreach(immutable i; 0 .. iters){
			theta = lowertheta;
			foreach(immutable k; 0 .. n-1){

				auto a1 = calcS(params.lambda1, params.lambda2+i+1, alpha1);
				auto c1 = calcS(params.cparam,i,alpha2);
				auto delta = p.iota.map!(x => to!(double)(2 * round(uniform(0.0,1.0))-1)).array;
				auto prod = delta.productVec(c1);
				auto maxvalue = loss(theta.plusVec(prod));
				auto minvalue = loss(theta.plusVec(delta.productVec(-c1)));

				auto diff = maxvalue
							.minusVec(minvalue)
							.divVec(delta.productVec(2 * c1));
				theta = theta.minusVec(diff.productVec(a1));
				theta = min(theta, uppertheta);
				theta = max(theta, lowertheta);

			}

			auto lossdata = lossfinal(theta);
			lossvalue += lossdata;

		}

		writeln("AVG loss value: %d".format(lossvalue/iters));
	}

	void run(double[] startvalue, double alpha1, double alpha2, double theta2, int p, int iters) in{
		 assert(iters > 0, "Iter most be > 0");
		 assert(startvalue.length > 0, "number of startvalue is zero");
		} body {
			runInner(startvalue, alpha1, alpha2, theta2, p, iters);
		}



//Area for private functions
private:
	//Loss function(Need to change)
	double[] defaultloss(double[] x){
		return x;
	}

	//Loss final function
	double lossfinal(double[] x){
		return sum(x);
	}

	double calcS(double numerator, double value, double power){
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
