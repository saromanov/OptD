module matrix;

import std.stdio, std.algorithm, std.typecons, std.numeric,
       std.array, std.conv, std.string, std.range, std.variant, std.math;

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

T[][] transpose(T)(T [][] matrix) nothrow
        in
        {
        	assert(matrix.isSquare!T);
        }
        body {
		int n = matrix.length;
		return n.iota.map!(x => matrix[x].length.iota.map!(j => matrix[j][x]).array).array;
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

T[] productVec(T)(T[] vector, T value) nothrow in {
	assert(vector.length > 0);
}body {
	return vector.map!(x => x * value).array;
}

T[] operVec(T)(T[] vec1, T[] vec2, T function(T one, T two) func) nothrow{
	return iota(vec1.length)
		.map!((x,y) => func(x,y))
		.array;
}

T[] plusVec(T)(T[] vec1, T[] vec2) nothrow in{
	assert(vec1.length == vec2.length);
}body {
	return iota(vec1.length)
		.map!(x => vec1[x] + vec2[x])
		.array;
}

T[] minusVec(T)(T[] vec1, T[] vec2) nothrow in{
	assert(vec1.length == vec2.length);
}body {
	return iota(vec1.length)
		.map!(x => vec1[x] + vec2[x])
		.array;
}

T[][] product(T)(ref T[][] matrix, T number){
		return map!(x => map!(y => y * number)(x).array)(matrix).array;
}

int[] initArray(int nums){
	return iota(nums).array;
}

private T[][] zeroMatrix(T)(int n, int r){
	return n.iota
		   .map!(i => r.iota.map!(j => cast(T)(0)).array)
		   .array;	
}

T[][] eye(T)(int n) nothrow in{
	assert(n > 0);
}body{
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

T[][] subm(T)(T[][] data, T[][] data2) nothrow in{
		assert(data.length > 0);
		assert(data[0].length == data.length);
		assert(data.length == data2.length);
	}body {
		int n = data.length;
		foreach(immutable i; 0 .. n)
			foreach(immutable j; 0 .. n){
				data[i][j] -= data2[i][j];
			}
		return data;
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

Tuple!(T[][],"L", T[][],"R")
trilLR(T)(T[][] matrix){
	int n = matrix.length;
	auto zeros = (0.0).repeat.take(n);
	T[][] left = zeros.map!(x => zeros.array).array;
	for(int i = 0;i < n;++i){
		for(int j = 0;j < i+1;++j){
			left[i][j] = matrix[i][j];
		}
	}

	return typeof(return)(left, matrix.subm(left));
}

T[][] minor(T)(T[][] matrix){
		T[][] result = new T[][](matrix.length, matrix.length);
		for(int p = 0;p < matrix.length;++p){
			for(int i = 0;i < matrix.length;++i){
				T [][]arr = new T[][](matrix.length-1, matrix.length-1);
				T [] temp;
				int a = 0;
				for(int j = 0;j < matrix.length;++j){
					for(int k = 0;k < matrix.length;++k){
						if(k == i)k+=1;
						if(j == p)j+=1;
						if(k == matrix.length)break;
						if(j == matrix.length)break;
						temp ~= matrix[j][k];
						if(temp.length == matrix.length-1){
							arr[a] = temp;
							temp = [];
							a+=1;
						}
					}
				}
				result[p][i] = computeMinor(arr);
			}

		}
		return transpose(result);
}


//http://en.wikipedia.org/wiki/Determinant
    //http://www.easycalculation.com/matrix/learn-matrix-determinant.php
double determinant(T)(T [][] matrix){
		double resultvalue = 0;
		for(int i = 0;i < matrix.length;++i){
			T value = matrix[0][i];
			T [][]arr = new T[][](matrix.length-1, matrix.length-1);
			T [] temp;
			int a = 0;
			for(int j = 1;j < matrix.length;++j){
				for(int k = 0;k < matrix.length;++k){
					if(k == i)k+=1;
					if(k == matrix.length)break;
					temp ~= matrix[j][k];
					if(temp.length == matrix.length-1){
						arr[a] = temp;
						temp = [];
						a+=1;
					}
				}
			}
		if(i == 1) resultvalue -= computeDet(arr, value);
		else
		resultvalue+=computeDet(arr, value);
		}
		return resultvalue;
	}

	//Find adjoint of a matrix where AB = I
T[][] adjoint(T)(T[][] matrix){
		T[][]min = minor(matrix);
		for(int i = 1;i <= min.length;++i){
			for(int j = 1;j <= min.length;++j){
				min[i-1][j-1] = pow(-1, i+j) * min[i-1][j-1];
			}
		}
		return min;
}

// Get 2x2 matrix
double computeDet(T)(T[][]matrix, T value)
	in{
		assert(matrix.length == 2 && matrix[0].length);
	  }
	body
	{
		return value * (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]);
	}

double computeMinor(T)(T[][] matrix)
	in{
		assert(matrix.length == 2 && matrix[0].length);
	  }
	body
	{
		return (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]);
	}

//Matrix inverse;
//A^-1 = 1/|A|
//Now, only for 3x3 case
T [][] inv(T)(T [][] matrix){
	T[][] adj = adjoint(matrix);
	return adj.product(1/determinant(matrix));
}

