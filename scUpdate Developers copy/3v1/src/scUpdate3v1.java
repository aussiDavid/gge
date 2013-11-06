/**
last edited : 26/4/11
select and pull system working
GUI fully interactive
exceptions are thrown
GUI is "fool-proof" i hope
automatically import suncube data from suncubes.csv
**/

/* packets needed to run program */
import gnu.io.*;

import java.io.IOException;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.FileNotFoundException;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Dimension;
import java.awt.Font;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;
import java.util.Scanner;
import java.util.Date;
import java.util.TimeZone;
import java.util.Enumeration;
import java.util.Vector;
import java.util.Arrays;
import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.Box;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JTextArea;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.ButtonGroup;
import javax.swing.JList;
import javax.swing.*;
import java.util.*;

public class scUpdate3v1 extends JFrame {
	//------ actionListener variables ----------
	///All possiable data we'd want know about the Suncube
	private String longitude;			//SCA
	private String latitude;			//SCB
	private String timeZone;			//SCC
	private String date;				//SCD
	private String time1;				//SCE
	private String time2;				//SCE
	
	private SimpleDateFormat DF = new SimpleDateFormat( "yyyy:MM:dd" );
	private SimpleDateFormat TF = new SimpleDateFormat( "HH:mm:ss.SS" );
	private SimpleDateFormat TZF = new SimpleDateFormat( ":ZZZZZ" );
	
	private DecimalFormat dFormat = new DecimalFormat("000.0000");
	//----------test suncubes----------
	private Suncube[] sc ={ new Suncube("123456789","00AA",1),
							new Suncube("912345678","00AB",1),
							new Suncube("891234567","00AC",1),
							new Suncube("789123456","00AE",1),
							new Suncube("678912345","01BC",2),
							new Suncube("567891234","01AB",2),
							new Suncube("456789123","01AC",2),
							new Suncube("345678912","01AD",3),
							new Suncube("234567891","02AA",3) };
	//------suncubeUpdater() variables -----
	private Enumeration portList;
	private CommPortIdentifier portId;
	
	private SerialPort serialPort;
	private OutputStream outputStream;
	private boolean outputBufferEmptyFlag = false;	
	//--------scUpdate3v1/Frame variables/objects----------
	private final Dimension FIELD_GAP = new Dimension(5,0);
	
	private int cellHeight = 15;
	private int cellWidth = 40;
	private int rows, cols;
	private int index = 0;
	
	final Font font = new Font("Verdana",1,16);

	private static SerialComm com = new SerialComm();
	private static scUpdate3v1 scFrame;
	
	Vector V = new Vector();
	//ordered and formated matrix/inverter suncube vectors
	Vector matrixListV = new Vector();
	Vector invStringListV = new Vector();
	//inverter String list vectors
	Vector serialInvV = new Vector();
	Vector matrixPosInvV = new Vector();
	Vector invStringInvV = new Vector();
	
	//matrix list vectors
	Vector serialMatV = new Vector();
	Vector matrixPosMatV = new Vector();
	Vector invStringMatV = new Vector();
	
	//panels
	private	JPanel mainP = new JPanel();		
	private	JPanel radioBP = new JPanel();		
	private	JPanel radioVP = new JPanel();		
	private	JPanel radioLVP = new JPanel();		
	private JPanel invMainP = new JPanel();
	private JPanel commandP = new JPanel();
	private JPanel comP = new JPanel();
	private JPanel consoleP = new JPanel();
	//buttons
	private JButton exeB = new JButton("Execute");
	private JButton connectB = new JButton(" Connect ");
	private JButton disconnectB = new JButton(" Disconnect ");
	//labels
	private JLabel broadcastL = new JLabel("Broadcast to: ");
	private JLabel listViewL = new JLabel(" View Suncubes by : ");
	private JLabel viewL = new JLabel("View Suncubes in : ");
	private JLabel view2L = new JLabel(" formation");
	private JLabel comL = new JLabel("Comm Port : ");
	private JLabel consoleL = new JLabel("Console: ");
	private JLabel commandL = new JLabel("Command Line: ");
	//text feilds
	private JTextField commandT = new JTextField();
	//text area
	public static JTextArea consoleA = new JTextArea(10,30);
	//Lists
	private JList invStringL = new JList();
	private JList matrixL = new JList();
	//combo box
	private JComboBox commPortC = new JComboBox();
	//radio buttons
	private JRadioButton oneR = new JRadioButton("One");
	private JRadioButton allR = new JRadioButton("All");
	private JRadioButton someR = new JRadioButton("Some");
	private JRadioButton matrixR = new JRadioButton("Matrix");
	private JRadioButton stringR = new JRadioButton("Inverter String");
	private JRadioButton serialR = new JRadioButton("Serial");
	private JRadioButton matrixPosR = new JRadioButton("Matix Position");
	private JRadioButton invStringR = new JRadioButton("Inverter String");
	//radio group
	private ButtonGroup listViewO = new ButtonGroup();
	private ButtonGroup broadcastO = new ButtonGroup();
	private ButtonGroup viewO = new ButtonGroup();
	//Scroll panes
	private	JScrollPane invStringSP = new JScrollPane(invStringL);
	private	JScrollPane consoleSP = new JScrollPane(consoleA);
	private JScrollPane matrixSP = new JScrollPane(matrixL);

	public static void main(String[] args) {	
		scFrame = new scUpdate3v1();		//generate and draw frame
	}
	
	public scUpdate3v1() {
		//read suncube data from file
		readFromFile();
		//calculate the matrix representation
		calculateMatrixPos();
		//caluclate the inverter string representation
		calculateInverterString();
		
		this.setTitle("SUNCUBE UPDATER - SEND AND RECEIVE V3.1");

		//Layout the console panel
		consoleP.setLayout(new BoxLayout(consoleP, BoxLayout.X_AXIS));
		consoleP.add(consoleL);
		consoleP.add(consoleSP);
		//Layout the command panel
		commandP.setLayout(new BoxLayout(commandP, BoxLayout.X_AXIS));
		commandP.add(commandL);
		commandP.add(commandT);
		commandP.add(exeB);
		//Layout the Comm panel
		comP.setLayout(new BoxLayout(comP, BoxLayout.X_AXIS));
		comP.add(comL);
		comP.add(commPortC);
		comP.add(connectB);
		comP.add(disconnectB);
		//Layout the radio buttons for the list view panel
		radioLVP.setLayout(new BoxLayout(radioLVP, BoxLayout.X_AXIS));
		radioLVP.add(listViewL);
		radioLVP.add(serialR);
		radioLVP.add(matrixPosR);
		radioLVP.add(invStringR);		
		//Layout the radio buttons for the broadcast panel
		radioBP.setLayout(new BoxLayout(radioBP, BoxLayout.X_AXIS));
		radioBP.add(broadcastL);
		radioBP.add(oneR);
		radioBP.add(allR);
		radioBP.add(someR);
		//Layout the radio buttons view panel
		radioVP.setLayout(new BoxLayout(radioVP, BoxLayout.X_AXIS));
		radioVP.add(viewL);
		radioVP.add(matrixR);
		radioVP.add(stringR);
		radioVP.add(view2L);		
		//Layout the inverter string main panel
		//invMainP.setLayout(new BoxLayout(invMainP, BoxLayout.X_AXIS));
		//invMainP components added in calculateInverterString()
		
		//add radio buttons to List view group
		listViewO.add(serialR);
		listViewO.add(matrixPosR);
		listViewO.add(invStringR);		
		//add radio buttons to braodcast group
		broadcastO.add(oneR);
		broadcastO.add(allR);
		broadcastO.add(someR);
		//add radio buttons to view group
		viewO.add(matrixR);
		viewO.add(stringR);
		
		//set component size
		commPortC.setMaximumSize(new Dimension(700,40));
		commandT.setMaximumSize(new Dimension(700,40));
		
		//change component visiblity
		invStringSP.setVisible(false);
		//invStringL.setVisible(false);
		matrixSP.setVisible(false);
		//matrixL.setVisible(false);
		radioBP.setVisible(false);
		disconnectB.setVisible(false);
		radioVP.setVisible(false);
		radioLVP.setVisible(false);
		exeB.setEnabled(false);
		
		
		//fonts
		//buttons
		exeB.setFont(font);
		connectB.setFont(font);
		disconnectB.setFont(font);
		//labels
		listViewL.setFont(font);
		viewL.setFont(font);
		view2L.setFont(font);
		comL.setFont(font);
		consoleL.setFont(font);
		commandL.setFont(font);
		//text field
		commandT.setFont(font);
		//text area
		consoleA.setFont(font);
		//lists
		invStringL.setFont(font);
		matrixL.setFont(font);
		//combo box
		commPortC.setFont(font);
		//radio buttons
		matrixR.setFont(font);
		stringR.setFont(font);
		serialR.setFont(font);
		matrixPosR.setFont(font);
		invStringR.setFont(font);
		
		//generate list of avaliable COM ports
		list();									

		//Layout the main panel
		mainP.setLayout(new BoxLayout(mainP, BoxLayout.Y_AXIS));
		mainP.add(radioLVP);
	//	mainP.add(Box.createVerticalGlue());
	//	mainP.add(radioBP);
	//	mainP.add(Box.createVerticalGlue());
		mainP.add(radioVP);
		mainP.add(matrixSP);
	//	mainP.add(Box.createVerticalGlue());
		mainP.add(invStringSP);
	//	mainP.add(Box.createVerticalGlue());
		mainP.add(comP);
	//	mainP.add(Box.createVerticalGlue());
		mainP.add(commandP);
		mainP.add(consoleP);
		/*
		mainP.add(consoleA);
		mainP.add(Box.createVerticalGlue());
		*/
		//Attach main panel to frame.
		this.setContentPane(mainP);

		//actionListeners
		oneR.addActionListener(new Listener());
		allR.addActionListener(new Listener());
		someR.addActionListener(new Listener());
		matrixR.addActionListener(new Listener());
		stringR.addActionListener(new Listener());
		serialR.addActionListener(new Listener());
		matrixPosR.addActionListener(new Listener());
		invStringR.addActionListener(new Listener());
		exeB.addActionListener(new Listener());
		connectB.addActionListener(new Listener());
		disconnectB.addActionListener(new Listener());

		//Set size and minimum size
		this.setSize(1000, 700);
		this.setMinimumSize(new Dimension(1000, 700) );
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.show();
		
		while(commPortC.getItemCount() == 0){
			list();
			try {
			   Thread.sleep(500);  
			} catch (Exception e) {}
		}
	}
	
	public void calculateMatrixPos(){
		//sort sc array by matrixPos
		Arrays.sort(sc, new matrixComparator());
		//initialize a string to the first column 
		String largestCol = "AA";
		
		for(Suncube s : sc){
			String a = s.getMatrixPos().substring(2,4);
			if(a.compareTo(largestCol) > 0)
				largestCol = a;
		}
		
		char[] charPos = largestCol.toCharArray();
		int c = ((int)charPos[0] - 65)*26;
		int d = (int)charPos[1] - 64;

		cols = c + d;
		
		rows = Integer.parseInt(sc[sc.length-1].getMatrixPos().substring(0,2)) + 1;
		
		for(int i = 0; i < Math.floor(rows/10) + 1; i++){
			for(int j = 0; j < 10; j++){
				if(i*10+j >= rows)
					break;
				for(int n = 0; n < Math.floor(cols/26)+1; n++){
					for(int m = 0; m < 26; m++){
						if(sc[index].getMatrixPos().substring(2,4).equals((char)(n+65)+""+(char)(m+65))){
							//matrixListV.add(i + "" + j + "" + (char)(n+65) + "" + (char)(m+65));
							matrixListV.add(sc[index]);
							//System.out.println(i + "" + j + "" + (char)(n+65) + "" + (char)(m+65) + " | " + ((i*10+j) >= rows));
							
							if(index != sc.length-1)
								index++;
						} else {
							if(n*26+m >= cols)
								break;
							matrixListV.add(new Suncube(" "," ",0));	
							//matrixListV.add(" ");
						}
					}
				}

			}
		}
		
		//generate serial, matrixPos, invString vectors for list views
		for(Object s :matrixListV){
			serialMatV.add(((Suncube)s).getSerial());
			matrixPosMatV.add(((Suncube)s).getMatrixPos());
			if(((Suncube)s).getInverterString() == 0)
				invStringMatV.add(" ");
			else
				invStringMatV.add(((Suncube)s).getInverterString());
		}
		
		matrixL.setLayoutOrientation(JList.HORIZONTAL_WRAP);
		matrixL.setVisibleRowCount(rows);
		matrixL.setListData(matrixListV);
		matrixL.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);


		//matrixL.setFixedCellHeight(cellHeight);
		//matrixL.setFixedCellWidth(cellWidth);
	
		matrixSP.setSize(new Dimension(500,500));	
	}
	
		public void calculateInverterString(){
		//sort sc array by inverter String
		Arrays.sort(sc, new inverterComparator());
		int[] invTotals = new int[41];
		int max = 0;
		
		for(Suncube s : sc)			
			invTotals[s.getInverterString()]++;
			
		for(int i = 0; i < invTotals.length; i++){
			if(invTotals[i] > 0)
				V.add(i);
			if(invTotals[i] > max)
				max = invTotals[i];
		}

		index = 0;
		
		Vector testVector = new Vector();
		for(int i = 1; i <= V.size(); i++) {
			//no suncubes with this string, skip the string
			if(invTotals[i] != 0){
				for(int j = 0; j < invTotals[i]; j++)
					invStringListV.add(sc[index++]);
						
				for(int j = invTotals[i]; j < max; j++)
					invStringListV.add(new Suncube(" "," ",0));
			}
		}

		//invStringL.setFixedCellHeight(cellHeight);
		//invStringL.setFixedCellWidth(cellWidth);
		
		//generate serial, matrisPos and invString vectors for list views
		for(Object s : invStringListV){
			serialInvV.add(((Suncube)s).getSerial());
			matrixPosInvV.add(((Suncube)s).getMatrixPos());
			if(((Suncube)s).getInverterString() == 0)
				invStringInvV.add(" ");
			else
				invStringInvV.add(((Suncube)s).getInverterString());
			
		}
		
		invStringL.setLayoutOrientation(JList.VERTICAL_WRAP);
		invStringL.setListData(invStringListV);
		invStringL.setVisibleRowCount(max);
		
		System.out.println(invStringInvV);
		
	}
	
	private FileReader fin = null;
	// Main method
	public void readFromFile(){
		try{
			String lineIn = "";
			fin = new FileReader("suncubes.csv");
			Scanner line = new Scanner(lineIn);
			Scanner in = new Scanner(fin);
			Vector tempV = new Vector();
			
			while(in.hasNext()){
				lineIn = in.nextLine();
				
				if(lineIn.equals(""))
					break;
				
				line = new Scanner(lineIn).useDelimiter("\\s*,\\s*");
				
				String serial = line.next();
				String matrixPos = line.next();
				int invString = line.nextInt();
				
				if(serial.length() != 9){
					System.out.println("entry: " + serial + ", " + matrixPos + ", " + invString + " has been skipped.  Invalid serial");
					continue;
				}

				if(matrixPos.length() != 4){
					System.out.println("entry: " + serial + ", " + matrixPos + ", " + invString + " has been skipped.  Invalid matrix Position");
					continue;
				}
		
				tempV.add(new Suncube(serial,matrixPos, invString));
			}
			
		sc = new Suncube[tempV.size()];
		for(int i = 0; i < tempV.size(); i++)
			sc[i] = (Suncube)tempV.get(i);
			
		} catch (IOException e){
			System.err.println ("Unable to read from file");
			System.exit(-1);
		} finally {
			try{
				fin.close();
			} catch (IOException e){}
		}
	}
	
	private class Listener implements ActionListener {
		public void actionPerformed(ActionEvent action)	{
			if(action.getSource() == oneR){
				matrixSP.setVisible(true);
				matrixL.setVisible(true);
				matrixL.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
				matrixL.setSelectedIndex(0);
			}
			
			if(action.getSource() == someR){
				matrixL.setVisible(true);
				matrixSP.setVisible(true);
				matrixL.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
				matrixL.setSelectedIndex(0);
			}
			
			if(action.getSource() == allR){
				matrixL.setVisible(true);
				matrixSP.setVisible(true);
				matrixL.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
				matrixL.setSelectionInterval(0, matrixL.getModel().getSize() -1);
			}
			
			if(action.getSource() == matrixR){
				if(!serialR.isSelected() && !matrixPosR.isSelected() && !invStringR.isSelected()){
					consoleA.append("Please select a list view option first\n");
					viewO.clearSelection();
					return;
				}
				
			
				//show other buttons
				radioBP.setVisible(true);
				
				matrixL.setVisible(true);
				matrixSP.setVisible(true);
				
				invStringSP.setVisible(false);
			}
			
			if(action.getSource() == stringR){
				if(!serialR.isSelected() && !matrixPosR.isSelected() && !invStringR.isSelected()){
					consoleA.append("Please select a list view option first\n");
					viewO.clearSelection();
					return;
				}
				//hide other radio buttons and list
				radioBP.setVisible(false);
				matrixL.setVisible(false);
				matrixSP.setVisible(false);
				
				invStringSP.setVisible(true);
			}
			
			if(action.getSource() == serialR){
				radioVP.setVisible(true);
			
				matrixL.setListData(serialMatV);
				invStringL.setListData(serialInvV);
			}
			
			if(action.getSource() == matrixPosR){
				radioVP.setVisible(true);
				
				matrixL.setListData(matrixPosMatV);
				invStringL.setListData(matrixPosInvV);
			}
			
			if(action.getSource() == invStringR){
				radioVP.setVisible(true);
				
				matrixL.setListData(invStringMatV);
				invStringL.setListData(invStringInvV);
			}
			
			if(action.getSource() == exeB){
				//custom command, clears the console
				if(commandT.getText().equals("clear")){
					consoleA.setText("");
					commandT.setText("");
					return;
				}
			
				Vector outputVector = new Vector();
				int [] indices = new int[0];				
				
				if(matrixR.isSelected()){
					indices = matrixL.getSelectedIndices();
				
					for(int i : indices){
						Suncube s = (Suncube)matrixListV.get(i);
						//skip any dummy slections, dummy suncubes have inString = 0
						if(s.getInverterString() == 0)
							continue;
							
						outputVector.add(s.getSerial());
					}
				}
				
				if(stringR.isSelected()){
					indices = invStringL.getSelectedIndices();
					
					for(int i : indices){
						Suncube s = (Suncube)invStringListV.get(i);
						//skip any dummy slections, dummy suncubes have inString = 0
						if(s.getInverterString() == 0)
							continue;
							
						outputVector.add(s.getSerial());
					}
				}
				
				try{
					for(Object t : outputVector)
						out(commandT.getText()+","+(String)t);
				} catch (Exception e) {
					consoleA.append("failed to write to com port \n");
				}
			}
			
			if(action.getSource() == connectB){
				try{
					if(commPortC.getItemCount() == 0)
						consoleA.append("No ports avaliable \n");
					else {
						com.connect((String)commPortC.getSelectedItem());
						consoleA.append("connected to " + (String)commPortC.getSelectedItem() + "\n");
						
						disconnectB.setVisible(true);
						connectB.setVisible(false);
						exeB.setEnabled(true);
						radioLVP.setVisible(true);
					}
				} catch (Exception e) {
					consoleA.append("Failed to connect to comm \n");
				}
			}
			
			if(action.getSource() == disconnectB){
				try{
					com.terminate();
					consoleA.append("disconnected\n");
					
					disconnectB.setVisible(false);
					connectB.setVisible(true);
					exeB.setEnabled(false);
					radioVP.setVisible(false);
					radioLVP.setVisible(false);
					matrixSP.setVisible(false);
					invStringSP.setVisible(false);
					//clear Selecitons
					listViewO.clearSelection();
					viewO.clearSelection();
				} catch (Exception e) {
					consoleA.append("failed to disconnect :s \n");
				}
			}
			//any changed made to the JFrame will be updated
			scFrame.show();
		}
		
	public void out(String m) throws Exception{
		com.out.write(m.getBytes());
		consoleA.append("OUT > " + m + "\n");
	}
		
	}
	

// get list of ports available on this particular computer, by calling  method in CommPortIdentifier.
	public void list() {	
		commPortC.removeAllItems();
		
		Enumeration thePorts = CommPortIdentifier.getPortIdentifiers();
		while (thePorts.hasMoreElements()) {
			CommPortIdentifier com = (CommPortIdentifier) thePorts.nextElement();
			switch (com.getPortType()) {
			case CommPortIdentifier.PORT_SERIAL:
				try {
					CommPort thePort = com.open("CommUtil", 50);
					thePort.close();
					commPortC.addItem(com.getName()); //add port name to dropdown menu
				} catch (PortInUseException e) {
					System.out.println("Port, "  + com.getName() + ", is in use.");
				} catch (Exception e) {
					System.err.println("Failed to open port " +  com.getName());
					e.printStackTrace();
				}
			}
		}
	}
}	