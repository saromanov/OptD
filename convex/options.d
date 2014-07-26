import std.typecons;

//Helpful class
class Options(T){
alias T[string] Map;
alias T[][string] MapV;
Map data;
MapV datav;
public:
	this(){

	}

	~this(){

	}

	void addVariable(string name, T value){
		data[name] = value;
	}

	void addVariable(string name, T[] value){
		datav[name] = value;
	}

	void addFunction(string name, double function(double) func){

	}

	int countVariables() nothrow pure {
		return data.keys.length;
	}
}