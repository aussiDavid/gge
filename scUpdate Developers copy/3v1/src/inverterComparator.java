import java.util.*;

public class inverterComparator implements Comparator {

	public int compare(Object sc1, Object sc2){
		int sc1InverterString = ((Suncube)sc1).getInverterString();        
        int sc2InverterString = ((Suncube)sc2).getInverterString();
       
        if(sc1InverterString > sc2InverterString)
            return 1;
        else if(sc1InverterString < sc2InverterString)
            return -1;
        else
            return 0; 
	}
}