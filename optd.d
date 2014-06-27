module optd;

import std.stdio;
import std.math;
import gradient;


float dfunc(double x){
		return pow(x,3);
	}

void test_gradient(){
	writeln(GradientDescent(0.74, 0.5,100, &dfunc));
}

void main()
{

}