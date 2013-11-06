
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


_FBS ( BSS_HI2K & BWRP_ON )

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


_FGS ( GCP_ON 

/*   General Segment Code Protect:
**     GCP_ON               Enabled
**     GCP_OFF              Disabled
*/

	& GWRP_ON )

/*   General Segment Write Protect Enable:
**     GWRP_ON              Enabled
**     GWRP_OFF             Disabled
*/


_FOSCSEL ( FNOSC_FRC 

/*   Initial Oscillator Select:
**     FNOSC_FRC            Fast RC Oscillator (FRC)
**     FNOSC_FRCPLL         Fast RC Oscillator with PLL Module (FRCPLL)
**     FNOSC_PRI            Primary Oscillator (MS, HS, EC)
**     FNOSC_PRIPLL         Primary Oscillator with PLL Module (MSPLL, HSPLL, ECPLL)
**     FNOSC_SOSC           Secondary Oscillator (SOSC)
**     FNOSC_LPRC           Low Power RC Oscillator (LPRC)
**     FNOSC_LPFRC          Low Power Fast RC Oscillator With Postscaler - 500kHz (LPFRC)
**     FNOSC_FRCDIV         Fast RC Oscillator With Postscaler (FRCDIV)
*/

	& IESO_OFF )

/*   Two Speed Start-up:
**     IESO_OFF             Disabled
**     IESO_ON              Enabled
*/


_FOSC ( FCKSM_CSDCMD  

/*   Clock switching and Fail-Safe Clock monitor:
**     FCKSM_CSECME         Both Clock Switching and Monitor Enabled
**     FCKSM_CSECMD         Clock Switching Enabled, Clock Monitor Disabled
**     FCKSM_CSDCMD         Both Clock Switching and Monitor Disabled
*/

	& SOSCSEL_SOSCHP

/*   Secondary Oscillator Select:
**     SOSCSEL_SOSCLP       Low Power Secondary Oscillator
**     SOSCSEL_SOSCHP       High Power Secondary Oscillator
*/

	& POSCFREQ_MS

/*   Primary Oscillator Frequency Range:
**     POSCFREQ_LS          Low Speed (< 100kHz)
**     POSCFREQ_MS          Mid Speed (100kHz - 8MHz)
**     POSCFREQ_HS          High Speed (> 8MHz)
*/

	& OSCIOFNC_ON

/*   OSCO Pin Configuration:
**     OSCIOFNC_ON          OSCO Pin Has Digital I/O Function (RA3)
**     OSCIOFNC_OFF         OSCO Pin Has Clock Out Function (CLKO)
*/

	& POSCMOD_NONE )

/*   Oscillator Selection:
**     POSCMOD_EC           External clock
**     POSCMOD_XT           XT oscillator
**     POSCMOD_HS           HS oscillator
**     POSCMOD_NONE         Primary disabled
*/


_FWDT ( FWDTEN_OFF 

/*   Watchdog Timer:
**     FWDTEN_OFF           Disabled
**     FWDTEN_ON            Enabled
*/

	& WINDIS_OFF 

/*   Windowed WDT:
**     WINDIS_ON            Window Mode
**     WINDIS_OFF           Non-Window Mode
*/

	& FWPSA_PR32 

/*   Watchdog prescaler:
**     FWPSA_PR32           1:32
**     FWPSA_PR128          1:128
*/

	& WDTPS_PS1 )

/*   Watchdog postscale:
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


_FPOR ( MCLRE_OFF 

/*   Master Clear Enable:
**     MCLRE_OFF            MCLR Disaled, RA5 Enabled
**     MCLRE_ON             MCLR Enabled, RA5 Disabled
*/

	& BORV_V20 

/*   Brown Out Voltage:
**     BORV_LPBOR           Low Power BOR
**     BORV_V27             2.7V
**     BORV_V20             2.0V
**     BORV_V18             1.8V
*/

	& I2C1SEL_PRI 

/*   I2C1 pins Select:
**     I2C1SEL_SEC          Use ASCL1/ASDA1 Pins For I2C1
**     I2C1SEL_PRI          Use SCL1/SDA1 Pins For I2C1
*/

	& PWRTEN_ON 

/*   Power Up Timer:
**     PWRTEN_OFF           Disabled
**     PWRTEN_ON            Enabled
*/

	& BOREN_BOR0 )

/*   Brown Out Reset:
**     BOREN_BOR0           Disabled in hardware, SBOREN bit disabled
**     BOREN_BOR1           Software controlled by SBOREN bit
**     BOREN_BOR2           Disabled only when in SLEEP, SBOREN bit disabled
**     BOREN_BOR3           Enabled in hardware, SBOREN bit disabled
*/


_FICD ( BKBUG_OFF 

/*   Background Debugger:
**     BKBUG_ON             Enabled
**     BKBUG_OFF            Disabled
*/

	& ICS_PGx2 )

/*   ICD pins select:
**     ICS_PGx3             EMUC/EMUD share PGC3/PGD3
**     ICS_PGx2             EMUC/EMUD share PGC2/PGD2
**     ICS_PGx1             EMUC/EMUD share PGC1/PGD1
*/


_FDS ( DSWDTEN_OFF 

/*   Deep Sleep Watchdog Timer:
**     DSWDTEN_OFF          Disabled
**     DSWDTEN_ON           Enabled
*/

	& DSBOREN_OFF 

/*   Deep Sleep BOR:
**     DSBOREN_OFF          Disabled
**     DSBOREN_ON           Enabled
*/

	& RTCOSC_SOSC 

/*   RTCC Reference Oscillator Select:
**     RTCOSC_LPRC          Low Power RC Oscillator (LPRC)
**     RTCOSC_SOSC          Secondary Oscillator (SOSC)
*/

	& DSWDTOSC_LPRC 

/*   Deep Sleep Watchdog Oscillator Clock Select:
**     DSWDTOSC_LPRC        Secondary Oscillator (SOSC)
**     DSWDTOSC_SOSC        Low Power RC Oscillator (LPRC)
*/

	& DSWDTPS_DSWDTPSF )

/*   Deep Sleep Watchdog Postscale Select Bits:
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


// baud rate calculations

#define BRATE		25          		// 9600 baud (BREGH=0)


// global variables follow

unsigned char
					SwBits,				// Hand controller bits

					Rd1,
					Tx1,				// comm 1 characters

					Rd2,
					Tx2,				// comm2 characters

					TChar1,
					TChar2;				// temp comms characters

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
		 			dHours,				// TOD variables
					dMinutes,
		 			dSeconds,
					dTimeZone,
					dDayLightSaving,

		 			dDecimalHours,		// other time variables
		 			dElapsedJulianDays,
					dJulianDate,
								
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
					dTemp,
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

	dDecimalHours = dHours 
                  + ((dMinutes + (dSeconds / 60.0)) / 60.0) 
                  - dTimeZone
                  - dDayLightSaving;

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

	if (dAzimuth >= 180.0)
	 AziSun = (dAzimuth - 180.0) * dEncoderPulsesPerDeg;
	else
	 AziSun = (180.0 + dAzimuth) * dEncoderPulsesPerDeg;

	if (dZenithAngle <= 90.0)
	 AltSun = (90.0 - dZenithAngle) * dEncoderPulsesPerDeg;
	else
	 AltSun = (360.0 - (dZenithAngle - 90.0)) * dEncoderPulsesPerDeg;
} // end SCSPC


unsigned char hex2bcd ( unsigned char x )
{
 return ( ((x / 10) << 4) + (x % 10) );
} // end hex2bcd


unsigned char bcd2hex ( unsigned char x )
{
 return ( (((x & 0xf0) >> 4) * 10) + (x & 0x0f) );
} // end bcd2hex


unsigned char GetHJStatus (void)
{
/* hex layout of hand controller status byte

		0 B7 (Cw)
		0 B8 (Cc)
		0 B9 (Up)
		0 A6 (Dn)
*/

 SwBits = 0;

 if (PORTBbits.RB7) SwBits += 8; 		// set 3:1	// Cw switch
 if (PORTBbits.RB8) SwBits += 4;		// set 2:1	// Cc switch
 if (PORTBbits.RB9) SwBits += 2; 		// set 1:1	// Up switch
 if (PORTAbits.RA6) SwBits += 1; 		// set 0:1	// Dn switch

 if (SwBits == 0x0f) _RA1 = 0; else _RA1 = 1;		// if any switch = 0 let the F88 know
 return (SwBits);
} // end GetHJStaus


void DelayMs( unsigned short t)
{
 T1CON = 0x8000;     			// enable Tmr1, Tcy, 1:1
 while (t--)
 {
  TMR1 = 0;						// clear T1
  while (TMR1<4000); 			// 8 mhz clock / 2 = 4k counts / msec
 } // end while loop
 T1CON = 0;						// disable T1 to save power
} // Delayms


// initialize the UART1 serial port
void initU1 (void)
{
 U1BRG 	= BRATE;    
 U1STA 	= 0x4000;
 U1MODE = 0x8810;
 U1STAbits.UTXEN = 0;			// don't enable xmit for now
} // end initU1


void initU2 (void)
{
 U2BRG 	= BRATE;    
 U2STA 	= 0x4000;
 U2MODE = 0x8810;
 U2STAbits.UTXEN = 1;
} // end initU2


void putU1 ( unsigned char c)
{
 _CN23PUE = 0;							// turn off weak pullup for B7/Tx1
 TRISB = 0xff7e;						// make B7/Tx1 output
 while ( U1STAbits.UTXBF);  	 		// wait while Tx buffer full
 U1TXREG = c;
} // end putU1


void putU2 (unsigned char c)
{
 _RA4 = 0;								// make !cts low
 while ( U2STAbits.UTXBF );   			// wait while Tx buffer full
 U2TXREG = c;
} // end putU2
										// wait for a new character to arrive to the UART2 serial port

// wait for a valid new character to arrive to the UART1 serial port
unsigned char getU1 (void)
{
badU1rcv: 
 Rd1 = 0x00;							// clear rcv char for timeout error exit
// T1CON = 0x8000;    	 				// enable Tmr1, Tcy, 1:1, 4k counts / ms
// TMR1 = 0;								// clear T1

// while ( (TMR1 < 16000) & (!U1STAbits.URXDA) ); // wait 4ms or until Rx buffer full
   while ( !U1STAbits.URXDA );
// T1CON = 0;								// disable T1 to save power

 if (U1STAbits.FERR)
  goto badU1rcv;

 if (U1STAbits.URXDA)
  Rd1 = U1RXREG;

 return (Rd1);							// read the character from the receive buffer
}// end getU1


unsigned char getU2 (void)
{
 return (U2RXREG);						// read the character from the receive buffer
}// end getU2


void DoPulse (void)
{
 _RA0 = 1;
 DelayMs(1);
 _RA0 = 0;
 DelayMs(1);
} // end PulseA0


void GetPCTimeandCoords (void)
{
 if (getU1() == 'S')
  if (getU1() == 'C')
   if (getU1() == 'A')
   {
    Rd1 = getU1();						// get sign

    dLatitude = ((getU1() & 0x0f) * 10.0);
    dLatitude += (getU1() & 0x0f);

    getU1();							// skip '.'

    dLatitude += ((getU1() & 0x0f) * 0.1);
    dLatitude += ((getU1() & 0x0f) * 0.01);
    dLatitude += ((getU1() & 0x0f) * 0.001);
    dLatitude += ((getU1() & 0x0f) * 0.0001);

	getU1();							// skip ',' delimiter

    if (Rd1 == '-') dLatitude = -dLatitude;

	DoPulse();
   } // END SCA+xx.xxxx latitude input

 if (getU1() == 'S')
  if (getU1() == 'C')
   if (getU1() == 'B')
   {
    Rd1 = getU1();						// save sign

    dLongitude = ((getU1() & 0x0f) * 100.0);
    dLongitude += ((getU1() & 0x0f) * 10.0);
    dLongitude += (getU1() & 0x0f);

    getU1();							// skip '.'

    dLongitude += ((getU1() & 0x0f) * 0.1);
    dLongitude += ((getU1() & 0x0f) * 0.01);
    dLongitude += ((getU1() & 0x0f) * 0.001);
    dLongitude += ((getU1() & 0x0f) * 0.0001);

    if (Rd1 == '-') dLongitude = -dLongitude;

	getU1();							// skip ',' delimiter

	DoPulse();
   } // END SCB+xxx.xxxx longitude input

 if (getU1() == 'S')
  if (getU1() == 'C')
   if (getU1() == 'C')
   {
    dHours = ((getU1() & 0x0f) * 10.0);
    dHours += (getU1() & 0x0f);

    getU1();							// skip ':'

    dMinutes = ((getU1() & 0x0f) * 10.0);
    dMinutes += (getU1() & 0x0f);

    getU1();							// skip ':'

    dSeconds = ((getU1() & 0x0f) * 10);
    dSeconds += (getU1() & 0x0f);

    getU1();							// skip '.'

    dSeconds += ((getU1() & 0x0f) * 0.1);
    dSeconds += ((getU1() & 0x0f) * 0.01);

	getU1();							// skip ',' delimiter

	DoPulse();
   } // END SCCHH:MM:SS.SS input

 if (getU1() == 'S')
  if (getU1() == 'C')
   if (getU1() == 'D')
   {
    iYear = ((getU1() & 0x0f) * 1000);
    iYear += ((getU1() & 0x0f) * 100);
    iYear += ((getU1() & 0x0f) * 10);
    iYear += (getU1() & 0x0f);
 
    getU1();							// skip ':'

    iMonth = ((getU1() & 0x0f) * 10);
    iMonth += (getU1() & 0x0f);

    getU1();							// skip ':'
 
    iDay = ((getU1() & 0x0f) * 10);
    iDay += (getU1() & 0x0f);

	getU1();							// skip ',' delimiter

	DoPulse();
   } // END SCDYYYY:MM:DD input

 if (getU1() == 'S')
  if (getU1() == 'C')
   if (getU1() == 'E')
   {
    if (getU1() == '1') dDayLightSaving = 1.0;
    else dDayLightSaving = 0.0;

    getU1();							// skip ':'
    getU1();							// skip 'I' or G
    getU1();							// skip 'S' or M
    getU1();							// skip 'T' or T

    if (getU1() != ':')					// != ':' so skip '+'
    {
	 getU1();							// skip '0'
	 getU1();							// skip '5'
	 getU1();							// skip ':'
	 getU1();							// skip '3'
	 getU1();							// skip '0'
 	 getU1();							// skip ':'
   }

    Rd1 = getU1();						// get time zone sign

    dTimeZone = ((getU1() & 0x0f) * 10.0);
    dTimeZone += (getU1() & 0x0f);

    dTemp = ((getU1() & 0x0f) * 10.0);
    dTemp += (getU1() & 0x0f);
    dTimeZone += (dTemp / 60.0); 

    if (Rd1 == '-') dTimeZone = -dTimeZone;

	DoPulse();
  } // END SCEd:nnn:+zzzz input (d = daylight savings, nnn = time zone name, zzzz = time zone value
} // end GetInitData


void initRTCC (void)
{   
	__builtin_write_RTCWEN ();			// _RTCWREN = 1
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

//	_CAL = 0x00;      					// leave calibration as zero for now

// lock and enable 

    _RTCEN = 1;         				// start the RTCC counters
	_RTSECSEL = 1;						// select RTCC as output
	_RTCOE = 1;							// enable RTCC 1 second output on B14
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


void SendTOD (void)
{
 putU2(dSeconds);
 DelayMs(2);		
 putU2(dMinutes);
 DelayMs(2);		
 putU2(dHours);	

 DelayMs(2);		
 putU2(iDay);	
 DelayMs(2);		
 putU2(iMonth);	
 DelayMs(2);		
 putU2(iYear % 100);
} // end SendTOD

int main (void)
{
// port initialization
 
 AD1PCFG = 0xffff;						// all analogue pins to digital

 PORTA = 0x0000;						// set initial port A
 TRISA = 0xfffc;						// set portA directions, 1 = in
 
 PORTB = 0x0000;						// set initial port B
 TRISB = 0xbffe;						// set portB directions, 1 = in
 

// enable 32.768 kHz oscillator & RTCC to keep time

 __builtin_write_OSCCONL ( 0x02 ); 		// SOSCEN = 1
 DelayMs(100);							// delay 100 ms so SOSC can stablize
 initRTCC();


// get setup data from the PC & update RTCC

 initU1();								// initialize U1 to get data from the PC
 DelayMs(10);

 GetPCTimeandCoords();					// get setup data from the PC
 initRTCC();							// setup RTCC with PC's time and date

 U1MODE = 0x0000;						// as we are done with U1 disable it
 U1STA 	= 0x0000;						//
 DelayMs(10);

 initU2();								// set up U2 serial port for comms from F88
 DelayMs(10);							// let comm lines stabilize
 SendTOD();								// send what we received


// set pullups for switches

 _CN8PUE  = 1;							// pullup for A6/Dn switch
 _CN21PUE = 1;							// pullup for B9/Up switch
 _CN22PUE = 1;							// pullup for B8/Cc switch
 _CN23PUE = 1;							// pullup for B7/Cw switch

 
// wait for the RS232 cable to be unplugged so we don't generate a false Up HJ 

 while (_RB9 == 0) DelayMs(250);		// delay until RS232 cable unplugged
 DelayMs(250);							// delay some more to be sure

// while (U2STAbits.URXDA)
//  Rd2 = getU2();						// purge any excess HJ requests

// _RA0 = 1;

// setup done, now work for the Cube to track the sun & make some money

 while (true)
 {
  SwBits = GetHJStatus();
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

    DelayMs(2);							// give F88 time to process the received byte
    putU2(dLatitude>0);					// let F88 know which hemisphere we are in
   } // end SuperTAT send

   if (Rd2 == 'H')						// test if HJ update requested
   {
    DelayMs(2);							// 2 ms delay for F88 to get ready for data
    putU2(SwBits);				// send switch status to F88
   } // end HJ send
  } // end char received
 } // end while true

 return(0);
} // end main

