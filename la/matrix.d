module matrix;
import std.stdio, std.algorithm, std.typecons, std.numeric,
       std.array, std.conv, std.string, std.range;

alias double[] vector;

//create empty matrix
T[][] create(T)(int cols, int rows) nothrow in{
	assert(cols > 0);
	assert(rows > 0);
	}
	body {
		return map!(x => new vector(rows))(new vector(cols)).array;
	}

bool isSquare(T)(T[][] arr) pure nothrow in {
	assert(!arr.isEmpty());
}body
{
	return true;
}

bool isEmpty(T)(T[][] arr){
	if(arr.length == 0 && arr[0].length == 0)
		return true;
	return false;
}

T[][] transpose(T)(T [][] arr) nothrow
        in
        {
        	assert(arr.isSquare!T);
        }
        body {
		T [][] result = new T[][](arr.length, arr[0].length);
		for(int i = 0;i < arr.length;++i){
			T tempvec[] = new T[arr[i].length];
			for(int j = 0;j < arr[i].length;++j){
				result[i][j] = arr[j][i];
			}
		}
		return result;
}

T[][] product(T)(T[][] matrix, T[][] values) nothrow{
	T [][] result = new T[][](matrix.length, matrix[0].length);
	for(int i = 0;i < matrix.length;++i){
		for(int j = 0;j < matrix[i].length;++j){
			double value = 0;
			for(int k = 0;k < values[j].length;++k)
				value += matrix[i][k] * values[k][j];
			result[i][j] = value;
		}
	}
	return result;
}


private T[][] initUpper(T)(T[][] matrix) nothrow in {
		assert(matrix.isSquare());
	}
	body {
	double[][] U = new double[][](matrix.length, matrix[0].length);
	for(int i = 0;i < matrix.length;++i){
		U[0][i] = matrix[0][i];
	}
	return U;
}

private T[][] initLower(T)(T[][] matrix, T[][] upper) nothrow in {
	assert(matrix.isSquare());
	assert(upper.isSquare());
	}
	body {
		int len = matrix.length;
		double[][] L = new double[][](len, len);
		for(int i = 1;i < matrix.length;++i)
			L[i][0] = (1/upper[0][0]) * matrix[i][0];
		return L;
	}

int[] initArray(int nums){
	int[] arr = new int[](nums);
	for(int i = 0;i < arr.length;++i)
		arr[i] = i;
	return arr;
}

private T[][] pivot(T)(T[][] matrix) in {
	assert(matrix.isSquare());
	}body
	{
		int len = matrix.length;
		double[][]p = new double[][](len, len);
		for(int i = 0;i < len;++i)
			for(int j = 0;j < len;++j)
				matrix[i][j] = i == j;
		for(int i = 0;i < n;++i){

		}
		return p;
	}

//austingwalters.com/gauss-seidel-method/
T[][] lu(T)(T[][] matrix)in {
	assert(matrix.isSquare());
}body {
	double[][] U = initUpper!T(matrix);
	double[][] L = initLower!T(matrix, U);
	auto pivot = matrix.pivot();
	auto datamatrix = product!T(pivot, matrix);
	for(int i = 0;i < matrix.length-1;++i){
		L[i][i] = 1;
		for(int x = i+1; x < i+1;++x)
		{
			T result = 0;
			for(int j = 0;j < x;++j)
				result += U[j][i] * L[x][j];
			U[x][i] = datamatrix[x][i] - result;
		}
		for(int x = i+1;x < i;++x){
			T result = 0;
			for(int j = i+1;j < i;++j)
				result += U[j][i] * L[x][j];
			L[x][i] = (datamatrix[x][i] - result)/U[i][x];
		}
	}
	writeln(matrix);
	return null;
}
