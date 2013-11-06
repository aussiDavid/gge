
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


_FBS ( BSS_OFF 
/**   Boot Segment Code Protect:
**     BSS_HI2K             High Security Boot Protect 000000 - 002BFE
**     BSS_HI1K             High Security Boot Protect 000000 - 000AFE
**     BSS_STD2K            Standard Security Boot Protect 000000 - 002BFE
**     BSS_STD1K            Standard Security Boot Protect 000000 - 000AFE
**     BSS_OFF              Disabled
*/

	& BWRP_OFF )
/*
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

#define pi    					3.1415926535897932384626433832795
#define twopi					(2*pi)
#define rad						(pi/180)
#define dEarthMeanRadius		6371.009  					// In km
#define dAstronomicalUnit		149597870.691  				// In km

#define	dEncoderPulsesPerRev	14.0						// Encoder pulse edges per motor rev
#define dPlanetaryGearBoxRatio	(99.0+(1044.0/2057.0))		// Planetary gear box ratio
#define dWormGearRatio			100.0						// Final drive gear ratio

#define dDeg360					(dEncoderPulsesPerRev * dPlanetaryGearBoxRatio * dWormGearRatio) // pulses per 360 deg
#define dDeg180					(dDeg360 / 2)				// pulses per 180 deg
#define dDeg090					(dDeg360 / 2)				// pulses per 90 deg
#define dDeg001					(dDeg360 / 360.0)		 	// pulses per 1 deg
#define dEncoderPulsesPerDeg	dDeg001

#define	dClocksPerDay			(32768.0 * 60.0 * 1440.0)	// Clocks per day


// general definitions

#define true		1
#define false		0


// hand controller port bit to SwBits layout

#define Cw			_RB7
#define CwBit		3					// Cw switch

#define Cc			_RB8
#define CcBit		2					// Cc Switch

#define	Up			_RB9
#define UpBit		1					// Up Switch

#define Dn			_RA6
#define DnBit	 	0					// Dn Switch


// baud rate calculations

#define BRATE		25          		// 9600 baud (BREGH=0)


// global variables follow

unsigned char
					FstTrk,				// Fast Track flag
					CommsOK,			// comms ok flag
					AdjTimeOK,			// clock adjusted ok
					NoComms,			// never did comms upload

					SwBits,				// Hand controller bits

					Rd1,
					Tx1,				// comm 1 characters

					Rd2,
					Tx2,				// comm2 characters

					TChar1,
					TChar2;				// temp comms characters

signed char
					iClockCal;			// clock xtal calibration value

unsigned short
					iTemp,
					iTemp11,
					iTemp21,
					iTemp31,
					iTemp41,
					iTemp12,
					iTemp22,
					iTemp32,
					iTemp42;

signed short							// 16 bit signed integer variables
					iYear,				// Current date
					iYearFT,
					iYearInit,
					iMonth,
					iMonthFT,
					iMonthInit,
					iDay,
					iDayFT,
					iDayInit;

unsigned long							// 32 bit unsigned variables
					iDeg180,			// xxx degs in encoder pulses as a 32 bit unsigned integer
					AziSun,				// Sun's Azimuth position in encoder pulses
					AltSun;				// Sun's Altitude position in encoder pulses

signed long								// 32 bit signed variables
					liTemp1,
					liTemp2,
					liTemp3,
					liAux1,
					liAux2;

double									// 32 bit floating point variables
					dClockCal,			// 32.768 xtal calibration factor
		 			dSeconds1,			// first pass seconds
		 			dHours,				// TOD variables
					dHoursFT,
					dMinutes,
					dMinutesFT,
		 			dSeconds,
					dSecondsFT,
					dTimeZone,
					dDayLightSaving,
					dJulianErrorPerDay,

		 			dDecimalHours,		// other time variables
					dDecimalHoursPC,
					dDecimalHoursRTCC,
					dDecimalHoursInit,
		 			dElapsedJulianDays,
					dJulianDate,
					dJulianDateInit,
					dJulianDateRTCC,
					dJulianDatePC,
					dJulianDateDiff,
					dJulianDateError,
								
		 			dLongitude,			// Site Longitude in decimal degrees from PC upload
		 			dLatitude,			// Site Latitude in decimal degrees from PC upload
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


void GetSunPos (void)						// SunCube Solar Position Calculator (SSPC)
{
// Calculate difference in days between the current Julian Day 
// and JD 2451545.0, which is noon 1 January 2000 Universal Time

    _DOZEN = 0;							// speed up to 4 MIPS

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

// Finally the suns position is known to +- 0.00833 deg (30 sec of arc)
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

// Finally the suns position is known to +- 0.00833 deg (30 sec of arc)
// Now we convert to motor encoder pulses so we can drive the
// SunCube to track the sun even under thick clouds!

/*
	AziSun = (dDeg360-1) * (dAzimuth / 360.0);				// convert 64 bit double solar azimuth to integer AziEnc value
	iDeg180 = dDeg180;										//

	if (AziSun >= iDeg180)									// test if AziSun is East
	 AziSun = (AziSun - iDeg180);
	else
	 AziSun = (AziSun + iDeg180);

	AltSun = (dDeg360-1) * ((90.0 - dZenithAngle) / 360.0);	// convert 64 bit double solar zenith angle to integer AltEnc value

	if (AltSun >= iDeg180)									// test if the sun is below the horizon
	 AltSun = (90.0 - dZenithAngle) * dDeg001;
*/

    _DOZEN = 1;												// drop down to 31.25 kIPS

} // end GetSunPos


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

		3 B7 (Cw)
		2 B8 (Cc)
		1 B9 (Up)
		0 A6 (Dn)
*/

 SwBits  = (Cw << CwBit);		 	// set 3:1	// Cw switch
 SwBits += (Cc << CcBit);			// set 2:1	// Cc switch
 SwBits += (Up << UpBit); 			// set 1:1	// Up switch
 SwBits += (Dn << DnBit); 			// set 0:1	// Dn switch

 _RA1 = (SwBits != 0x0f);   		// if any switch = 0 let the F88 know

} // end GetHJStaus


void DelayMs( unsigned short t)
{
 _T1MD = 0;						// enable power to Timer 1
 T1CON = 0x8000;     			// enable Timer 1, Tcy, 1:1

 while (t--)					// dec ms to delay counter
 {
  TMR1 = 0;						// clear T1
  while (TMR1<4000); 			// 8 mhz clock / 2 = 4k counts / msec
 } // end while loop

 T1CON = 0;						// disable T1 to save power
 _T1MD = 1;						// disable power Timer 1

} // Delayms


// initialize the UART1 serial port
void initU1 (void)
{
 _U1MD   = 0;					// turn U1 power on
 DelayMs(10);					// give it a bit if time to wake up

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
 while (U2STAbits.UTXBF);   			// wait while Tx buffer full
 U2TXREG = c;

} // end putU2
										// wait for a new character to arrive to the UART2 serial port

// wait for a valid new character to arrive to the UART1 serial port

unsigned char getU1 (void)
{

badU1rcv: 								// yup a branch, I know, lazy programming

 while (!U1STAbits.URXDA);				// wait for a char to arrive

 if (U1STAbits.FERR)
 {
  Rd1 = U1RXREG;						// flush framing error byte from rcv queue
  goto badU1rcv;						// goto wait for the next real char
 }

 return (U1RXREG);							// read the character from the receive buffer

}// end getU1


unsigned char getN1 (void)
{

 Rd2 = getU1();							// get U1 char

 if ((Rd2 & 0xf0) == 0x30)				// test if it is numeric
  return(Rd2);							// yes it is numeric so return it
 else
  while (true);							// no it is not numeric so hang

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


void GetTime (void)
{
 dHours = ((getN1() & 0x0f) * 10.0);
 dHours += (getN1() & 0x0f);

 getU1();									// skip ':'

 dMinutes = ((getN1() & 0x0f) * 10.0);
 dMinutes += (getN1() & 0x0f);

 getU1();									// skip ':'

 dSeconds = ((getN1() & 0x0f) * 10);
 dSeconds += (getN1() & 0x0f);

 getU1();									// skip '.'

 dSeconds += ((getN1() & 0x0f) * 0.1);
 dSeconds += ((getN1() & 0x0f) * 0.01);

} // end GetTime


void GetPCTimeandCoords (void)
{
// get longitude input

 CommsOK = false;
 NoComms = false;

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'A')						// test for 'A'
 {
  Rd1 = getU1();							// save sign

  if (Rd1 != '+')
   if (Rd1 != '-')
    while (true);						   	// hang if not signed
 
  dLongitude = ((getN1() & 0x0f) * 100.0);
  dLongitude += ((getN1() & 0x0f) * 10.0);
  dLongitude += (getN1() & 0x0f);

  getU1();									// skip '.'

  dLongitude += ((getN1() & 0x0f) * 0.1);
  dLongitude += ((getN1() & 0x0f) * 0.01);
  dLongitude += ((getN1() & 0x0f) * 0.001);
  dLongitude += ((getN1() & 0x0f) * 0.0001);

  if (Rd1 == '-') dLongitude = -dLongitude;

   if (dLongitude > 180.0)
   while (true);							// hang if too big

  if (dLongitude < -180.0)
   while (true);							// hang if too small

 } // END SCA+xxx.xxxx longitude input
 else
  while (true);								// bad input so hang


// get latitude input

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'B')						// test for 'B'
 {
  Rd1 = getU1();							// get sign

  if (Rd1 != '+')
   if (Rd1 != '-')
    while (true);							// hang if bad sign

  dLatitude = ((getN1() & 0x0f) * 100.0);
  dLatitude += ((getN1() & 0x0f) * 10.0);
  dLatitude += (getN1() & 0x0f);

  getU1();									// skip '.'

  dLatitude += ((getN1() & 0x0f) * 0.1);
  dLatitude += ((getN1() & 0x0f) * 0.01);
  dLatitude += ((getN1() & 0x0f) * 0.001);
  dLatitude += ((getN1() & 0x0f) * 0.0001);

  if (Rd1 == '-') dLatitude = -dLatitude;

  if (dLatitude > 90.0) 
   while (true);							// hang if too big

  if (dLatitude < -90.0)
   while (true);							// hang if too small

 } // END SCB+xxx.xxxx latitude input
 else
  while (true);								// hand if bad input


// get daylight savings and time zone input

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'C')
 {
  if (getN1() == '0') 
   dDayLightSaving = 0.0;
  else
   dDayLightSaving = 1.0;

  getU1();									// skip ':'

  Rd1 = getU1();							// get time zone sign

  if (Rd1 != '+')
   if (Rd1 != '-')
    while (true);						   	// hang if not signed

  dTimeZone = ((getN1() & 0x0f) * 10.0);
  dTimeZone += (getN1() & 0x0f);

  dTemp = ((getN1() & 0x0f) * 10.0);
  dTemp += (getN1() & 0x0f);

  dTimeZone += (dTemp / 60.0); 

  if (Rd1 == '-') dTimeZone = -dTimeZone;

 } // END SCCd:+zzzz input (d = daylight savings, zzzz = time zone value
 else
  while (true);								// hand if bad input

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'D')
 {
  iYear = ((getN1() & 0x0f) * 1000);
  iYear += ((getN1() & 0x0f) * 100);
  iYear += ((getN1() & 0x0f) * 10);
  iYear += (getN1() & 0x0f);
  iYearFT = iYear;

  getU1();									// skip ':'

  iMonth = ((getN1() & 0x0f) * 10);
  iMonth += (getN1() & 0x0f);
  iMonthFT = iMonth;

  getU1();									// skip ':'
 
  iDay = ((getN1() & 0x0f) * 10);
  iDay += (getN1() & 0x0f);
  iDayFT = iDay;

 } // END SCDYYYY:MM:DD input
 else
  while (true);								// bad input so hang


// get 1st time input

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'E')
 {
  GetTime();

 } // end 1st SCEHH:MM:SS.SS, 2nd arrives in 5 seconds
 else
  while (true);								// hand if bad input


// get 2nd time input

 Rd1 = ' ';
 while (Rd1 != 'S') Rd1 = getU1();			// look for 'S' as first char of input stream
 if (getU1() != 'C') while (true);			// get 'C' or hang
 if (getU1() == 'E')
 {
  GetTime();
  getU1();									// get training delimiter
  iClockCal = 0;
  CommsOK = true;

 } // end 2nd SCCHH:MM:SS.SS input
 else
  while (true);								// hang if bad input

} // end GetPCTimeandCoords


void initRTCC (void)
{   
	__builtin_write_RTCWEN ();				// _RTCWREN = 1
    _RTCEN = 0;         					// disable the clock

// set initial date and time

    _RTCPTR = 3;

	iTemp = hex2bcd (iYear - 2000);			// YEAR 0-99
	RTCVAL = iTemp;

    iTemp = (hex2bcd (iMonth - 1) << 8) 
          + hex2bcd (iDay - 1);				// MONTH-1/DAY-1
	RTCVAL = iTemp;

    iTemp = hex2bcd (dHours);				// WEEKDAY/HOURS
	RTCVAL = iTemp;

    iTemp = (hex2bcd (dMinutes) << 8)
		  + (hex2bcd (dSeconds)); 	 		// MINUTES/SECONDS
	RTCVAL = iTemp;

	_CAL = iClockCal;  						// calibrate the xtal error

// lock and enable 

    _RTCEN = 1;         					// start the RTCC counters
	_RTSECSEL = 1;							// select RTCC as output
	_RTCOE = 1;								// enable RTCC 1 second output on B14
    _RTCWREN = 0;       					// disable write enable to lock settings

} // end initRTCC


void readRTCC (void)
{
 // get current date and time

readagain:

 _RTCPTR = 3;
 iTemp11 = RTCVAL;
 iTemp21 = RTCVAL;
 iTemp31 = RTCVAL;
 iTemp41 = RTCVAL;

 _RTCPTR = 3;
 iTemp12 = RTCVAL;
 iTemp22 = RTCVAL;
 iTemp32 = RTCVAL;
 iTemp42 = RTCVAL;

 if (iTemp11 != iTemp12) goto readagain;
 if (iTemp21 != iTemp22) goto readagain;
 if (iTemp31 != iTemp32) goto readagain;
 if (iTemp41 != iTemp42) goto readagain;

 iYear = bcd2hex(iTemp12 & 0x00ff) + 2000;

 iMonth = 1 + (bcd2hex (iTemp22 >> 8));
 iDay = 1 + (bcd2hex (iTemp22 & 0x00ff));

 dHours = bcd2hex(iTemp32 & 0x00ff);

 dMinutes = bcd2hex(iTemp42 >> 8);
 dSeconds = bcd2hex(iTemp42 & 0x00ff);

 iClockCal = _CAL;

} // end read RTCC


void AdjustTimeDrift (void)
{
 AdjTimeOK = false;
 
 liAux1 = (iMonth - 14) / 12;
 liAux2 = (1461 * (iYear + 4800 + liAux1)) 
 		/ 4 + (367 * (iMonth -2 -12 * liAux1)) 
 		/ 12 - (3 * ((iYear + 4900 
 		+ liAux1) / 100)) / 4 + iDay - 32075;
 dDecimalHoursPC = dHours + ((dMinutes + (dSeconds / 60.0)) / 60.0);	 	// PC decimal time
 dJulianDatePC = (double)(liAux2) - 0.5 + dDecimalHoursPC / 24.0;			// PC Julian date
 
 iYearFT = iYear;											
 iMonthFT = iMonth;
 iDayFT = iDay;
 dHoursFT = dHours;
 dMinutesFT = dMinutes;
 dSecondsFT = dSeconds;														// save latest PC tod for later update of RTCC
 
 readRTCC();																// get latest RTCC time
 
 liAux1 = (iMonth - 14) / 12;
 liAux2 = (1461 * (iYear + 4800 + liAux1)) 
 		/ 4 + (367 * (iMonth -2 -12 * liAux1)) 
 		/ 12 - (3 * ((iYear + 4900 
 		+ liAux1) / 100)) / 4 + iDay - 32075;
 dDecimalHoursRTCC = dHours + ((dMinutes + (dSeconds / 60.0)) / 60.0);		// RTCC decimal time 
 dJulianDateRTCC = (double)(liAux2) - 0.5 + dDecimalHoursRTCC / 24.0;		// RTCC Julian date
 
 dJulianDateDiff = dJulianDatePC - dJulianDateInit;							// calc hours since original PC time upload
 dJulianDateError = dJulianDatePC - dJulianDateRTCC;						// calc RTCC time error, + = clock too slow
 
 dJulianErrorPerDay = (dJulianDateError / dJulianDateDiff);	 				// calc clock error rate per day
 dX = ((dJulianErrorPerDay * dClocksPerDay) / 1440.0 ) / 4.0;				// calc xtal adjust value per minute
 
 iYear = iYearFT;
 iMonth = iMonthFT;
 iDay = iDayFT;
 dHours = dHoursFT;
 dMinutes = dMinutesFT;
 dSeconds = dSecondsFT;														// restore PC tod to update RTCC
 
 if (dX > 127.0)															// test if > max value
  iClockCal = 127;															// yes so set to max value
 else
 if (dX < -128.0)															// test if < min value
  iClockCal = -128;															// yes so set to min value
 else
 {
  iClockCal = dX;															// time adj value in range so use it
  AdjTimeOK = true;															// flag time adj range was ok
 }

 initRTCC();																// update TOD and clock drift rate
 
} // end AdjustTimeDrift


/*
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
*/


void GetFTSunPos (void)
{
 iYear = iYearFT;
 iMonth = iMonthFT;
 iDay = iDayFT;
 dHours = dHoursFT;
 dMinutes = dMinutesFT;
 dSeconds = dSecondsFT;
 GetSunPos();

} // end GetFTSunPos


void InitFT (void)
{
 dHoursFT = 0.0;
 dMinutesFT = 0.0;
 dSecondsFT = 0.0;						// set start time

 GetFTSunPos();							// get the sun coords
 while (dAltitude < 0.0)	
 {
  dHoursFT++;							// inc hours until sun is up
  GetFTSunPos();
 }
 dHoursFT--;							// back off 1 hour
 if (dHoursFT > 23)
  dHoursFT = 23.0;

 GetFTSunPos();							// get the sun coords
 while (dAltitude < 0.0)
 {
  dMinutesFT++;							// inc minutes until sun is up
  GetFTSunPos();
 }
 dMinutesFT--;							// back off 1 minute
 if (dMinutesFT > 59.0)
  dMinutesFT = 59.0;

 GetFTSunPos();							// get first FT wake up sun pos

} // end InitFT


void IncFTTOD (void)
{
 dSecondsFT += 15.0;					// inc FT time in 15 second jumps
 if (dSecondsFT > 59.0)
 {
  dSecondsFT = 0.0;
  dMinutesFT++;
 }

 if (dMinutesFT > 59.0)
 {
  dMinutesFT = 0.0;
  dHoursFT++;
 }

 GetFTSunPos();							// get our next FT sun pos
 if (dAltitude <= 0.0)					// test if the sun has set
  InitFT();								// yes so get the wake up sunpos

} // end IncFTTOD


void SendF88 (unsigned char c)
{
 while (U2STAbits.URXDA) getU2();		// purge any old F88 requests

getagain:

 _RA1 = 1;								// tell F88 we have data for it
 while (!U2STAbits.URXDA);				// wait for F88 status request
 _RA1 = 0;								// drop request line							

 if (getU2() != 'H')					// did we get a 'H' from the F88
  goto getagain;						// no so wait for it
										// get status request byte from F88
 putU2(c);								// send Cmd byte to F88
 while (U2STAbits.URXDA) getU2();		// purge any old F88 requests

} // end Send F88


void WaitCommCableRemoved (void)
{
 while ((Up+Dn+Cw+Cc) != 4)				// test for all switch lines to be high
  DelayMs(250);							// delay until RS232 cable unplugged
 DelayMs(250);							// delay some more to be sure
 while (U2STAbits.URXDA) getU2();		// purge any F88 requests

} // end WaitCommCableRemoved


int main (void)
{
// port initialization
 
 AD1PCFG = 0xffff;						// all analogue pins to digital

 PORTA = 0x0000;						// set initial port A
 TRISA = 0xfffc;						// set portA directions, 1 = in
 
 PORTB = 0x0000;						// set initial port B
 TRISB = 0xbffe;						// set portB directions, 1 = in
 

/*
 iYear = 2010;							// SunPos debugging input
 iMonth = 11;
 iDay = 6;
 dHours = 09.0;
 dMinutes = 56.0;
 dSeconds = 16.90;
 dLatitude = 017.4493;
 dLongitude = 073.8459;
 dDayLightSaving = 0.0;
 dTimeZone = 5.5;
 GetSunPos();

 while (true);
*/

// enable 32.768 kHz oscillator & RTCC to keep time

 __builtin_write_OSCCONL ( 0x02 ); 		// SOSCEN = 1
 DelayMs(100);							// delay 100 ms so SOSC can stablize

 iClockCal = 0;							// zero initial clock cal value
 initRTCC();							// do initial RTCC setup


// set initial variables

 FstTrk = false;
 NoComms = true;

// set pullups for switches

 _CN23PUE = 1;							// pullup for B7/Cw switch
 _CN22PUE = 1;							// pullup for B8/Cc switch
 _CN21PUE = 1;							// pullup for B9/Up switch
 _CN8PUE  = 1;							// pullup for A6/Dn switch

 DelayMs(100);							// delay to let lines pullup
 
 if ((Up+Dn) == 2) goto bypasspc;		// Test if comms cable NOT plugged in (B9 & A6 high) prior to power on
 										// if so we bypass PC input and just service the hand controller
 
// turn off pullups for switches
 
 _CN23PUE = 0;							// pullup for B7/Cw switch
 _CN22PUE = 0;							// pullup for B8/Cc switch
 _CN21PUE = 0;							// pullup for B9/Up switch
 _CN8PUE  = 0;							// pullup for A6/Dn switch
 
 DelayMs(100);							// delay to let lines pullup
 
 
// get setup data from the PC & update RTCC
 
 initU1();								// initialize U1 to get data from the PC
 DelayMs(10);
 
 GetPCTimeandCoords();					// get setup data from the PC
 initRTCC();							// setup RTCC with PC's time and date
 
 dDecimalHoursInit = dHours + ((dMinutes + (dSeconds / 60.0)) / 60.0);	// save initial upload time 

 liAux1 = (iMonth - 14) / 12;
 liAux2 = (1461 * (iYear + 4800 + liAux1)) 
		/ 4 + (367 * (iMonth -2 -12 * liAux1)) 
		/ 12 - (3 * ((iYear + 4900 
		+ liAux1) / 100)) / 4 + iDay - 32075;
 dJulianDateInit = (double)(liAux2) - 0.5 + dDecimalHours / 24.0;		// save initial Julian date

 iYearInit = iYear;						//
 iMonthInit = iMonth;					//
 iDayInit = iDay;						// save initial up load date
 
 DelayMs(250);
 DelayMs(250);
 DelayMs(250);							// 0.75 sec delay to eliminate any trailing serial data
 U1MODE = 0x0000;						// as we are done with U1 disable it
 U1STA 	= 0x0000;						//
 
 
bypasspc:
 
 initU2();								// set up U2 serial port for comms from F88
 DelayMs(10);							// let comm lines stabilize
 
 if (CommsOK == 1)						// if we did a good initial comms upload
  SendF88(0x8f);						// move SC up&dn after comms upload to show comms upload was ok
 
 
// set pullups for switches
 
 _CN23PUE = 1;							// pullup for B7/Cw switch
 _CN22PUE = 1;							// pullup for B8/Cc switch
 _CN21PUE = 1;							// pullup for B9/Up switch
 _CN8PUE  = 1;							// pullup for A6/Dn switch

 DelayMs(100);							// delay to let lines pullup
 

// wait for the RS232 cable to be unplugged 

 WaitCommCableRemoved();				// wait for comms cable to be removed or all hand controller switches off

 if (CommsOK == 1)
  SendF88(0x8f);						// move SC up&dn to show we know the comms cable was removed


// select which peripherals we need, disable = 1

 _T3MD   = 1;
 _T2MD   = 1;
 _T1MD   = 1;							// we do turn it on for ms delay loop
 _I2C1MD = 1;
 _U2MD   = 0;							// enable Uart 2
 _U1MD   = 1;
 _SPI1MD = 1;
 _ADC1MD = 1;
 _IC1MD  = 1;
 _OC1MD  = 1;
 _CMPMD  = 1;
 _RTCCMD = 0;							// enable RTCC
 _CRCPMD = 1;
 _EEMD   = 1;
 _REFOMD = 1;
 _CTMUMD = 1;
 _HLVDMD = 1;


// setup doze clock to 31.25 kIPS and switch to it

 _DOZE2 = 1;
 _DOZE1 = 1;
 _DOZE0 = 1;							// set doze clock to 1:128 or 31.25 kIPS

 _DOZEN = 1;							// cpu to 31.25 kIPS to save power


// start main loop

 while (true)
 {
  if ((Up+Dn) == 0)						// test for Comms cable insertion
  {
   _DOZEN = 0;							// cpu to 4 MIPs
   initU1();							// initialize U1 to get data from the PC
   DelayMs(10);
   SendF88(0x8f);						// move SC up&dn to show we saw comms cable plugged in

   GetPCTimeandCoords();				// get what the PC wants to send us

   U1MODE = 0x0000;						// as we are done with U1, so disable it
   U1STA = 0x0000;						//
   _U1MD = 1;							// power down U1
 
   if (CommsOK == 1)
   {
    SendF88(0x8f);						// move SC up&dn after comms upload to show comms upload was ok
    AdjustTimeDrift();					// adjust the RTCC for clock / time drift
    if (AdjTimeOK == 1)					// was the time adjustment range ok?
     SendF88(0x8f);						// move SC up&dn to show time adj was ok
   } // end time adj

   WaitCommCableRemoved();				// wait for the comms cable to be removed
   SendF88(0x8f);						// move SC up&dn to show comms cable unplugged
   _DOZEN = 1;							// cpu to 31.25 kIPS to save power
  } // end test for comms cable plugged in

  GetHJStatus();						// update HJ switch status & request line to F88

/*
  if ((Up+Cc) == 0)						// test for fast track HJ request
   {
    FstTrk = true;						// set FT flag
    SendF88(0x8f);						// move SC up&down to show FT
    SendF88(0x4f);						// tell the F88 we are in Fast Track
   } // end initialize fast track
*/

  if (U2STAbits.URXDA)					// test for request from the F88
  {  
   Rd2 = getU2();  						// get F88 request byte
											
/*   if (Rd2 == 'I')					// we are in FT and the F88 jumper was removed
   { 
    InitFT();							// so initialize the FT time
   }
   else
*/
 
   if (Rd2 == 'T')						// test if sun pos requested
   {

/*    if (FstTrk)						// test if we are in Fast Track
    {
     IncFTTOD();						// inc FT time
     GetFTSunPos();						// calc FT sun position
    } // end FT sunpos

   else
   {
*/  
    readRTCC();							// get time & date from RTCC
    GetSunPos();						// calc sun position

    if (NoComms == 1)					// test if we never did a PC upload and are in initial install mode
    {									// yes so sent sunpos of Sun at equator and the horizon
     AziSun = 1;						// make AziSun = 1
     AltSun = 1;						// make AltSun = 1
     dLatitude = 1.0;					// make dLatitude North
    }

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
   else
   if (Rd2 == 'H')						// test if HJ update requested
   {
    DelayMs(2);							// 2 ms delay for F88 to get ready for data
    putU2(SwBits);						// send HJ switch status to F88
   } // end HJ send
  } // end char received
 } // end while true

 return(0);								

} // end main

