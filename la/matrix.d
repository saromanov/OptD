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
