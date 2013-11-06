
//--------------------------------------------------------//
//                                                        //
//         SunCube(tm) Solar Position Calculator          //
//                                                        //
//         Copyright (c) Greg Watson 2009, 2010           //
//                  All Rights Reserved                   //
//                                                        //
//--------------------------------------------------------//          
 
#include <math.h>
#include <p24f16ka101.h>

// set the config registers / bits as required


_FBS( BSS_OFF & BWRP_ON )

/**   Boot Segment Code Protect:
**     BSS_HI2K             High Security Boot Protect 000000 - 002BFE
**     BSS_HI1K             High Security Boot Protect 000000 - 000AFE
**     BSS_STD2K            Standard Security Boot Protect 000000 - 002BFE
**     BSS_STD1K            Standard Security Boot Protect 000000 - 000AFE
**     BSS_OFF              Disabled
**
**   Boot Segment Write Protect Enable:
**     BWRP_ON              Enabled
**     BWRP_OFF             Disabled
*/


_FGS( GCP_ON & GWRP_ON )

/*   General Segment Code Protect:
**     GCP_ON               Enabled
**     GCP_OFF              Disabled
**
**   General Segment Write Protect Enable:
**     GWRP_ON              Enabled
**     GWRP_OFF             Disabled
*/


_FOSCSEL( FNOSC_FRC & IESO_OFF )

/*   Initial Oscillator Select:
**     FNOSC_FRC            Fast RC Oscillator (FRC)
**     FNOSC_FRCPLL         Fast RC Oscillator with PLL Module (FRCPLL)
**     FNOSC_PRI            Primary Oscillator (MS, HS, EC)
**     FNOSC_PRIPLL         Primary Oscillator with PLL Module (MSPLL, HSPLL, ECPLL)
**     FNOSC_SOSC           Secondary Oscillator (SOSC)
**     FNOSC_LPRC           Low Power RC Oscillator (LPRC)
**     FNOSC_LPFRC          Low Power Fast RC Oscillator With Postscaler - 500kHz (LPFRC)
**     FNOSC_FRCDIV         Fast RC Oscillator With Postscaler (FRCDIV)
**
**   Two Speed Start-up:
**     IESO_OFF             Disabled
**     IESO_ON              Enabled
*/


_FOSC( FCKSM_CSDCMD & SOSCSEL_SOSCHP & POSCFREQ_MS & OSCIOFNC_ON & POSCMOD_NONE )

/*   Clock switching and Fail-Safe Clock monitor:
**     FCKSM_CSECME         Both Clock Switching and Monitor Enabled
**     FCKSM_CSECMD         Clock Switching Enabled, Clock Monitor Disabled
**     FCKSM_CSDCMD         Both Clock Switching and Monitor Disabled
**
**   Secondary Oscillator Select:
**     SOSCSEL_SOSCLP       Low Power Secondary Oscillator
**     SOSCSEL_SOSCHP       High Power Secondary Oscillator
**
**   Primary Oscillator Frequency Range:
**     POSCFREQ_LS          Low Speed (< 100kHz)
**     POSCFREQ_MS          Mid Speed (100kHz - 8MHz)
**     POSCFREQ_HS          High Speed (> 8MHz)
**
**   OSCO Pin Configuration:
**     OSCIOFNC_ON          OSCO Pin Has Digital I/O Function (RA3)
**     OSCIOFNC_OFF         OSCO Pin Has Clock Out Function (CLKO)
**
**   Oscillator Selection:
**     POSCMOD_EC           External clock
**     POSCMOD_XT           XT oscillator
**     POSCMOD_HS           HS oscillator
**     POSCMOD_NONE         Primary disabled
*/


_FWDT( FWDTEN_OFF & WINDIS_OFF & FWPSA_PR32 & WDTPS_PS1 )

/*   Watchdog Timer:
**     FWDTEN_OFF           Disabled
**     FWDTEN_ON            Enabled
**
**   Windowed WDT:
**     WINDIS_ON            Window Mode
**     WINDIS_OFF           Non-Window Mode
**
**   Watchdog prescaler:
**     FWPSA_PR32           1:32
**     FWPSA_PR128          1:128
**
**   Watchdog postscale:
**     WDTPS_PS1            1:1
**     WDTPS_PS2            1:2
**     WDTPS_PS4            1:4
**     WDTPS_PS8            1:8
**     WDTPS_PS16           1:16
**     WDTPS_PS32           1:32
**     WDTPS_PS64           1:64
**     WDTPS_PS128          1:128
**     WDTPS_PS256          1:256
**     WDTPS_PS512          1:512
**     WDTPS_PS1024         1:1,024
**     WDTPS_PS2048         1:2,048
**     WDTPS_PS4096         1:4,096
**     WDTPS_PS8192         1:8,192
**     WDTPS_PS16384        1:16,384
**     WDTPS_PS32768        1:32,768
*/


_FPOR( MCLRE_OFF & BORV_V20 & I2C1SEL_PRI & PWRTEN_ON & BOREN_BOR0 )

/*   Master Clear Enable:
**     MCLRE_OFF            MCLR Disaled, RA5 Enabled
**     MCLRE_ON             MCLR Enabled, RA5 Disabled
**
**   Brown Out Voltage:
**     BORV_LPBOR           Low Power BOR
**     BORV_V27             2.7V
**     BORV_V20             2.0V
**     BORV_V18             1.8V
**
**   I2C1 pins Select:
**     I2C1SEL_SEC          Use ASCL1/ASDA1 Pins For I2C1
**     I2C1SEL_PRI          Use SCL1/SDA1 Pins For I2C1
**
**   Power Up Timer:
**     PWRTEN_OFF           Disabled
**     PWRTEN_ON            Enabled
**
**   Brown Out Reset:
**     BOREN_BOR0           Disabled in hardware, SBOREN bit disabled
**     BOREN_BOR1           Software controlled by SBOREN bit
**     BOREN_BOR2           Disabled only when in SLEEP, SBOREN bit disabled
**     BOREN_BOR3           Enabled in hardware, SBOREN bit disabled
*/


_FICD( BKBUG_OFF & ICS_PGx2 )

/*   Background Debugger:
**     BKBUG_ON             Enabled
**     BKBUG_OFF            Disabled
**
**   ICD pins select:
**     ICS_PGx3             EMUC/EMUD share PGC3/PGD3
**     ICS_PGx2             EMUC/EMUD share PGC2/PGD2
**     ICS_PGx1             EMUC/EMUD share PGC1/PGD1
*/


_FDS( DSWDTEN_OFF & DSBOREN_OFF & RTCOSC_SOSC & DSWDTOSC_LPRC & DSWDTPS_DSWDTPSF )

/*   Deep Sleep Watchdog Timer:
**     DSWDTEN_OFF          Disabled
**     DSWDTEN_ON           Enabled
**
**   Deep Sleep BOR:
**     DSBOREN_OFF          Disabled
**     DSBOREN_ON           Enabled
**
**   RTCC Reference Oscillator Select:
**     RTCOSC_LPRC          Low Power RC Oscillator (LPRC)
**     RTCOSC_SOSC          Secondary Oscillator (SOSC)
**
**   Deep Sleep Watchdog Oscillator Clock Select:
**     DSWDTOSC_LPRC        Secondary Oscillator (SOSC)
**     DSWDTOSC_SOSC        Low Power RC Oscillator (LPRC)
**
**   Deep Sleep Watchdog Postscale Select Bits:
**     DSWDTPS_DSWDTPS0     1:2 (2.1 ms)
**     DSWDTPS_DSWDTPS1     1:8 (8.3 ms)
**     DSWDTPS_DSWDTPS2     1:32 (33 ms)
**     DSWDTPS_DSWDTPS3     1:128 (132 ms)
**     DSWDTPS_DSWDTPS4     1:512 (528 ms)
**     DSWDTPS_DSWDTPS5     1:2048 (2.1 Seconds)
**     DSWDTPS_DSWDTPS6     1:8192 (8.5 Seconds)
**     DSWDTPS_DSWDTPS7     1:32,768 (34 Seconds)
**     DSWDTPS_DSWDTPS8     1:131,072 (135 Seconds)
**     DSWDTPS_DSWDTPS9     1:524,288 (9 Minutes)
**     DSWDTPS_DSWDTPSA     1:2,097,152 (36 Minutes)
**     DSWDTPS_DSWDTPSB     1:8,388,608 (2.4 Hours)
**     DSWDTPS_DSWDTPSC     1:33,554,432 (9.6 Hours)
**     DSWDTPS_DSWDTPSD     1:134,217,728 (38.5 Hours)
**     DSWDTPS_DSWDTPSE     1:536,870,912 (6.4 Days)
**     DSWDTPS_DSWDTPSF     1:2,147,483,648 (25.7 Days)
*/


// definitions for the sun position calculations

#define pi    					3.14159265358979323846
#define twopi					(2*pi)
#define rad						(pi/180)
#define dEarthMeanRadius		6371.01	  			// In km
#define dAstronomicalUnit		149597890	  		// In km
#define dEncoderPulsesPerDeg	(140000.0/360.0) 	// Encoder pulses per deg of SunCube movement


// general definitions

#define true		1
#define false		0


// timing and baud rate calculations

#define BRATE		25          		// 9600 baud (BREGH=0)
#define U_ENABLE	0x8010				// enable the UART peripheral (BREGH=1)
#define U_TX		0x8400				// enable transmission


// global variables follow

unsigned char
					SwBits,				// Hand controller bits

					Rd1,
					Tx1,				// comm 1 characters

					Rd2,
					Tx2;				// comm 2 characters

unsigned short
					iTemp;

signed short							// 16 bit signed integer variables
					iYear,				// Current date
					iMonth,
					iDay;

unsigned long							// 32 bit unsigned variables
					AziSun,				// Sun's Azimuth position in encoder pulses
					AltSun;				// Sun's Altitude position in encoder pulses

signed long								// 32 bit signed variables
					liAux1,
					liAux2;

double									// 32 bit floating point variables
		 			dHours,				// TOD hours. minutes & seconds
					dMinutes,
		 			dSeconds,
					dTimeZone,
		 			dDecimalHours,		// other time variables
		 			dElapsedJulianDays,
					dJulianDate,
										// Location
		 			dLongitude,			// Site Longitude in decimal degrees from EEprom
		 			dLatitude,			// Site Latitude in decimal degrees from EEprom
					dZenithAngle,
					dAzimuth,
					dAltitude,
					dMeanLongitude,
					dMeanAnomaly,
					dSin_EclipticLongitude,
		 			dOmega,
										// Main variables
		 			dEclipticLongitude,
		 			dEclipticObliquity,
		 			dRightAscension,
		 			dDeclination,
										// Auxiliary variables
		 			dY,
					dX,
		 			dGreenwichMeanSiderealTime,
	 				dLocalMeanSiderealTime,
	 				dLatitudeInRadians,
		 			dHourAngle,
	 				dCos_Latitude,
	 				dSin_Latitude,
	 				dCos_HourAngle,
					dParallax;


void SCSPC (void)						// SunCube Solar Position Calculator (SSPC)
{

// Calculate difference in days between the current Julian Day 
// and JD 2451545.0, which is noon 1 January 2000 Universal Time

// Calculate time of the day in UT decimal hours

	dDecimalHours = (dHours + ((dMinutes + (dSeconds / 60.0)) / 60.0)) - dTimeZone;

// Calculate current Julian Day

	liAux1 = (iMonth - 14) / 12;
	liAux2 = (1461 * (iYear + 4800 + liAux1)) / 4 + (367 * (iMonth -2 -12 * liAux1)) / 12 - (3 * ((iYear + 4900 
		+ liAux1) / 100)) / 4 + iDay - 32075;
	dJulianDate = (double)(liAux2) - 0.5 + dDecimalHours / 24.0;

// Calculate difference between current Juian Day and JD 2451545.0 

	dElapsedJulianDays = dJulianDate - 2451545.0;

// Calculate ecliptic coordinates (ecliptic longitude and obliquity of the 
// ecliptic in radians but without limiting the angle to be less than 2*Pi 
// (i.e., the result may be greater than 2*Pi)

	dOmega = 2.1429 - 0.0010394594 * dElapsedJulianDays;
	dMeanLongitude = 4.8950630 + 0.017202791698 * dElapsedJulianDays; 	// Radians
	dMeanAnomaly = 6.2400600 + 0.0172019699 * dElapsedJulianDays;
	dEclipticLongitude = dMeanLongitude + 0.03341607 * sin(dMeanAnomaly) + 0.00034894 
		* sin(2 * dMeanAnomaly) -0.0001134 -0.0000203 * sin(dOmega);
	dEclipticObliquity = 0.4090928 -6.2140e-9 * dElapsedJulianDays + 0.0000396 * cos(dOmega);

// Calculate celestial coordinates (right ascension and declination) in radians 
// but without limiting the angle to be less than 2*Pi (i.e., the result may be 
// greater than 2*Pi)

	dSin_EclipticLongitude = sin(dEclipticLongitude);
	dY = cos(dEclipticObliquity) * dSin_EclipticLongitude;
	dX = cos(dEclipticLongitude);
	dRightAscension = atan2(dY,dX);
	if(dRightAscension < 0.0) dRightAscension = dRightAscension + twopi;
	dDeclination = asin(sin(dEclipticObliquity) * dSin_EclipticLongitude);

// Calc azimuth and zenith angle in degrees

	dGreenwichMeanSiderealTime = 6.6974243242 + 0.0657098283 * dElapsedJulianDays + dDecimalHours;
	dLocalMeanSiderealTime = (dGreenwichMeanSiderealTime * 15 + dLongitude) * rad;
	dHourAngle = dLocalMeanSiderealTime - dRightAscension;
	dLatitudeInRadians = dLatitude * rad;
	dCos_Latitude = cos(dLatitudeInRadians);
	dSin_Latitude = sin(dLatitudeInRadians);
	dCos_HourAngle = cos(dHourAngle);
	dZenithAngle = (acos(dCos_Latitude * dCos_HourAngle * cos(dDeclination) + sin(dDeclination) * dSin_Latitude));
	dY = -sin( dHourAngle );
	dX = tan( dDeclination ) * dCos_Latitude-dSin_Latitude * dCos_HourAngle;
	dAzimuth = atan2( dY, dX );
	if (dAzimuth < 0.0 ) dAzimuth = dAzimuth + twopi;
	dAzimuth = dAzimuth / rad;

// Parallax Correction

	dParallax = (dEarthMeanRadius / dAstronomicalUnit) * sin(dZenithAngle);
	dZenithAngle = (dZenithAngle + dParallax) / rad;
	dAltitude = 90.0 - dZenithAngle;

// Finally the suns position is known to +- 0.087 deg
// Now we convert to motor encoder pulses so we can drive the
// SunCube to track the sun even under thick clouds!

	AziSun = (360.0 - dAzimuth) * dEncoderPulsesPerDeg;
	AltSun = (90.0 - dZenithAngle) * dEncoderPulsesPerDeg;

} // end SCSPC


unsigned char hex2bcd ( unsigned char x )
{
    return ( ((x / 10) << 4) + (x % 10) );

} // end hex2bcd


unsigned char bcd2hex ( unsigned char x )
{
	return ( (((x & 0xf0) >> 4) * 10) + (x & 0x0f) );

} // end bcd2hex


void GetHJStatus (void)
{
/* hex layout of hand controller status byte

		0 B8 (Cw)
		0 B9 (Cc)
		0 A6 (Up)
		0 B7 (Dn)
*/

	SwBits = 0;

	if (PORTBbits.RB8) SwBits = SwBits + 8;	// set 3:1
	if (PORTBbits.RB9) SwBits = SwBits + 4; // set 2:1
	if (PORTAbits.RA6) SwBits = SwBits + 2; // set 1:1
	if (PORTBbits.RB7) SwBits = SwBits + 1; // set 0:1


	if (SwBits == 0x0f) _RA1 = 0; else _RA1 = 1;	// if any switch = 0 let the F88 know

} // end GetHJStaus


void DelayMs( unsigned t)
{
    T1CON = 0x8000;     // enable tmr1, Tcy, 1:1
    while (t--)
    {
        TMR1 = 0;
        while (TMR1<4000); // 8 mhz clock / 2 = 4m counts / sec
    }
} // Delayms


// initialize the UART1 serial port
void initU1 (void)
{
	U1BRG 	= 25;    
	U1STA 	= 0x0000;
	U1MODE 	= 0x8810;
	U1STAbits.UTXEN = 1;
} // end initU1


void initU2 (void)
{
	U2BRG 	= 25;    
	U2STA 	= 0x4000;
	U2MODE 	= 0x8810;
	U2STAbits.UTXEN = 1;
} // end initU2


void putU1 ( unsigned char c)
{
	_CN23PUE = 0;						// turn off weak pullup for B7/Tx1
	TRISB = 0xff7e;						// make B7/Tx1 output

	while ( U1STAbits.UTXBF);   		// wait while Tx buffer full
	U1TXREG = c;
	return ;

} // end putU1


void putU2 (unsigned char c)
{
	while (U2STAbits.UTXBF);   			// wait while Tx buffer full
	U2TXREG = c;
	return ;

} // end putU2
										// wait for a new character to arrive to the UART2 serial port

// wait for a new character to arrive to the UART1 serial port
unsigned char getU1 (void)
{
	return U1RXREG;						// read the character from the receive buffer

}// end getU1

unsigned char getU2 (void)
{
	return U2RXREG;						// read the character from the receive buffer

}// end getU2


void initRTCC (void)
{   
// Enables the OSCON write and set SOSCEN =1;

 	asm volatile ("mov   #OSCCON, W1");
	asm volatile ("mov.b #0x46,   W2"); // unlock sequence
	asm volatile ("mov.b #0x57,   W3");
	asm volatile ("mov.b #0x02,   W0"); // SOSCEN =1
	asm volatile ("mov.b W2,      [W1]");
	asm volatile ("mov.b W3,      [W1]");
	asm volatile ("mov.b W0,      [W1]");		
 
//_RTCWREN = 1;

	asm volatile("push w7");
	asm volatile("push w8");
	asm volatile("disi #5");
	asm volatile("mov  #0x55,    w7");
	asm volatile("mov  w7,       _NVMKEY");
	asm volatile("mov  #0xAA,    w8");
	asm volatile("mov  w8,       _NVMKEY");
	asm volatile("bset _RCFGCAL, #13"); //set the RTCWREN bit
	asm volatile("pop  w8");
	asm volatile("pop  w7");

    _RTCEN = 0;         				// disable the clock

// set initial date and time

    _RTCPTR = 3;

	iTemp = hex2bcd (iYear - 2000);		// YEAR 0-99
	RTCVAL = iTemp;

    iTemp = (hex2bcd (iMonth - 1) << 8) 
          + hex2bcd (iDay - 1);			// MONTH-1/DAY-1
	RTCVAL = iTemp;

    iTemp = hex2bcd (dHours);			// WEEKDAY/HOURS
	RTCVAL = iTemp;

    iTemp = (hex2bcd (dMinutes) << 8)
		  + (hex2bcd (dSeconds));  		// MINUTES/SECONDS
	RTCVAL = iTemp;

// optional calibration

//	_CAL = 0x00;      

// lock and enable 

    _RTCEN = 1;         				// start the clock
    _RTCWREN = 0;       				// disable write enable to lock settings

} // end initRTCC


void readRTCC (void)
{
 // get current date and time

 _RTCPTR = 3;
 iTemp = RTCVAL;						// year 0 = 99 in bcd
 iYear = bcd2hex(iTemp & 0x00ff) + 2000;

 iTemp = RTCVAL;						// month-1, day-1 in bcd
 iMonth = 1 + (bcd2hex (iTemp >> 8));
 iDay = 1 + (bcd2hex (iTemp & 0x00ff));

 iTemp = RTCVAL;						// weekday, hours in bcd
 dHours = bcd2hex(iTemp & 0x00ff);

 iTemp = RTCVAL;						// minutes, seconds in bcd
 dMinutes = bcd2hex(iTemp >> 8);
 dSeconds = bcd2hex(iTemp & 0x00ff);
} // end read RTCC


void PulseA0 (void)
{
 _RA0 = 1;
 _RA0 = 0;
} // end PulseA0


int main (void)
{
 // port initialization

 AD1PCFG = 0xffff;						// all analogue pins as digital

 PORTA = 0x0000;						// set initial portA
 TRISA = 0xfffc;						// set portA directions, 1 = in

 PORTB = 0x0000;						// set initial portB
 TRISB = 0xfffe;						// set portB directions, 1 = in

 _CN23PUE = 1;							// pullup for B7/Down switch
 _CN8PUE = 1;							// pullup for A6/Up switch
 _CN21PUE = 1;							// pullup for B9/Cc switch
 _CN22PUE = 1;							// pullup for B8/Cw switch

 // init sun position

 iYear = 2010;							// input UT / GMT date
 iMonth = 8;
 iDay = 17;
 
 dTimeZone = 5.5;						// input local time
 dHours = 12.0;
 dMinutes = 30.0;
 dSeconds = 15.0;

 dLongitude = 74.018;					// input site lat and long
 dLatitude = 17.728;

 initRTCC();							// setup RTCC to keep time
 initU2();								// set up U2 serial port
 
 SCSPC();

/*while (true)
{
// readRTCC();
 SCSPC();							// call scspc to calc the sun's position

 putU2(iYear>>8);
 putU2(iYear>>0);
 putU2(iMonth);

 putU2(iDay);
 putU2(dHours);
 putU2(dMinutes);
 putU2(dSeconds);

 readRTCC();
}*/

 while (true)
 {
  GetHJStatus();						// get HJ switches status
  SCSPC();

  if (U2STAbits.URXDA)					// test for request from the F88
  {  
   Rd2 = getU2();  						// yup the F88 is talking to us
   if (Rd2 == 'T')						// test if sun pos requested
   {
    readRTCC();							// get current TOD
    SCSPC();							// call scspc to calc the sun's position

    putU2(AziSun>>16);					// send lsb first
    DelayMs(2);							// give F88 time to process the received byte
    putU2(AziSun>>8);					// then 2nd byte
    DelayMs(2);							// give F88 time to process the received byte
    putU2(AziSun>>0);					// finally msb

    DelayMs(2);							// give F88 time to process the received byte
    putU2(AltSun>>16);					// send lsb first
    DelayMs(2);							// give F88 time to process the received byte
    putU2(AltSun>>8);					// then 2nd byte
    DelayMs(2);							// give F88 time to process the received byte
    putU2(AltSun>>0);					// finally msb

    putU2(dLatitude>0);					// let F88 know which hemisphere we are in
   } // end SuperTAT send
   else
   if (Rd2 == 'H')						// test if HJ update requested
   {
    DelayMs(10);						// 10 ms delay for F88 to get ready for data
    putU2(SwBits);						// send switch status to F88
   } // end HJ send
  } // end char received
 } // end while true

 return(0);

} // end main

