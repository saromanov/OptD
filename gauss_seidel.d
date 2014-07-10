module GS;

import std.stdio, std.math;
import matrix;

//Implementation of Gauss-Seidel method

void GaussSeidel(double[]x, double[]b, double[][]matrix, int iters){
	auto LUR = matrix.lu();
	writeln(LUR.L);
	double [] result = new double[](x.length);
	for(int i = 0;i < iters;++i){
		auto res1 = sub(b, product!double(LUR.U, x));
		//Append inverse for L
		x = product!double(LUR.L, res1);
	}
}

void main(){
	double[][]A = [[4.0, -2.0, 1.0], [1.0, -3.0, 2.0], [-1.0, 2.0, 6.0]];
	double[]b = [1.0,2.0,3.0];
	double[]x = [1.0,1.0,1.0];
	GaussSeidel(x,b,A,10);
}

