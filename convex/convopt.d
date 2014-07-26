module convopt;

import std.math;
import std.typecons;
import std.stdio;
import std.traits;


//import la.matrix;
import options;
import gradient;

//algorithms and applications for Convex Optimization
/* ConvOpt problem looks like min_{y \in R^m} f_1(y) + ... + f_k(y)
	where func f:R^n -> R
*/

//https://inst.eecs.berkeley.edu/~ee227a/fa10/login/l_cvx_pbs.html
/*S.Boyd - "Convex Optimization"
  https://web.stanford.edu/~boyd/cvxbook/bv_cvxbook.pdf
*/

class ConvexSolver(T)if(isNumeric!T) {

//Inner params for convopt
Options!T options;
public:
	this(Options!T options=null){
		if(options is null){
			this.options = new Options!T();
		}else
			this.options = options;
	}
	ConvexSolver addVariable(string varname, T variable){
		options.addVariable(varname, variable);
		return new ConvexSolver!T(options);
	}

	ConvexSolver addVariable(string name, T[] variables){
		options.addVariable(name, variables);
		return new ConvexSolver!T(options);
	}


	unittest {
		auto conv = new ConvexSolver!int();
		conv.addVariable("A",50)
			.addVariable("B",80);

		auto conv = new ConvexSolver!double();
		conv.addVariable("A",2.5);
			.addVariable("B",9.9);

		auto conv = new ConvexSolver!double();
		auto vec = [0.5,0.2,0.3];
		conv.addVariable("A", vec);
	}

	int countVariables()nothrow pure {
		return options.countVariables();
	}

	//TODO: Need class for objective function
	ConvexSolver addFunction(string funcname, double function(double) func){
		options.addFunction(funcname, func);
		return new ConvexSolver!T(options);
	}

	unittest {
		auto func = function(double x){ return x * 2;};
		auto conv = new ConvexSolver!double();
		conv.addFunction("f1", func);
	}

	ConvexSolver addConstaints(string cname) nothrow{
		return new ConvexSolver!T(options);
	}

	void solve(){
		//In the first step - use simple subgradient method

	}


}

