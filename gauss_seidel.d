module GS;

import std.stdio, std.math, std.functional, std.range;
import matrix, linear;

//Implementation of Gauss-Seidel method
//http://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method

private {

}

/*
	matrix is square matrix
	x - input vector with values
	b - guess for solution
	iters - number of iters or until converge
*/
double[][] GaussSeidel(double[]x, double[]b, double[][]matr, int iters){
	auto LUR = matr.trilLR();
	double [][] result = new double[][](iters+1, iters+1);
	//initial guess. Not need store to vector
	result[0] = x;
	foreach(immutable iter; 0 .. iters){
		foreach(immutable i; 0 .. matr.length){
			auto params = zeros(x.length);
			foreach(immutable j; 0 .. matr[0].length){
				params[j] = matr[i][j] * i;
			}
			auto res1 = b.sub(product!double(LUR.R, result[i]));
			auto res2 = product!double(LUR.L.inv(), res1);
			result[i+1] = res2;
		}
	}
	return result;
}

//Append optimization with lu


