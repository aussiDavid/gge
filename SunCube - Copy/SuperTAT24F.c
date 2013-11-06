
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


int main (void){
// port initialization
/* 
 AD1PCFG = 0xffff;						// all analogue pins to digital

 PORTA = 0x0000;						// set initial port A
 TRISA = 0xfffc;						// set portA directions, 1 = in
 
 PORTB = 0x0000;						// set initial port B
 TRISB = 0xbffe;						// set portB directions, 1 = in
*/

int i = 0;
while(i < 10){
	i++;
}

TRISB = 0;		//set PORTB as output
PORTB = 0x00;	//set PORTB bits to 1 (0xFF == 11111111 base 2)

unsigned char ctr = 0;
for(;;){
	PORTB = ctr;
	ctr++;
	if(ctr == 8)
		ctr = 0;
}
/*
asm
{
	MOVLW	6	//load W with 6
}


LOOP:
	BTSS	PORTB,1;
	goto	portBis0;
	bsf		POSTA,3;
	nop;
	goto	LOOP;
portBis0:
	bcf		PORTA,3;
	goto	LOOP;
 */
return 0;

} // end main

