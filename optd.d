module optd;

import std.stdio;
import std.math;
import gradient;

import std.stdio, std.random, std.range, std.array;

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
	auto result = SubGradientDescent(0.77, stepsize, 100, &tanh);
	writeln(result);
}

void test_proximal_gradient(){
	//auto result = ProximalGradientDescent(0.55, )
}

void example_gauss_seidel()
{
	import GS;
	import matrix;
	double[][]A = [[4.0, -2.0, 1.0], [1.0, -3.0, 2.0], [-1.0, 2.0, 6.0]];
	double[]b = [1.0,2.0,3.0];
	double[]x = [1.0,1.0,1.0];
	GaussSeidel(x,b,A,10);
}

void main()
{
	//test_proximal_gradient();
}