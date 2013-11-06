import java.util.*;
import java.io.*;


public class genTestSCs {
	
	private static int ctr = 0;
	private static Vector matrixV = new Vector();
	private static Vector v = new Vector();
	private static Random randomGenerator = new Random();
	private static int rand;
	
    // print N! permutation of the characters of the string s (in order)
    public  static void perm1(String s) { perm1("", s); }
    private static void perm1(String prefix, String s) {
        int N = s.length();
        if (N == 0 && ctr++ <= 1500){
			if(matrixV.size() > 40){
				rand = randomGenerator.nextInt(39) + 1;
			} else {
				if(matrixV.size() == 0)
					return;
					else
				rand = randomGenerator.nextInt(matrixV.size());
	
			}
				v.add(new Suncube(prefix,(String)matrixV.get(rand),rand));			
				matrixV.remove(rand);
			} else {
            for (int i = 0; i < N; i++)
               perm1(prefix + s.charAt(i), s.substring(0, i) + s.substring(i+1, N));
        }

    }

    // print N! permutation of the elements of array a (not in order)
    public static void perm2(String s) {
       int N = s.length();
       char[] a = new char[N];
       for (int i = 0; i < N; i++)
           a[i] = s.charAt(i);
       perm2(a, N);
    }

    private static void perm2(char[] a, int n) {
        if (n == 1) {
            System.out.println(a);
            return;
        }
        for (int i = 0; i < n; i++) {
            swap(a, i, n-1);
            perm2(a, n-1);
            swap(a, i, n-1);
        }
    }  

    // swap the characters at indices i and j
    private static void swap(char[] a, int i, int j) {
        char c;
        c = a[i]; a[i] = a[j]; a[j] = c;
    }



    public static void main(String[] args) {
	//38*40 = 1520
	int rows = 40;
	int cols = 38;
	int ind = 0;

	
		for(int i = 0; i < Math.floor(rows/10); i++){
			for(int j = 0; j < 10; j++){
				for(int n = 0; n < Math.floor(cols/26)+1; n++){
					for(int m = 0; m < 26; m++){
						matrixV.add(i + "" + j + "" + ((char)(n + 65)) + "" + (char)(m +65));
						if(ind++ == cols){
							ctr = 0;
							n++;
							break;
						}
					}
				}
			}
		}
	
       perm1("123456789");
	   
	   Collections.shuffle(v);
		  try{
			// Create file 
			FileWriter fw = new FileWriter("suncubes.txt");
			BufferedWriter out = new BufferedWriter(fw);
			for(Object  s : v)
				out.write(s.toString() + '\n');
			//Close the output stream
			out.close();
		}catch (Exception e){//Catch exception if any
		  System.err.println("Error: " + e.getMessage());
		}
    }
}