import std.range, std.math, std.random, std.stdio, std.array, std.functional,
std.conv,std.algorithm;
import matrix;
import loss;


//dot product
private double Loss(double[]data){
	return data.product(data);
}


//Generate [0,1] values
private double[] generateData(int num){
	return num.iota.map!(x => uniform(0.0,1.0)).array;
}


double[] RandomSearch(double []startvalues, int iters) in {
	assert(iters > 0);
	assert(startvalues.length > 0);
}body {
	double minloss = Loss(startvalues);

	double[] optimal = startvalues;
	for(int step = 0;step < iters;++step){

		auto newdata = 0;
		double[] newvalue = generateData(startvalues.length);
		double newloss = Loss(newvalue);
		if(newloss < minloss){
			minloss = newloss;
			optimal = newvalue;
		}
	}

	return optimal;
}
