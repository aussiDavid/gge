/**
last edited : 11/09/10
delay between SCD and SCE removed
SCE(2) now works. After SCE(2) is sent the ".... .... ...." is writen to the outputStream.
Dont know why but it works when you do this
**/

/* packets needed to run program */
import gnu.io.*;

import java.io.IOException;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.OutputStream;
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

public class scUpdate2v5 extends JFrame {
	final String FILENAME = "log/scUpdate.csv";
	final String defaultsFile = "log/scDefaults.txt";
	
	private	FileReader defaultsFin;			// load default's file reader
	private FileOutputStream defaultsFout;	//set defaults's outputStream
	private	FileReader wtfFin;				// writeToFile's file reader
	private FileOutputStream wtfFout;		// writeToFiles' outputStream		
	//------ actionListener variables ----------
	private String longitude;			//SCA
	private String latitude;			//SCB
	private String timeZone;			//SCC
	private String date;				//SCD
	private String time1;				//SCE
	private String time2;				//SCE
	
	private String longitudeSign;
	private String latitudeSign;

	private SimpleDateFormat DF = new SimpleDateFormat( "yyyy:MM:dd" );
	private SimpleDateFormat TF = new SimpleDateFormat( "HH:mm:ss.SS" );
	private SimpleDateFormat TZF = new SimpleDateFormat( ":ZZZZZ" );
	
	private DecimalFormat dFormat = new DecimalFormat("000.0000");

	//------suncubeUpdater() variables -----
	private Enumeration portList;
	private CommPortIdentifier portId;
	
	private SerialPort serialPort;
	private OutputStream outputStream;
	private boolean outputBufferEmptyFlag = false;
	
	private boolean portFound = false;
	
	//--------scUpdate2v5/Frame variables/objects----------
	private String loadingMessage = "";
	private final String DELIMITER = ",";
	final Dimension FIELD_GAP = new Dimension(5,0);

	final Font font = new Font("Verdana",1,16);
	//buttons
	private JButton setDefaultB = new JButton("Set Default");
	private JButton loadDefaultB = new JButton("Load Default");
	private JButton updateB = new JButton("Update"); 
	private JButton clearB = new JButton("Clear");
	//labels
	private JLabel longitudeL = new JLabel("longitude:");
	private JLabel latitudeL = new JLabel("latitude:");
	private JLabel comL = new JLabel("port:");
	private JLabel outputL = new JLabel("Console: ");
	//text feilds
	private JTextField longitudeT = new JTextField(10);
	private JTextField latitudeT = new JTextField(10);
	private JTextField comT = new JTextField(5);
	//text area
	private JTextArea outputA = new JTextArea(100,50);
	//combo box
	private JComboBox commPortC = new JComboBox();
	
	public static void main(String[] args) {	
		new scUpdate2v5();						//generate and draw frame
	}

	public scUpdate2v5() {
		this.setTitle("SUNCUBE UPDATER - WRITE ONLY V2.5");
		//Declare and initialise panels.
		JPanel longitudeP = new JPanel();
		JPanel latitudeP = new JPanel();
		JPanel comP = new JPanel();
		JPanel buttonP = new JPanel();
		JPanel outputP = new JPanel();
		JPanel mainP = new JPanel();		
		//Layout the longitude panel.
		longitudeP.setLayout(new BoxLayout(longitudeP, BoxLayout.X_AXIS));
		longitudeP.add(Box.createHorizontalGlue());
		longitudeP.add(longitudeL);
		longitudeP.add(Box.createRigidArea(FIELD_GAP));
		longitudeP.add(longitudeT);		
		longitudeP.add(Box.createHorizontalGlue());
		//Layout the latitude panel.
		latitudeP.setLayout(new BoxLayout(latitudeP, BoxLayout.X_AXIS));
		latitudeP.add(Box.createHorizontalGlue());
		latitudeP.add(latitudeL);
		latitudeP.add(Box.createRigidArea(FIELD_GAP));
		latitudeP.add(latitudeT);
		latitudeP.add(Box.createHorizontalGlue());
		//Layout the comP panel.
		comP.setLayout(new BoxLayout(comP, BoxLayout.X_AXIS));
		comP.add(Box.createHorizontalGlue());
		comP.add(comL);
		comP.add(Box.createRigidArea(FIELD_GAP));
		comP.add(commPortC);
		comP.add(Box.createHorizontalGlue());		
		//Layout the outputs panel
		outputP.setLayout(new BoxLayout(outputP, BoxLayout.X_AXIS));
		outputP.add(Box.createHorizontalGlue());
		outputP.add(outputL);
		outputP.add(Box.createRigidArea(FIELD_GAP));
		outputP.add(outputA);
		outputP.add(Box.createHorizontalGlue());
		//Layout the buttons panel.
		buttonP.setLayout(new BoxLayout(buttonP, BoxLayout.X_AXIS));
		buttonP.add(Box.createHorizontalGlue());
		buttonP.add(setDefaultB);
		buttonP.add(Box.createHorizontalGlue());
		buttonP.add(loadDefaultB);
		buttonP.add(Box.createHorizontalGlue());
		buttonP.add(updateB);
		buttonP.add(Box.createHorizontalGlue());
		buttonP.add(clearB);
		buttonP.add(Box.createRigidArea(FIELD_GAP));
		//Layout the main panel
		mainP.setLayout(new BoxLayout(mainP, BoxLayout.Y_AXIS));
		mainP.add(Box.createVerticalGlue());
		mainP.add(longitudeP);
		mainP.add(Box.createVerticalGlue());
		mainP.add(latitudeP);
		mainP.add(Box.createVerticalGlue());
		mainP.add(comP);
		mainP.add(Box.createHorizontalGlue());
		mainP.add(Box.createVerticalGlue());
		mainP.add(outputP);
		mainP.add(Box.createVerticalGlue());
		mainP.add(buttonP);
		mainP.add(Box.createVerticalGlue());
		
		//edit component state
		outputA.setEditable(false);
		
		//Set size	
		//Buttons
		setDefaultB.setFont(font);
		loadDefaultB.setFont(font);
		updateB.setFont(font);
		clearB.setFont(font);
		//labels
		longitudeL.setFont(font);
		latitudeL.setFont(font);
		comL.setFont(font);
		outputL.setFont(font);
		//text feilds
		longitudeT.setFont(font);
		latitudeT.setFont(font);
		comT.setFont(font);
		//text area
		outputA.setFont(font);
		//combo box
		commPortC.setFont(font);

		outputA.setLineWrap(true); //find a better use for this
		
		//assign and display welcome message
		loadingMessage += "Welcome to Suncube update version 2.5 \n\n";
		loadingMessage += "Longitude format: + or - xxx.xxxx | e.g. +143.6756\n";
		loadingMessage += "Latitude format: + or - xxx.xxxx | e.g. -343.6567\n";
		loadingMessage += "use Set Defualt to set a value for longitude,\n";
		loadingMessage += "latitude and COM Port for frequent use\n";
		loadingMessage += "use Load Defaults to load the set values to save some time\n";
		loadingMessage += "Clear: clear all the feilds and return to this welcome screen\n\n";
		loadingMessage += "Dont forget to UPDATE!, set data to suncube now\n";
		
		outputA.setText(loadingMessage);
		
		//generate list of avaliable COM ports
		list();									

		//Attach main panel to window.
		this.setContentPane(mainP);
		
		//actionListeners
		updateB.addActionListener(new Listener());
		longitudeT.addActionListener(new Listener());
		latitudeT.addActionListener(new Listener());
		setDefaultB.addActionListener(new setDefaultListener());
		loadDefaultB.addActionListener(new loadDefaultListener());
		clearB.addActionListener(new clearListener());
			
		//Set size and minimum size
		this.setSize(650, 450);
		this.setMinimumSize(new Dimension(650, 450) );
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.show();
	}

	private class Listener implements ActionListener {
		public void actionPerformed(ActionEvent action)	{
			//initialize all input variables
			clear();
			
			//try and see if all inputs are integers... if not, it will throw an exception
			try {
				if((longitudeT.getText()).length() > 9 || Double.parseDouble(longitudeT.getText()) < -180 || Double.parseDouble(longitudeT.getText()) > 180){
					outputA.setText("Invalid longitude: \nPlease enter a number with the format \"xxx.xxxx\" \n between -180 and 180");
					return;
				}			

				if((latitudeT.getText()).length() > 9 || Double.parseDouble(latitudeT.getText()) < -180 || Double.parseDouble(latitudeT.getText()) > 180){
					outputA.setText("Invalid Latitude: \nPlease enter a number with the format \"xxx.xxxx\" \n between -180 and 180");
					return;
				}
				
				//check the first character of the longitude text feild
				if(longitudeT.getText().charAt(0) != '-' && longitudeT.getText().charAt(0) != '+') {
					outputA.setText("Invalid Longitude: \nPlease enter + or - at the front of your number");
					return;
				}
				
				//check the first character of the latitude text feild
				if(latitudeT.getText().charAt(0) != '-' && latitudeT.getText().charAt(0) != '+') {
					outputA.setText("Invalid Lataitude: \nPlease enter + or - at the front of your number");
				}
				
				if(longitudeT.getText().charAt(0) == '+')
					longitudeSign = "+";
					
				if(latitudeT.getText().charAt(0) == '+')
					latitudeSign = "+";
				
				longitude = longitude +  longitudeSign + dFormat.format(Double.parseDouble(longitudeT.getText())) + DELIMITER;
				latitude = latitude + latitudeSign + dFormat.format(Double.parseDouble(latitudeT.getText())) + DELIMITER;
			}catch(NumberFormatException n){
				outputA.setText("You MUST enter numbers only");
				return;
			}
			
			//user's local timezone
			TimeZone local = TimeZone.getDefault();
			
			//DST - daylight savings time
			int DST = 0;							//initilize to not in daylight savings
			if(local.inDaylightTime(new Date()))	//check if in daylight savings
				DST = 1;
			
			// new Date() gets current date/Time
			date += DF.format(new Date()) + DELIMITER;
			timeZone += DST + TZF.format(new Date()) + DELIMITER;
					
			//send input via output
			suncubeUpdate();

			if(!portFound){
				outputA.setText("Port not found!");
				return;
			}
			//write input/output to file;
			writeToFile(FILENAME);
		}
	}
 
	private class setDefaultListener implements ActionListener {
		public void actionPerformed(ActionEvent action) {
		if(longitudeT.getText().length() == 0 || latitudeT.getText().length() == 0){
			outputA.setText("Enter a value for each field before seting a default");
			return;
		}
		
		try{
		    // Open an output stream, and override text
		   defaultsFout = new FileOutputStream (defaultsFile); 
			
		    // Print a text to file
			new PrintStream(defaultsFout).print(longitudeT.getText() + DELIMITER);
			new PrintStream(defaultsFout).print(latitudeT.getText() + DELIMITER);
			new PrintStream(defaultsFout).print((String)commPortC.getSelectedItem() + DELIMITER);
			
			outputA.setText("Input values have been saved");
			} catch (IOException e){
			outputA.setText("Unable to write to file \"" + defaultsFile + "\". May be in use by another program. Please try again");
			}finally{
				// Close our output stream
				if(defaultsFout != null) {
					try{
						defaultsFout.close();
					} catch(IOException e){}
				}
		}

		}
	}

	private class loadDefaultListener implements ActionListener {
		public void actionPerformed(ActionEvent action) {
		try{
			defaultsFin = new FileReader(defaultsFile);					
			Scanner in = new Scanner(defaultsFin).useDelimiter("\\s*,\\s*");				//scanner to read string between the delimiter
			if(in.hasNext()) {
				longitudeT.setText(in.next());
				latitudeT.setText(in.next());
				commPortC.setSelectedItem((String)in.next());
			} else
				outputA.setText("No settings found. Please set defulat values before loading");
					
				outputA.setText("default values loaded");
			} catch(IOException e){
				outputA.setText("Unable to read from file. \"" + defaultsFile + "\" may not exist. Please try again");
			}finally{
				// Close our output stream
				if(defaultsFin != null) {
					try{
						defaultsFin.close();
					} catch(IOException e){}
				}
		}
		}
	}

	private class clearListener implements ActionListener {
		public void actionPerformed(ActionEvent action) {
			longitudeT.setText("");
			latitudeT.setText("");
			comT.setText("");
			outputA.setText(loadingMessage);
		}
	}

	public void suncubeUpdate(){	
		String  defaultPort = (String)commPortC.getSelectedItem();
		portList = CommPortIdentifier.getPortIdentifiers();

		while (portList.hasMoreElements()) {
			portId = (CommPortIdentifier) portList.nextElement();
			if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
			if (portId.getName().equals(defaultPort)) {
				addText(outputA, "Found port " + defaultPort);

				portFound = true;

				try {
				serialPort = (SerialPort) portId.open("SimpleWrite", 2000);
				} catch (PortInUseException e) {
					outputA.setText("Port in use");
					continue;
				} 

				try {
					outputStream = serialPort.getOutputStream();
				} catch (IOException e) {}

				try {
					serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
				} 
				catch (UnsupportedCommOperationException e) {}
		
				try {
					serialPort.notifyOnOutputEmpty(true);
				} catch (Exception e) {
					outputA.setText("Error setting event notification \n" + e.toString());
					JOptionPane.showMessageDialog(null,"Error setting event notification \n" + e.toString(),"EVENT ERROR", JOptionPane.ERROR_MESSAGE);
					System.exit(-1);
				}
				
				//display outputs before sending
				addText(outputA, longitude + " - Longitude sent");
				addText(outputA, latitude + " - Latitude sent");
				addText(outputA, timeZone + " - Time Zone sent");
				addText(outputA, date + " - Date sent");

				//write to output stream
				try {
					outputStream.write(longitude.getBytes());
					outputStream.write(latitude.getBytes());
					outputStream.write(timeZone.getBytes());
					outputStream.write(date.getBytes());

					//generate time (1)
					time1 += (TF.format(new Date())).substring(0,11) + DELIMITER;
					//re=generate new time and write to outputStream
					outputStream.write((time1.substring(0,3) + (TF.format(new Date())).substring(0,11) + DELIMITER).getBytes());
					
					//wait 5 seconds
					try {
						Thread.sleep(5000);
					} catch (Exception e) {}
					
					//generate time and write to outputStream
					outputStream.write((time2.substring(0,3) + (TF.format(new Date())).substring(0,11) + DELIMITER).getBytes());
					outputStream.write(".... .... ....".getBytes());		//end of transmittions
					//re-generate time to display
					time2 += (TF.format(new Date())).substring(0,11) + DELIMITER;
					
					//outputStream.write((time2).getBytes());
					//display time (2)
					
					//Display time(1) and (2) sent
					addText(outputA,time1 + " - Time (1) sent");			//this time may be off my a few milli seconds
					addText(outputA,time2 + " - Time (2) sent");			//this time may be off my a few milli seconds, Approx 30ms differance

					} catch (IOException e) {
				} finally{
					if(outputStream != null) {
						try{
							outputStream.close();
						} catch(IOException e){}
					}
				}
				
				try {
				   Thread.sleep(500);  // Be sure data is transferred before closing
				} catch (Exception e) {}
				
				serialPort.close();									//close serialPort;
			} 
			} 
		} 
	}
	
  public void list() {
    // get list of ports available on this particular computer, by calling  method in CommPortIdentifier.
    Enumeration pList = CommPortIdentifier.getPortIdentifiers();

    // Process the list.
    while (pList.hasMoreElements()) {
		CommPortIdentifier cpi = (CommPortIdentifier) pList.nextElement();
		commPortC.addItem(cpi.getName());
	}
  }
	
	public void writeToFile(String FILENAME){
		boolean first = false;

		//Checks if there is anything in the file already
		try {
			wtfFin = new FileReader(FILENAME);
			Scanner in = new Scanner(wtfFin);
			if (in.hasNext())
				first = false;
			}
			
			catch (FileNotFoundException e){
				first = true;  
			}
			
			finally{
				if(wtfFin != null) {
					try{
						wtfFin.close();
					} catch(IOException e){}
				}
			}
			
		try{
		    // Open an output stream
		    wtfFout = new FileOutputStream (FILENAME,true); 
			
		    //Print a text to file
			//write column headers
			if(first) {
				new PrintStream(wtfFout).print("(" + longitude.substring(0,3) + ") longatude" + ", ");
				new PrintStream(wtfFout).print("(" + latitude.substring(0,3) + ") latitude" + ", ");
				new PrintStream(wtfFout).print("(" + time1.substring(0,3) + ") time(1)" + ", ");
				new PrintStream(wtfFout).print("(" + time2.substring(0,3) + ") time(2)" + ", ");
				new PrintStream(wtfFout).print("(" + date.substring(0,3) + ") date" + ", ");
				new PrintStream(wtfFout).print("(" + ((String)commPortC.getSelectedItem()).substring(0,3) + ") commPort\n");
			}
			//write new data
			new PrintStream(wtfFout).print(longitude.substring(3) + ", ");
			new PrintStream(wtfFout).print(latitude.substring(3) + ", ");
			new PrintStream(wtfFout).print(time1.substring(3) + ", ");
			new PrintStream(wtfFout).print(time2.substring(3) + ", ");
			new PrintStream(wtfFout).print(date.substring(3) + ", ");
			new PrintStream(wtfFout).print(((String)commPortC.getSelectedItem()).substring(3)+"\n");
			}		
			
		// Catches any error conditions
		catch (IOException e){
				outputA.setText("Output was not recorded!, please contact your administrator");
		} finally{
		    // Close our output stream
			if(wtfFout != null) {
				try{
					wtfFout.close();
				} catch(IOException e){}
			}
		}
	}
	
	public void clear() {
		//suncube output tags
		longitude = "SCA";
		latitude = "SCB";
		timeZone = "SCC";
		date = "SCD";
		time1 = "SCE";
		time2 = "SCE";
		
		longitudeSign = "";
		latitudeSign = "";
		outputA.setText("");
		portFound = false;
	}
	
	public  void addText(JTextArea JTA, String output){
		JTA.setText(JTA.getText() + output + "\n");
	}
	
}