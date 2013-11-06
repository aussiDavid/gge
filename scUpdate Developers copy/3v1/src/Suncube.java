import java.util.*;
import java.lang.*;

class Suncube{
	private String serial;
	private String matrixPos;
	private int invString;

	public Suncube(String s, String m, int i){
		serial = s;
		matrixPos = m;
		invString = i;
	}

	public String getSerial() {
		return serial;
	}
	
	public String getMatrixPos() {
		return matrixPos;
	}

	public int getInverterString() {
		return invString;
	} 
	
	public String toString() {
		return serial + ", " + matrixPos + ", " + invString; 
	}
}
