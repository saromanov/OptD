module optd;

import std.stdio;
import std.math;
import gradient;

//TODO
//Merge gaussnewton and this project
//add Levenberg–Marquardt_algorithm

float dfunc(double x){
		return pow(x,3);
	}

void test_gradient(){
	writeln(GradientDescent(0.74, 0.5,100, &dfunc));
}

void test_subgradient(){
	auto stepsize = function float (double x){ return 1e-4;};
	auto result = SubGradientDescent(0.5, stepsize, 100, &tanh);
	writeln(result);
}

void main()
{
	test_subgradient();
}