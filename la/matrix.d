module matrix;

import std.stdio, std.algorithm, std.typecons, std.numeric,
       std.array, std.conv, std.string, std.range, std.variant;

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

T[] product(T)(T[][] matrix, T[] vector) nothrow{
	int len = matrix.length;
	T[] result = new T[](matrix.length);
		foreach(immutable i; 0 .. len){
			T value = 0;
			foreach(immutable j; 0 .. matrix[0].length){
				value += matrix[i][j] * vector[j];
			}
			result[i] = value;
		}
	return result;
}

int[] initArray(int nums){
	return iota(nums).array;
}

private T[][] zeroMatrix(T)(int n, int r){
	return n.iota
		   .map!(i => r.iota.map!(j => cast(T)(0)).array)
		   .array;	
}

private T[][] eye(T)(int n){
	return n.iota
	.map!(i => n.iota.map!(j => cast(T)(i == j)).array)
	.array;
}

T[] sub(T)(T[] data1, T[] data2) nothrow in{
		assert(data1.length > 0);
		assert(data1.length == data2.length); 
	}body {
		return iota(data1.length)
			   .map!(x => data1[x] - data2[x])
			   .array;
	}

private T[][] pivot(T)(T[][] matrix) in {
	assert(matrix.isSquare());
	}body
	{
		int len = matrix.length;
		T[][]p = eye!T(len);
		for(int i = 0;i < len;++i){
			T maxvalue = matrix[i][i];
			size_t row = i;
			for(int j = i;j < len;++j){
				if(matrix[j][i] > maxvalue){
					maxvalue = matrix[j][i];
					row = j;
				}
			}

			if(i != row){
				swap(p[i], p[row]);
			}
		}
		return p;
	}

//austingwalters.com/gauss-seidel-method/
Tuple!(T[][],"L", T[][],"U", const T[][],"P") lu(T)(T[][] matrix) nothrow in {
	assert(matrix.isSquare());
}body {
	int len = matrix.length;
	double[][] U = zeroMatrix!T(len, len);
	double[][] L = zeroMatrix!T(len, len);
	auto pivot = matrix.pivot();
	auto datamatrix = product!T(pivot, matrix);
	for(int i = 0;i < len;++i){
		L[i][i] = 1;
		for(int x = 0; x < i+1;++x)
		{
			T result = 0.0;
			for(int j = 0;j < x;++j){
				result += U[j][i] * L[x][j];
			}
			U[x][i] = datamatrix[x][i] - result;
		}
		for(int x = i;x < len;++x){
			T result = 0;
			for(int j = 0;j < i;++j)
				result += U[j][i] * L[x][j];
			L[x][i] = (datamatrix[x][i] - result)/U[i][i];
		}
	}
	return typeof(return)(L, U, pivot);
}
