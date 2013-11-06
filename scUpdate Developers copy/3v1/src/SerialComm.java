import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import gnu.io.SerialPortEvent;
import gnu.io.SerialPortEventListener;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

/**
 * This version of the SerialComm example makes use of the 
 * SerialPortEventListener to avoid polling.
 */
 
public class SerialComm {
	public InputStream in;
	public OutputStream out;
	
	CommPortIdentifier portIdentifier;
	CommPort commPort;
	SerialPort serialPort;

    public SerialComm(){
        super();
    }
    
    void connect (String portName) throws Exception{
        portIdentifier = CommPortIdentifier.getPortIdentifier(portName);
        if (portIdentifier.isCurrentlyOwned()){
            System.out.println("Error: Port is currently in use");
        } else {
            commPort = portIdentifier.open(this.getClass().getName(),2000);
            
			serialPort = (SerialPort) commPort;
			serialPort.setSerialPortParams(9600,SerialPort.DATABITS_8,SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);
			
			in = serialPort.getInputStream();
			out = serialPort.getOutputStream();
						   
			//(new Thread(new SerialWriter(out))).start();
			//outThread = new Thread(new SerialWriter(out));
			//outThread.start();
			
			serialPort.addEventListener(new SerialReader(in));
			serialPort.notifyOnDataAvailable(true);
        }     
    }

    void terminate () throws Exception{
		commPort.close();
    }
    /**
     * Handles the input coming from the serial port. A new line character
     * is treated as the end of a block in this example. 
     */
    public static class SerialReader implements SerialPortEventListener {
        private InputStream in;
        private byte[] buffer = new byte[1024];
		private int length;
		public ArrayList<String> input = new ArrayList<String>();
		int data;
        
        public SerialReader (InputStream in){
            this.in = in;
			input.add("");
        }
        
        public void serialEvent(SerialPortEvent arg0) {
            length = 0;
			try {
                while ((data = in.read()) > -1){
					//System.out.println(data);
                    if (data == 13) {		///set delimiter here
						input.add("");
                        break;
                    }   
					buffer[length++] = (byte)data;
				}
				//for(String str : input)
					//System.out.println("input : " + str);
				input.set(input.size()-1,input.get(input.size()-1) + new String(buffer,0,length));
				scUpdate3v1.consoleA.append("IN < "+ new String(buffer,0,length) + "\n");
            } catch (IOException e){
                e.printStackTrace();
                System.exit(-1);
            }
        }
		
		public String getBufferdString(){
			return(new String(buffer,0,length));
		}
		
		public ArrayList<String> getInputArray(){
			return input;
		}
    }

    /** */
    public static class SerialWriter implements Runnable{
        OutputStream out;
        
        public SerialWriter(OutputStream out){
            this.out = out;
        }
        
        public void run (){
		//System.out.println("SerialWriter : run()");
            try{                
                int c = 0;
                while (c > -1){
                    this.out.write(c);
					c = System.in.read();
					//System.out.println("c : " + c);
                } 
            } 
			catch (IOException e) {
                e.printStackTrace();
                System.exit(-1);
            }            
        }
		
		public OutputStream getOut(){
			return out;
		}
    }
    

}


	
	