import java.util.*;

public class matrixComparator implements Comparator {

	public int compare(Object sc1, Object sc2){
		String sc1matrixPos= ((Suncube)sc1).getMatrixPos();        
        String sc2matrixPos = ((Suncube)sc2).getMatrixPos();
       
        return sc1matrixPos.compareTo(sc2matrixPos); 
	}
}