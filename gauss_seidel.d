module GS;

import std.stdio, std.math;
import matrix;

//Implementation of Gauss-Seidel method

double[][] GaussSeidel(double[]x, double[]b, double[][]matrix, int iters){
	auto LUR = matrix.trilLR();
	double [][] result = new double[][](iters+1, iters+1);
	result[0] = x;
	for(int i = 0;i < iters;++i){
		auto res1 = b.sub(product!double(LUR.R, result[i]));
		auto res2 = product!double(LUR.L.inv(), res1);
		result[i+1] = res2;
	}
	return result;
}


