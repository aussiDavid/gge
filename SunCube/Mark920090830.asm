
;***********************************************************************;
;                            Mark9.ASM			;
;                                                           	;
;                    SunCube Solar PV Firmware              	;
;                                                       		;
;    This program & the system design of the SunCube are copyright     	;
;                            Greg Watson        	            ;
;                     2005 2006 2007 2008 2009              	;
;                                                                      	;
;                        All rights reserved                           	;
;***********************************************************************;

;-----------------------------------------------------------------------
; Set up for CPU type & power on configuration
;-----------------------------------------------------------------------

	LIST P=PIC16f88,R=DEC,f=INHX32

	#include p16f88.inc

;-- Program Configuration Register 1 --

	__CONFIG    _CONFIG1,_CP_ALL & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_ALL & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_IO

;-- Program Configuration Register 2 --

	__CONFIG    _CONFIG2,_IESO_OFF & _FCMEN_OFF

;-----------------------------------------------------------------------
; Program creation date and version
;-----------------------------------------------------------------------

#define 	Version				"SunCube Firmware Ver 20090605a, "
#define 	CopyRight 				"Patents in progress, Copyright(C) Greg Watson 2005-2009. All rights reserved."

;-----------------------------------------------------------------------
; Memory constants
;-----------------------------------------------------------------------

ram0	equ	0x0020			;start of bank 0 ram
ram1	equ	0x00A0			;start of bank 1 ram
ramint	equ	0x0070			;start of bank insensitive ram
EeData0	equ	0x2100			;start of ee data memory

;-----------------------------------------------------------------------
; Movement constants
;-----------------------------------------------------------------------

MRatio	equ	100			;motor planetary gear box ratio
SRatio	equ	100			;suncube worm gear ratio
FRatio	equ	MRatio*SRatio		;final gear ratio
PPR	equ	14			;encoder pulse edges per motor rev

Deg360	equ	FRatio*PPR			;pulses per 360 deg movement
Deg180	equ	Deg360/(3600/1800)		;pulses per 180 deg movement
Deg150	equ	Deg360/(3600/1500)		;pulses per 150 deg movement
Deg120	equ	Deg360/(3600/1200)		;pulses per 120 deg movement
Deg90	equ	Deg360/(3600/900)		;pulses per 90 deg movement
Deg75	equ	Deg360*10/(36000/750)		;pulses per 75 deg movement
Deg60	equ	Deg360/(3600/600) 		;pulses per 60 deg movement
Deg45	equ	Deg360/(3600/450)		;pulses per 45 deg movement
Deg40	equ	Deg360/(3600/400)		;pulses per 40 deg movement
Deg30	equ	Deg360/(3600/300)		;pulses per 30 deg movement
Deg25	equ	Deg360*10/(36000/250)		;pulses per 25 deg movement
Deg20	equ	Deg360*10/(36000/200)		;pulses per 20 deg movement
Deg15	equ	Deg360*10/(36000/150)  		;pulses per 15 deg movement
Deg11	equ	Deg360*10/(36000/110)		;pulses per 11 deg movement
Deg10	equ	Deg360*10/(36000/100) 		;pulses per 10 deg movement
Deg340	equ	Deg360-Deg20		;pulses per 340 deg movement

Deg7.5	equ	Deg360*10/(36000/75)		;pulses per 7.5 deg movement
Deg5.0	equ	Deg360*10/(36000/50)		;pulses per 5.0 deg movement
Deg4.0	equ	Deg360*10/(36000/40)		;pulses per 4.0 deg movement
Deg3.6	equ	Deg360*10/(36000/36)		;pulses per 3.6 deg movement
Deg3.0	equ	Deg360*10/(36000/30)		;pulses per 3.0 deg movement
Deg2.5	equ	Deg360*10/(36000/25)		;pulses per 2.5 deg movement
Deg2.0	equ	Deg360*10/(36000/20)		;pulses per 2.0 deg movement
Deg1.5	equ	Deg360*10/(36000/15)		;pulses per 1.5 deg movement
Deg1.0	equ	Deg360*10/(36000/10)		;pulses per 1.0 deg movement

Deg0.75	equ	Deg360/(36000/75)		;pulses per 0.75 deg movement
Deg0.50	equ	Deg360/(36000/50)		;pulses per 0.5 deg movement
Deg0.40	equ	Deg360/(36000/40)		;pulses per 0.4 deg movement
Deg0.30	equ	Deg360/(36000/30)		;pulses per 0.3 deg movement
Deg0.25	equ	Deg360/(36000/25)		;pulses per 0.25 deg movement
Deg0.20	equ	Deg360/(36000/20)		;pulses per 0.2  deg movement
Deg0.15	equ	Deg360/(36000/15)		;pulses per 0.15 deg movement
Deg0.125	equ	Deg360/(360000/125)		;pulses per 0.125 deg movement
Deg0.10	equ	Deg360/(36000/10)		;pulses per 0.1 deg movement
Deg0.06	equ	Deg360/(36000/06)		;pulses per 0.06 deg movement
Deg0.05	equ	Deg360/(36000/05)		;pulses per 0.05 deg movement
Deg0.04	equ	Deg360/(36000/04)		;pulses per 0.04 deg movement
Deg0.03	equ	Deg360/(36000/03)		;pulses per 0.03 deg movement
Deg0.02	equ	Deg360/(36000/02)		;pulses per 0.02 deg movement
Deg0.01	equ	Deg360/(36000/01)		;pulses per 0.01 deg movement
Deg0	equ	0

DegAdj	equ	34			;Deg adj
DegT1	equ	DegAdj*Deg1.0
DegT2	equ	DegAdj*Deg2.0
DegT5	equ	DegAdj*Deg5.0
DegT10	equ	DegAdj*Deg10
DegT15	equ	DegAdj*Deg15
DegT16	equ	(DegAdj*Deg15)+(DegAdj*Deg1.0)
DegT20	equ	DegAdj*Deg20
DegT180	equ	DegAdj*Deg180
DegT360	equ	DegAdj*Deg360
Degx360	equ	DegAdj*(Deg360-32)

FstAzi	equ	Deg0
TATAziX	equ	DegAdj*FstAzi
TATAziI	equ	TATAziX/65536

FstAlt	equ	Deg75-Deg5.0
TATAltX	equ	DegAdj*FstAlt
TATAltI	equ	TATAltX/65536

Deg270	equ	Deg180+Deg90
Deg240	equ	Deg360-Deg120

Max1	equ	low(Deg360-1)
Max2	equ	low((Deg360-1)/256)
Max3	equ	low((Deg360-1)/65536)

NSz	equ	Deg0.20			;size of nudge steps
MNCnt	equ	Deg15/NSz			;max nudge movement in any direction
LockSz	equ	Deg1.0			;min size of SunLock width to be accepted as not an edge lock.
NumBrk	equ	2			;number of encoder pulses +1 to apply reverse rotation (breaking)
HJsCnt	equ	10			;number of small HJ moves before big
SlRtyCnt	equ	4			;number of sunlock retries when we get an edge lock

;looking down, from above yoke with electronics box to left

Cw	equ	1			;moving Cw/left, so dec enc position
Cc	equ	2			;moving Cc/right, so inc enc position

;looking at yoke with electronics box in centre, SunCube pointing to the right

Up	equ	3			;moving Up, so inc enc position
Dn	equ	4			;moving Down, so dec enc position

;-----------------------------------------------------------------------
; Voltage equates
;-----------------------------------------------------------------------

AdcRuv	equ	5000000/256			;adc resolution in micro volts

Vdc30	equ	(30000000/7800)*1000	 	;Vdc after dividers in uv
Adc30V	equ	Vdc30/AdcRuv         		;Adc value
	
Vdc29	equ	(29000000/7800)*1000	 	;Vdc after dividers in uv
Adc29V	equ	Vdc29/AdcRuv         		;Adc value
	
Vdc28	equ	(28000000/7800)*1000	 	;Vdc after dividers in uv
Adc28V	equ	Vdc28/AdcRuv         		;Adc value
	
Vdc27	equ	(27000000/7800)*1000	 	;Vdc after dividers in uv
Adc27V	equ	Vdc27/AdcRuv         		;Adc value
	
Vdc26	equ	(26000000/7800)*1000	 	;Vdc after dividers in uv
Adc26V	equ	Vdc26/AdcRuv         		;Adc value
	
Vdc25	equ	(25000000/7800)*1000	 	;Vdc after dividers in uv
Adc25V	equ	Vdc25/AdcRuv	     	;Adc value

Vdc24	equ	(24000000/7800)*1000 		;Vdc after dividers in uv
Adc24V	equ	Vdc24/AdcRuv	     	;Adc value

Vdc23	equ	(23000000/7800)*1000	 	;Vdc after dividers in uv
Adc23V	equ	Vdc23/AdcRuv	     	;Adc value

Vdc22	equ	(22000000/7800)*1000 		;Vdc after dividers in uv
Adc22V	equ	Vdc22/AdcRuv	     	;Adc value

Vdc21	equ	(21000000/7800)*1000	 	;Vdc after dividers in uv
Adc21V	equ	Vdc21/AdcRuv	     	;Adc value

Vdc20	equ	(20000000/7800)*1000 		;Vdc after dividers in uv
Adc20V	equ	Vdc20/AdcRuv	     	;Adc value

Vdc19	equ	(19000000/7800)*1000	 	;Vdc after dividers in uv
Adc19V	equ	Vdc19/AdcRuv         		;Adc value
	
Vdc18	equ	(18000000/7800)*1000	 	;Vdc after dividers in uv
Adc18V	equ	Vdc18/AdcRuv         		;Adc value
	
Vdc17	equ	(17000000/7800)*1000	 	;Vdc after dividers in uv
Adc17V	equ	Vdc17/AdcRuv         		;Adc value
	
Vdc16	equ	(16000000/7800)*1000	 	;Vdc after dividers in uv
Adc16V	equ	Vdc16/AdcRuv         		;Adc value

Vdc15	equ	(15000000/7800)*1000	 	;Vdc after dividers in uv
Adc15V	equ	Vdc15/AdcRuv         		;Adc value
	
Vdc14	equ	(14000000/7800)*1000	 	;Vdc after dividers in uv
Adc14V	equ	Vdc14/AdcRuv         		;Adc value

Vdc13	equ	(13000000/7800)*1000	 	;Vdc after dividers in uv
Adc13V	equ	Vdc13/AdcRuv         		;Adc value
	
Vdc12	equ	(12000000/7800)*1000	 	;Vdc after dividers in uv
Adc12V	equ	Vdc12/AdcRuv         		;Adc value

Vdc11	equ	(11000000/7800)*1000	 	;Vdc after dividers in uv
Adc11V	equ	Vdc11/AdcRuv         		;Adc value
	
Vdc10	equ	(10000000/7800)*1000	 	;Vdc after dividers in uv
Adc10V	equ	Vdc10/AdcRuv         		;Adc value

Vdc09	equ	(09000000/7800)*1000	 	;Vdc after dividers in uv
Adc09V	equ	Vdc09/AdcRuv         		;Adc value

Vdc08	equ	(08000000/7800)*1000	 	;Vdc after dividers in uv
Adc08V	equ	Vdc08/AdcRuv         		;Adc value

Vdc07	equ	(07000000/7800)*1000	 	;Vdc after dividers in uv
Adc07V	equ	Vdc07/AdcRuv         		;Adc value

Vdc06	equ	(06000000/7800)*1000	 	;Vdc after dividers in uv
Adc06V	equ	Vdc06/AdcRuv         		;Adc value

Vdc05	equ	(05000000/7800)*1000	 	;Vdc after dividers in uv
Adc05V	equ	Vdc05/AdcRuv         		;Adc value

Vdc04	equ	(04000000/7800)*1000	 	;Vdc after dividers in uv
Adc04V	equ	Vdc04/AdcRuv         		;Adc value

Vdc03	equ	(03000000/7800)*1000	 	;Vdc after dividers in uv
Adc03V	equ	Vdc03/AdcRuv         		;Adc value

Vdc02	equ	(02000000/7800)*1000	 	;Vdc after dividers in uv
Adc02V	equ	Vdc02/AdcRuv         		;Adc value

Vdc1.5	equ	(01500000/7800)*1000	 	;Vdc after dividers in uv
Adc1.5V	equ	Vdc1.5/AdcRuv         		;Adc value

Vdc01	equ	(01000000/7800)*1000	 	;Vdc after dividers in uv
Adc01V	equ	Vdc01/AdcRuv         		;Adc value

Vdc0.5	equ	(00500000/7800)*1000	 	;Vdc after dividers in uv
Adc0.5V	equ	Vdc0.5/AdcRuv         		;Adc value

;-----------------------------------------------------------------------
; Sun Lock equates
;-----------------------------------------------------------------------

NCells	equ	9			;normal series connected cells in the SunCube
VAdj	equ	(SCells*100)/NCells		;voltage adjust value for variable number of series cells

;-----------------------------------------------------------------------
; Comm equates
;-----------------------------------------------------------------------

cr	equ	0x0d			;carriage return
lf	equ	0x0a			;line feed
enq	equ	'?'			;initial wake up command
wak	equ	' '			;wake up character

;-----------------------------------------------------------------------
; Timer 1 equates
;-----------------------------------------------------------------------

tius	equ	4			;4 us per T1 count
ticks	equ	65536			;16 bits
maxtime	equ	tius*ticks			;max time from 0x0000 to 0x0000 (262,144 us)
tickval	equ	(maxtime-250000)/tius	 	;value to generate T1 ints every 250ms
ticklos	equ	1			;timer ticks lost before we write the new value
t1low	equ	low(tickval+ticklos)		;preset for TMR1L
t1high	equ	high(tickval+ticklos)		;preset for TMR1H

;-----------------------------------------------------------------------
; T1 timer driven 250 ms heartbeat constants
;-----------------------------------------------------------------------

STPMin	equ	60			;sleep ticks per minute
STPDay	equ	24*60*(60/STPMin)		;sleep ticks per day

TatTmr	equ	TATSec*HbPSec		;heart beats per TAT adjust
WUpPC	equ	HbPSec*STPMin		;wake up pre scaler constant

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	McI	0			;motor current sense input
#define	McIP	PORTA

#define	CvI	1			;solar voltage sense input
#define	CvIP	PORTA

#define	En2	2			;motor encoder power
#define	En2P	PORTA

#define	En3	3			;motor encoder power
#define	En3P	PORTA

#define	MsI	4			;magnetic sensor input, low = magnetic field found
#define	MsIP	PORTA

#define	FsI	5			;jumper input
#define	FsIP	PORTA

#define	CwO	6			;rotate Cw output
#define	CwOP	PORTA
#define	CwOData	b'01001100'

#define	CcO	7			;rotate Cc output
#define	CcOP	PORTA
#define	CcOData	b'10001100'

;                         76543210
#define	AnalA	b'00000011'			;1=analog input
#define	DirA	b'00110011'			;0=output,1=input
#define	IntA	b'00000000'			;initial port A data

#define	EncOn	b'00001100'			;used to turn on encoder power outputs
#define	EncOff	b'00000000'			;used to turn off encoder power outputs

;-----------------------------------------------------------------------
; Port B defines
;-----------------------------------------------------------------------

#define	DnI	0			;down switch, low = switch closed
#define	DnIP	PORTB

#define	Td	0			;transmit data output
#define	TdP	PORTB

#define	Led	0			;led - on = high
#define	LedP	PORTB

#define	UpI	1			;up switch, low = switch closed
#define	UpIP	PORTB

#define	Rd	1			;receive data input
#define	RdP	PORTB

#define	CcI	2			;cc switch, low = switch closed
#define	CcIP	PORTB

#define	Cts	2			;clear to send output
#define	CtsP	PORTB

#define	CwI	3			;cw switch, low = switched closed
#define	CwIP	PORTB

#define	Cd	3			;carrier detect output
#define	CdP	PORTB

#define	UpO	4			;rotate Up output
#define	UpOP	PORTB
#define	UpOData	b'00010000'

#define	DnO	5			;rotate DOWN output
#define	DnOP	PORTB
#define	DnOData	b'00100000'

#define	AltE	6			;encoder pulses from the Altitude motor
#define	AltEP	PORTB

#define	AziE	7			;encoder pulses from the Azimuth motor
#define	AziEP	PORTB

;                         76543210
#define	DirBHj	b'11001111'			;0=output,1=input
#define	DirBCom	b'11000010'			;0=output,1=input
#define	IntBHj	b'00000000'			;initial port B data for hand controller
#define	IntBCom	b'00001100'			;initial port B data for Comms with CTS & CD high, TD low
 
#define	SwAnd	b'00001111'			;input switch bits
#define	AziSel	b'10000000'			;select azi encoder pulse
#define	AltSel	b'01000000'			;select alt encoder pulse

;-----------------------------------------------------------------------
; EE Data memory allocations
;-----------------------------------------------------------------------

	org	EeData0			;set start for EE data memory

	de	Version			;store firmware date
	de	TATVer			;store TAT used
	de	CopyRight			;store copyright

E0	de	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0	
	de	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	de	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	de	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0	;32 bytes of test data storage

EeValid	de	0			;EE data memory valid,1 = valid,0 = empty
EeAlt	de	0xaa,0x55,0xaa		;saved alt encoder
EeAzi	de	0x55,0xaa,0x55		;saved azi encoder
EeEnd	de	0

EeMem	equ	255-(EeEnd-EeData0)

;-----------------------------------------------------------------------
; Ram memory allocations
;-----------------------------------------------------------------------

	org	ram0			;variables in ram bank 0

;--------------------------------
; timer loop counters
;--------------------------------

dlyxus	res	1			;us delay loop counter
dlyxms	res	1			;ms delay loop counter
dlyxsec	res	1			;minute delay loop counter

;--------------------------------
; Math variables
;--------------------------------

BB	res	3			;24 bit math input
REMB0	res	1			;divide remainder msb
REMB1	res	1			;divide remainder lsb
LoopCnt	res	1			;divide loop count
LSB	equ	0

;--------------------------------
; Pointing variables
;--------------------------------

AltSky	res	3			;altitude sky point
SAltSky	res	3			;saved AltSky
SAltEnc	res	3			;saved alt encoder
AltI	res	1			;altitude TAT index value
SAltC	res	1			;saved last AltC
AltEnc	res	3			;altitude encoder position 0 - 139,999
MsAlt	res	3			;magnet Alt position

AziSky	res	3			;azimuth sky point
SAziSky	res	3			;saved AziSky
SAziEnc	res	3			;saved azi encoder
AziI	res	1			;azimuth TAT index value
SAziC	res	1			;saved last AziC
AziEnc	res	3			;azimuth encoder position 0 - 139,999
MsAzi	res	3			;magnet Azi position

MoveSz	res	3			;desired encoder movement (0 - 139,999 pulses)
WUpAzi	res	3			;wake up encoder
TmpEnc	res	3			;saved encoder position for edge detection

;------------------------
; Comm variables
;------------------------

baud	res	1			;baud delay loop counter
bitcnt	res	1			;bits to send counter
rcvchr	res	1			;receive character bit rotate buffer
xmtchr	res	1			;send character bit rotate buffer
bcdchr	res	1			;used to pack 2 received ascii into bcd
xmtcnt	res	1			;count of send bytes, used to fire up the Adc during long sends

;------------------------
; time variables
;------------------------

THb	res	1			;track update down counter
WUpM	res	2			;wake up minutes down counter

TodPS	res	1			;tod update pre scaler
WUpPS	res	1			;sleep heart beat pre scaler
HpDwnCnt	res	1			;heart beat down counter
EncDwnCnt	res	1			;encoder inter gap timeout counter

;------------------------
; Motor control variables
;------------------------

MDir	res	1			;motor direction register
EncLst	res	1			;state of encoder pulses at last interrupt
EncSel	res	1			;indicates which encoder pulse should change
SvDir	res	1			;saved original direction
BrkCnt	res	1			;encoder pulses to apply brake for

;------------------------
; Adc variables
;------------------------

SunVdc	res	1			;last value of solar Vdc
TarVdc	res	1			;solar Vdc target
LokVdc	res	1			;min solar Vdc to do a sun lock

;------------------------
; Misc variables
;------------------------

temp	res	1			;
temp1	res	1			;
tempb	res	1			;
tempw	res	1			;temps

OnSunA	res	1			;TAT cycles between on sun updates
Flag0	res	1			;boolean flag byte 0
Flag1	res	1			;boolean flag byte 1
Flag2	res	1			;boolean flag byte 2
SlRty	res	1			;sunlock retry count
HJs	res	1			;small HJ counter
NCnt	res	1			;number of "On Sun" nudge cycles

;leave NCnt as last variable

;--------------------------------
; Interrupt handler variables
;--------------------------------

	org	(ramint+16)-12		;start of bank insensitive ram
sdlyxus	res	1			;saved dlyxus
SFSR	res	1			;saved FSR, only used by 24 bit inc and dec
saveW	res	1			;save W
saveST	res	1			;save STATUS
saveFSR	res	1			;save FSR
savePCL	res	1			;save PCLATH
tempi	res	1			;used in int handler
AltC	res	1			;azimuth track correction
AziC	res	1			;altitude track correction
AA	res	3			;24 bit math input

B0Avil	equ	saveW-NCnt-1		;amount of ram left in bank 0

;--------------------------------
; Checksum variables in bank insensitive ram, used with ints disabled
;--------------------------------

CkSumL	equ	0x7e			;check sum low byte
CkSumH	equ	0x7f			;check sum high byte

;-----------------------------------------------------------------------
; Ran bank 1 equates
;-----------------------------------------------------------------------

	org	ram1

Sv0	res	1
Sv1	res	1
Sv2	res	1
Sv3	res	1
Sv4	res	1
Sv5	res	1			;here we save AA and BB during interrupts

;------------------------
; Tod & time variables
;------------------------

day	res	1
month	res	1
yearhi	res	1
yearlo	res	1

hour	res	1
minute	res	1
second	res	1

dmth	res	12

;-----------------------------------------------------------------------
; Flag0 bit equates
;-----------------------------------------------------------------------

WUpZ	equ	0			;Wake up minutes zero flag
TMs	equ	1			;find mag sensor flag
Doze	equ	2			;flag to indicate are are dozing as we wait for the sun to rise
HJob	equ	3			;flag for Hand Job big motor movement request
MRun	equ	4			;any motor running flag
DoTAT	equ	5			;TAT timer interrupt sets the TAT track adjust flag
NHemi	equ	6			;hemisphere, 1 = North
DoDump	equ	7			;do a diagnostic data dump after every track adjust

;-----------------------------------------------------------------------
; Flag1 bit equates
;-----------------------------------------------------------------------

ResTst	equ	0			;MAltSky and MAziSky need to restore azisky/altsky flag
MsOK	equ	1			;mag sensor detected flag
FastTrk	equ	2			;fast track test mode flag
TATGo	equ	3			;Ok for TAT to run flag
AltCalFin	equ	4			;flag we have done a AltCal recal of the encoders
DoRetro	equ	5			;retro azi movement flag
Locked	equ	6			;got NorVdc SunLock
DidHJ	equ	7			;did HJ flag

;-----------------------------------------------------------------------
; Flag2 bit equates
;-----------------------------------------------------------------------

DidRetro	equ	0			;we did a retro track
DoingTAT	equ	1			;flag we are doing a TAT track adjust
;	equ	2			;
;	equ	3			;
;	equ	4			;
;	equ	5			;
;	equ	6			;
;	equ	7			;

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------

ifBleqA	macro	addr			;sub conditional branch on B<=A
	call	Sub24
	btfss	AA+2,7
	goto	addr
	endm

;----------------------------------------

ifBleqA1	macro	addr			;sub conditional branch on B<=A for bank 1 use
	call10	Sub24
	btfss	AA+2,7
	goto	addr
	endm

;----------------------------------------

ifBgtrA	macro	addr			;sub conditional branch on B>A
	call	Sub24
	btfsc	AA+2,7
	goto	addr
	endm

;----------------------------------------

ifBgtrA1	macro	addr			;sub conditional branch on B>A for bank 1 use
	call10	Sub24
	btfsc	AA+2,7
	goto	addr
	endm

;----------------------------------------

nudgesc	macro	dir			;nudge sc in dir direction
	movlf	dir,MDir			;set direction
	call	Nudge			;move sc
	endm

;----------------------------------------

call10	macro	proc			;call a procedure in bank 1 from bank 0
	bcf	PCLATH,3			;select program bank 0
	call	proc			;call procedure there
	bsf	PCLATH,3			;select program bank 1
	endm

;----------------------------------------

call01	macro	proc			;call a procedure in bank 1 from bank 0
	bsf	PCLATH,3			;select program bank 1
	call	proc			;call procedure there
	bcf	PCLATH,3			;select program bank 0
	endm

;----------------------------------------

SndL	macro	lit			;send literal

	movlw	lit			;load lit to send
	call01	Send8n			;send it
	movlw	','			;load deliminiter
	call01	Send8n			;send it as well
	endm

;----------------------------------------

SndBcd2	macro				;send two packed bcd digits in w

	call	BtoBcd			;get i byte with 2 packed bcds  
	movwf	tempw			;save in temp w
	swapf	tempw,w			;load msb of revs and swap hexades to send left first
	SendR				;send it
	movfw	tempw			;reload to send right hexade
	SendR				;send it
	endm

;----------------------------------------

DlyHB	macro				;delay for 1/2 9600 baud rate (72 us)

	movlf	(104-4)/3,baud		;load delay for 1/2 9600 baud time

	decfsz	baud,f			;dec loop counter & test for zero
	goto	$-1
	endm

;----------------------------------------

DlyB	macro				;delay for 9600 baud rate (104 us)

	movlf	(208-4)/3,baud		;load delay for 9600 baud

	decfsz	baud,f			;dec loop counter & test for zero
	goto	$-1			;no - so do it again
	endm

;----------------------------------------

SendR	macro				;convert nibble in lsb of w into ascii and send it down the line

	andlw	0x0f			;zap w[7:4] to 0 (ms nibble)
	iorlw	0x30			;make it a ascii number by oring in 0x30
	call	Send8n			;send it down the line
	endm

;----------------------------------------

dlylus	macro	lit			;delay for lit ms
	movlw	(lit/2)-1			;set up delay lit in w
	call	DlyWus			;now do the delay
	endm

;----------------------------------------

dlylms	macro	lit			;delay for lit ms
	movlw	lit			;set up delay lit in w
	call	DlyWMs			;now do the delay
	endm

;----------------------------------------

dlylsec	macro	lit
	movlw	lit
	call	DlyWSec
	endm

;--------------------------------

copy24	macro	enc1,enc2			;move encoder data around
	movff	enc1,enc2
	movff	enc1+1,enc2+1
	movff	enc1+2,enc2+2
	endm

;----------------------------------------

movff	macro	regs,regd			;move register regs to regd via w
	movfw	regs			;load source register
	movwf	regd			;save in destination register
	endm

;----------------------------------------

movf0f1	macro	regs,regd			;move register regs to regd via w
	movfw	regs			;load source register in bank 0
	setRP0
	movwf	regd			;save in destination register in bank 1
	clrRP0
	endm

;----------------------------------------

movf1f0	macro	regs,regd			;move register regs to regd via w
	setRP0
	movfw	regs			;load source register in bank 1
	clrRP0
	movwf	regd			;save in destination register in bank 0
	endm

;--------------------------------

movlf	macro	lit,reg			;load literal into register via w
	movlw	lit			;load literal into w
	movwf	reg			;store w into reg
	endm

;--------------------------------

clr24	macro	enc
	clrf	enc
	clrf	enc+1
	clrf	enc+2
	endm

;--------------------------------

set24	macro	deg,enc
	movlf	low(deg),enc
	movlf	low((deg)/256),enc+1
	movlf	low((deg)/65536),enc+2
	endm

;--------------------------------

doio	macro	lit,portadr			;motor line control
	movlf	portadr,FSR			;set up port
	movlw	lit			;set up port output
	call	DoIo			;do it for 5us
	endm

;--------------------------------

movsc	macro	dir,deg
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call	MoveSc			;make it happen
	endm

;--------------------------------

abssc	macro	dir,deg
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call	AbsMSc			;make it happen
	endm

;--------------------------------

Zset	macro
	bsf	STATUS,Z			;set zero flag
	endm

;--------------------------------

Zclr	macro
	bcf	STATUS,Z			;clear zero flag
	endm

;--------------------------------

setGIE	macro
	bsf	INTCON,GIE			;turn on interrupts
	endm

;--------------------------------

clrGIE	macro
	goto	$+1			;2 op delay to clear pre fetch queue
	bcf	INTCON,GIE			;turn off interrupts
	goto	$+1			;2 op delay to clear pre fetch queue
	endm

;--------------------------------

setRP0	macro
	bsf	STATUS,RP0			;set RP0
	endm

;--------------------------------

clrRP0	macro
	bcf	STATUS,RP0			;clr RP0
	endm

;--------------------------------

setRP1	macro
	bsf	STATUS,RP1			;set RP1
	endm

;--------------------------------

clrRP1	macro
	bcf	STATUS,RP1			;clr RP1
	endm

;-----------------------------------------------------------------------
; >>>>>>>>>>>>>>> Power on entry point <<<<<<<<<<<<<<<
;-----------------------------------------------------------------------

	org	0x0000			;power on reset entry point <<<<<<<<<<<<<<<

	goto	Main			;go to start of main code
	goto	$
	goto	$
	goto	$

;-----------------------------------------------------------------------
; The interrupt controller handles
;
;   250ms master timer interrupts
;     Downcounting & setting track update timer THbZ flag on zero THb downcount
;     Downcounting & setting sleep timer WUpZ flag on zero WUpM downcount  
;   Motor encoder pulse interrupts
;     Updating Azimuth & Altitude encoders & MoveSz drive length from motor encoder pulses
;     Turning the motor off when MoveSz goes zero and resetting MRun flag
;   Max stack depth used is 3 including the interrupt. 
;   This means we must limit the main code excecution to no more than 5 nested
;   calls or we will underflow / wrap the stack during interrupt proceesing and lose control
;-----------------------------------------------------------------------

	org	0x0004			;interrupt entry point <<<<<<<<<<<<<<<<<

	movwf	saveW			;save w
	swapf	STATUS,w			;load status into w but in reversed lsb & msb order
	movwf	saveST			;save status flags
	clrf	STATUS			;clear status and select register bank 0
	movff	PCLATH,savePCL		;save PCLATH (we may have been in program bank 1)
	clrf	PCLATH			;clear it to program bank 0

;-- Handle T1 timer interrupt & related down counters --

	btfss	PIR1,TMR1IF			;is this a timer overflow interrupt
	goto	tstpbc			;no so check if encoder interrupt

	movlf	t1low,TMR1L			;load new start value lsb first
	movlf	t1high,TMR1H		;then msb
	bcf	PIR1,TMR1IF			;reset timer overflow flag

;-- save AA and BB in bank 1 -----------------

	nop
	setRP0				;select ram bank 1
	movff	AA,Sv0			;
	movff	AA+1,Sv1			;
	movff	AA+2,Sv2			;AA (in common bank ram) saved

	movf0f1	BB,Sv3			;
	movf0f1	BB+1,Sv4			;
	movf0f1	BB+2,Sv5			;BB saved
	
;-- Handle track heart beat down counter -----

	movf	HpDwnCnt,f			;test if z
	skpz				;yup so skip dec
	decf	HpDwnCnt,f			;dec general purpose HbDwnCnt

	movf	EncDwnCnt,f			;test if z	
	skpz				;yup so skip dec
	decf	EncDwnCnt,f			;dec encoder pulse inter gap EncDenCnt
			
	btfss	Flag1,TATGo			;test if ok to do TAT calcs
	goto	doWUp			;no so skip TAT stuff

	btfsc	Flag1,FastTrk		;test if fast track requested
	goto	doftrk			;yes so do fast track

	decfsz	THb,f
	goto	doWUp			;not zero so just dec it

	movlf	TatTmr,THb			;set num of THbs per TAT update

doftrk
	bsf	Flag0,DoTAT			;set DoTAT flag

;-- get current TAT index and data --

	copy24	AltSky,AA			;load alt sky point to find the alt TAT index
	call	Mult34			;do the multiply to get the 5 deg index in AA+2
	movff	AA+2,AltI			;save raw alt index

	movlw	180/5			;load max alt index +1 (36)
	subwf	AltI,w			;test if alt index is >=36
	skpc				;yes, AltI >=36, so skip
	goto	not36			;no so leave it alone

	movlf	35,AltI			;yup so make it 35

not36
	movlw	90/5			;load max TAT alt index +1 (18)
	subwf	AltI,w			;test if AltI >= 18
	skpc				;yes, AltI >=18, so skip
	goto	calcazi			;yes, so leave it as it is and just branch

	movwf	AltI			;save result of AltI-18
	movlf	(90/5)-1,temp		;store new base adjust value (17)
	movfw	AltI			;reload adjusted AltI
	subwf	temp,w			;do 17-(AltI-18)
	movwf	AltI			;save result of 17-(AltI-18)

;----

calcazi
	copy24	AziSky,AA			;load azi sky point to find the azi TAT index
	call	Mult34			;do the multiply to get the 5 deg index in AA+2
	movff	AA+2,AziI			;save raw azi index (0-72)

	movlw	360/5			;load max azi index +1 (72)
	subwf	AziI,w			;test if azi index is >=72
	skpc				;yes, AziI >=72, so skip
	goto	not72			;no so leave it alone

	movlf	71,AziI			;yup so make it 71

not72
	movlw	180/5			;load max TAT azi index +1
	subwf	AziI,w			;test if AziI >= 36
	skpc				;yes, AziI >=36, so skip
	goto	tatc			;yes, so leave it as it is and just branch

	movwf	AziI			;save result of AziI-36
	movlf	(180/5)-1,temp		;store new base adjust value (35)
	movfw	AziI			;reload adjusted AziI
	subwf	temp,w			;do 35-(AziI-36)
	movwf	AziI			;store final value

;----

tatc
	movff	AziI,AA
	clrf	AA+1
	clrf	AA+2			;load AA with AziI TAT index
	clrf	BB			;
	clrf	BB+1			;
	clrf	BB+2			;clear BB
	call	Mult32			;use x32 multiply to move the AziI index 5 bits left

	movfw	AltI			;load Altitude TAT index
	addwf	AA,f			;add in Altitude TAT index to Azimuth TAT and store
	bsf	AA+1,3			;full TAT index now in AA+2/B1

	bsf	STATUS,RP1			;Bank 2 for EEADRH
	movff	AA,EEADR 			;lsb of program address to read (rb2)
	movff 	AA+1,EEADRH			;msb of program address to read (rb2)
					;
	bsf	STATUS,RP0			;Bank 3 for EECON1
	bsf 	EECON1,EEPGD 		;select program memory (rb3)
	bsf 	EECON1,RD	 		;do read
	nop 				;
	nop				;delay for read data

	bcf	STATUS,RP0			;Bank 2 for EEDATA
	movff 	EEDATA,AziC 		;store lsb as Azimuth TAT correction (rb2)
	movfw 	EEDATH			;load high byte
	andlw	0x3f			;make sure only 6 bits valid
	movwf	AltC	 		;store msb as Altitude TAT correction (rb2)
	bcf	STATUS,RP1			;back to bank 0

	bcf	Flag1,DoRetro		;clear doretro azi movement flag

	if	Retro == 1			;test if TAT has retro movement

	btfss	AltC,5			;test if retro azi movement flag is set
	goto	calti			;no so branch

	bsf	Flag1,DoRetro		;set doretro azi movement flag
	bsf	Flag2,DidRetro		;flag we did a retro track

calti
	bcf	AltC,5			;clear retro flag

	endif				;end conditional retro movement code

;-- calc new altsky --

	set24	(Deg180-1),AA		;load values to test if facing east
	copy24	AziEnc,BB			;
	ifBgtrA	adjalte			;branch if AziEnc>Deg180-1

	copy24	AltSky,AA			;load AA with current sky point
	movff	AltC,BB			;
	clrf	BB+1			;
	clrf	BB+2			;load BB+ with TAT alt adjustment
	call	Sub24			;subtract as the sun drops in the western sky
	goto	adjaltf			;go to save the new sky point

adjalte
	copy24	AltSky,AA			;load AA with current sky point
	movff	AltC,BB			;
	clrf	BB+1			;
	clrf	BB+2			;load BB+ with TAT alt adjustment
	call	Add24			;add as the sun climbs in the eastern sky

adjaltf
	copy24	AA,AltSky			;save new Alt sky point

;-- calc new azisky --

	copy24	AziSky,AA			;load AA with current sky point
	movff	AziC,BB
	clrf	BB+1
	clrf	BB+2			;load BB+ with TAT adjustment

	btfss	Flag1,DoRetro		;test if we need to do a retro track adjust
	goto	noretro2			;no so do normal add to get new azimuth

	call	Sub24			;we are tracking retro so sub to get new azimuth
	goto	retrofin			;finish up new azimuth calc

noretro2
	call	Add24			;add as the sun moves to bigger azi numbers during the day

retrofin
	copy24	AA,AziSky			;save potential new AziSky point

	set24	Deg360,BB			;check if azisky rolled over
	ifBgtrA	doWUp			;branch if Deg360>AziSky

	copy24	AA,AziSky			;store new adjusted and rolled over azisky

;-- Handle wake up down counter ---------

doWUp					;handle sleep delay
	decfsz	WUpPS,f			;dec wake up pre scaler
	goto	dotod			;not zero so go do tod stuff
	movlf	WUpPC,WUpPS			;set wake up pre scaler

	btfsc	Flag0,Doze			;are we dozing & facing East?
	goto	decdoze			;yup so dec the sleep counter

	set24	(Deg180-1),AA		;load values to test if facing east
	copy24	AziEnc,BB			;
	ifBgtrA	dotod			;branch if AziEnc>Deg180-1

	call01	DecWupD			;dec wake up delay by 1 minute
decdoze
	call01	DecWupD			;dec wake up delay by 1 minute			

;-- Handle Tod updater --

dotod
	decfsz	TodPS,f			;dec tod pre scaler
	goto	tmrfin			;not zero so get out of here

	movlf	HbPSec,TodPS		;set tod pre scaler

	call01	UpDTod			;update Tod
	goto	tmrfin			;get out of here

;-- Handle encoder pulse edge input / port B change interrupt --

tstpbc
	movff	dlyxus,sdlyxus		;save external dlyxus

	btfss	INTCON,RBIE			;is the encoder interrupt enabled
	goto	intfin			;no so get out of here
	btfss	INTCON,RBIF			;is it an encoder interrupt?
	goto	intfin			;no so get out of here

	call	CkEnc			;check if valid encoder pulse or noise
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	20			;20 us noise delay
	call	CkEnc			;do it again
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	20			;20 us noise delay
	call	CkEnc			;and again
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	20			;20 us noise delay
	call	CkEnc			;and again
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	20			;20 us noise delay
	call	CkEnc			;one more time for luck
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	movlf	2,EncDwnCnt			;set encoder max inter gap time to max 250 - 500 ms
	movff	FSR,saveFSR			;real encoder pulse, so save FSR and process it

	movfw	MoveSz			;load lsb
	iorwf	MoveSz+1,w			;or in lsb+1
	iorwf	MoveSz+2,w			;or in lsb+2 & test if MoveSz is zero
	skpz				;is movement finished?
	goto	decenc1			;no so go to dec move count

	movf	BrkCnt,f			;test if breaking count > 0
	skpnz				;>0 so skip to dec it
	goto	brkoff			;yes so kill breaking

	decf	BrkCnt,f			;down count breaking pulses
	goto	ckifup			;go to handle encoder update

brkoff
	bcf	Flag0,MRun			;yes so flag move completed

	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on for now
	doio	0,PORTB			;turn off altitude motor

	goto	ckifup			;movement finished but motor still moving, so update encoder position

decenc1
	movlf	MoveSz,FSR			;set pointer to MoveSz
	call01	Dec24			;dec enc pulses to move
	movfw	MoveSz			;load lsb
	iorwf	MoveSz+1,w			;or in lsb+1
	iorwf	MoveSz+2,w			;or in lsb+2 & test if movenc is zero
	skpz				;skip if movement finished
	goto	ckifup			;no, so update encoder

	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on for now
	doio	0,PORTB			;turn off altitude motor

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckdn1			;nope, so check if moving down

	doio	DnOData,DnOP		;turn on reverse Dn drive as a break
	goto	brkdly

ckdn1
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckccw1			;nope, so check if moving ccw

	doio	UpOData,UpOP		;turn on reverse Up drive as a brake
	goto	brkdly

ckccw1
	movlw	Cc
	subwf	MDir,w			;check if moving cc
	skpz
	goto	ckcw1			;nope, so check if moving cw

	doio	CwOData,CwOP		;turn on Cw drive as a break
	goto	brkdly

ckcw1
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	ckifup

	doio	CcOData,CcOP		;turn on Cc drive as a break

brkdly
	movlf	NumBrk,BrkCnt		;break for the next NumBrk + the rest of this encoder pulses

ckifup
	movlf	AltEnc,FSR			;select Alt encoder to work on

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckifdn			;nope, so check if moving down

	call01	Inc24			;inc alt encoder position
	goto	encfin

ckifdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckifcc			;nope, so check if moving cc

	call01	Dec24			;dec alt encoder
	goto	encfin

ckifcc
	movlf	AziEnc,FSR			;select Azi encoder to work on

	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckifcw			;nope, so check if moving cw

	btfss	Flag0,NHemi			;test if Northern hemishpere
	goto	DoInc			;handle southern hemi

DoDec
	call01	Dec24			;dec azi encoder for Cc in northern hemi
	goto	encfin	

DoInc
	call01	Inc24			;inc azi encoder for Cc in southern hemi
	goto	encfin

ckifcw
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	encfin			;nope,we should never get here

	btfss	Flag0,NHemi			;test if Northern hemishpere
	goto	DoDec			;dec Azi encoder for Cw in southern hemi
	goto	DoInc			;inc Azi encoder for Cw in northern hemi

encfin
	movff	sdlyxus,dlyxus		;restore external dlyxus

	btfss	Flag0,TMs			;test if we are looking for the magnet
	goto	tstHj			;no so check if Hj movement and all switches are off
	
	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	dlylus	20			;delay for 20 us as noise filter

	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	dlylus	20			;delay for 20 us as noise filter

	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	dlylus	20			;delay for 20 us as noise filter

	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	bcf	Flag0,TMs			;clear looking for magnet flag

	clr24	MoveSz			;
	incf	MoveSz,f			;set size to 1 to terminate movement on next encoder pulse
	goto	adjenc		

tstHj
	btfss	Flag0,HJob			;is this a HJob movement?
	goto	adjenc			;no so just finish the encoder pulse processing

	call	TSwOff			;test if all switches are off
	skpz				;skip if no switches are on
	goto	adjenc			;switch still on, so let HJ commanded movement continue

	bcf	Flag0,HJob			;no switches on so turn off HJob flag & kill movement
	set24	NSz,MoveSz			;set size to HJ min to terminate movement

adjenc
	movff	PORTB,EncLst		;save current encoder pulse state
	movff	saveFSR,FSR			;reload FSR

errpbc
	movff	sdlyxus,dlyxus		;restore external dlyxus
	bcf	INTCON,RBIF			;clear port B change flag

;-- end specific interrupt handler code --

intfin
	movff	savePCL,PCLATH		;restore PCLATH
	swapf	saveST,w			;load saved status flags
	movwf	STATUS			;restore status flags
	swapf	saveW,f			;swap nibbles to prepare for next nibble swap into w
	swapf	saveW,w			;restore w without effecting status flags
	retfie				;go back to where we came from with interrupts enabled	

tmrfin
	setRP0				;select ram bank 1
	movff	Sv0,AA			;
	movff	Sv1,AA+1			;
	movff	Sv2,AA+2			;AA restored

	movf1f0	Sv3,BB			;
	movf1f0	Sv4,BB+1			;
	movf1f0	Sv5,BB+2			;BB restored

	goto	intfin

;-----------------------------------------------------------------------
; 24 bit integer calculation procedures
;-----------------------------------------------------------------------

AbsDiff					;calc abs(AA-BB)
	copy24	AA,TmpEnc			;save AA
	ifBgtrA	abs1			;do AA-BB, if BB > AA then branch
	return				;AA>=BB so exit with result in AA

abs1
	copy24	BB,AA			;BB > AA so swap
	copy24	TmpEnc,BB			;load old AA
	goto	Sub24			;do sub and exit

;----------------------------------------

Add24					;24 bit add
	movfw	BB			;BB+0,1,2 + AA,1,2. Result in AA,1,2
	addwf 	AA,f			;AA+BB

	movfw	BB+1			;load next byte to add
	skpnc				;skip if no carry
	incfsz 	BB+1,w			;yup so inc BB1 to handle it
	addwf 	AA+1,f			;AA1+BB1
	
	movfw	BB+2			;load next byte to add
	skpnc				;skip if no carry
	incfsz 	BB+2,w			;yup so inc BB2 to handle it
	addwf 	AA+2,f			;AA2+BB2			
	return

;----------------------------------------

Mult.75					;return with AA = AA-(AA/2/2)
	copy24	AA,TmpEnc			;save AA
	call	Div2			;div AA / 2
	call	Div2			;div AA / 2 
	copy24	AA,BB			;save AA / 4 in BB
	copy24	TmpEnc,AA			;reload original AA

;----------------------------------------

Sub24					;24 bit subtract
	movfw 	BB			;AA,1,2 - BB,1,2. Result in AA,1,2
	subwf 	AA,f			;AA-BB

	movfw 	BB+1			;load next byte to sub
	skpc				;skip if no underflow (c)
	incfsz 	BB+1,w			;yup so inc BB1 to handle it
	subwf 	AA+1,f			;AA1-BB1

	movfw 	BB+2			;load next byte to sub
	skpc				;skip if no underflow (c)
	incfsz 	BB+2,w			;yup so inc BB2 to handle it
	subwf 	AA+2,f			;AA2-BB2
	return				;nc = underflow

;----------------------------------------

Mult34					;multiply AA by 34, called by int handler
	copy24	AA,BB
	clrc
	rlf	BB,f
	rlf	BB+1,f
	rlf	BB+2,f			;x2 and save in BB

Mult32					;multiple AA by 32
	clrc				;clear rotate left carry input
	rlf	AA,f
	rlf	AA+1,f
	rlf	AA+2,f			;x2

	rlf	AA,f
	rlf	AA+1,f
	rlf	AA+2,f			;x4

	rlf	AA,f
	rlf	AA+1,f
	rlf	AA+2,f			;x8

	rlf	AA,f
	rlf	AA+1,f
	rlf	AA+2,f			;x16

	rlf	AA,f
	rlf	AA+1,f
	rlf	AA+2,f			;x32

	goto	Add24			;add X2 (BB+0,1,2) + X32 (AA,1,2) value to get X34 (AA,1,2)

;----------------------------------------

Div2					;divide AA by 2
	clrc
	rrf	AA+2,f
	rrf	AA+1,f
	rrf	AA,f
	return

;----------------------------------------
; Delay timer procedures
;----------------------------------------

DlyWus
	movwf	dlyxus			;store delay count

dlyus					;entry for dlylus macro wih delay value in dlyxus, loop time 2us
	nop				;
	decfsz	dlyxus,f			;dec ms count & test for zero
	goto	dlyus			;no - so do it again
	nop				;
	return				;ius exit

;---------------------------------------

Dly1sec
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	movlw	250			;delay for 250ms

;----------------------------------------

DlyWMs					;delay for w * ms
	movwf	dlyxms			;save ms loop count

doxms
	movlf	(2000-10)/8,dlyxus		;load delay 1ms constant

d1ms
	nop				;1 op, 0.5 us
	goto	$+1			;2 ops, 1 us
	goto	$+1			;2 ops, 1 us
	decfsz	dlyxus,f			;dec ms count & test for zero
	goto	d1ms			;no - so do it again

	goto	$+1			;2 ops, 1 us
	decfsz	dlyxms,f			;dec ms count & test for zero
	goto	doxms			;no - so do it again
	return				;yes - so exit

;----------------------------------------

Dly1Min
	movlw	60			;set up for 1 minute delay

DlyWSec	
	movwf	dlyxsec			;delay w seconds

nxtsec
	call	Dly1sec			;wait for 1 second
	decfsz	dlyxsec,f			;count down the seconds
	goto	nxtsec			;not zero yet
	return				;finally we have waited w seconds

;----------------------------------------
; External magnetic sensor reference procedures
;----------------------------------------

FAltMs					;find the alt magnetic sensor magnet
	bcf	Flag1,MsOK			;clr EMPS present flag
	bsf	Flag0,TMs			;set test for mag sensor flag
	abssc	Dn,Deg75			;do absolute Dn movement, which should terminated when alt mag sensor found
	goto	fmsfin

;----------------------------------------

FAziMs					;find the azi magnetic sensor magnet
	bcf	Flag1,MsOK			;clr EMPS present flag
	bsf	Flag0,TMs			;set test for mag sensor flag
	abssc	Cw,Deg150			;do absolute Cw movement, which should terminated when azi mag sensor found

fmsfin
	btfsc	Flag0,TMs			;if mag sensor is found, TMs is reset, so test for this
	goto	flgnms			;branch if no emps found

	bsf	Flag1,MsOK			;set MsOK flag
	return				;it is reset, so exit

flgnms
	bcf	Flag0,TMs			;turn off ck EMPS flag
	bcf	Flag1,MsOK			;clr EMPS ok flag
	return
	
;----------------------------------------
; SunCube sky point control procedures
;--------------------------------------------------

GoAlt0					;drive to alt 0 
	clrGIE				;disable ints
	clr24	AltSky			;set target alt to zero
	call	MAltSky			;make it happen

tstup
	clrGIE
	copy24	AltEnc,AltSky		;update AltSky
	setGIE

	call	TDn			;test if we are pointing down (z)
	skpz				;facing down, so skip
	return				;facing up so exit

	movsc	Up,NSz			;facing down so nudge it up a bit
	goto	tstup			;test if we are up yet

;----------------------------------------

GoAzi0
	clrGIE				;disable ints, MAziSky turns them back on
	clr24	AziSky			;set target azi to 0
	call	MAziSky			;make it happen

tstw
	clrGIE
	copy24	AziEnc,AziSky		;update AziSky
	setGIE

	call	TWest			;test if we are pointing west (z)
	skpnz				;facing east, so skip
	return				;facing west so exit

	movsc	Cc,NSz			;facing east so nudge it west a bit
	goto	tstw			;test if we are west yet

;----------------------------------------

MAziSky					;move the SunCube to AziSky
	clrGIE				;disable ints

	movlf	Cc,MDir			;if AziSky >= AziEnc we move Cc
	copy24	AziSky,AA			;load AziSky to AA
	copy24	AziEnc,BB			;load AziEnc to BB
	ifBleqA mazi1			;branch if AziEnc<=AziSky

	movlf	Cw,MDir			;AziEnc > AziSky so we move Cw
	copy24	AziEnc,AA			;load AziEnc to AA
	copy24	AziSky,BB			;load AziSky to BB
	call	Sub24			;do AziEnc-AziSky

mazi1
	setGIE				;we are finished with AziSky so turn ints back on

	copy24	AA,MoveSz			;save move size & leave it in AA
	set24	Deg180,BB			;set BB to max move size
	ifBgtrA	mazi3			;branch if Deg180>MoveSz
	
	set24	Deg360,AA			;set AA to Deg360
	copy24	MoveSz,BB			;set BB to move size
	call	Sub24			;move too big so do Deg360-MoveSz to get the correct move size
	copy24	AA,MoveSz			;save adjusted move size
	call	SwapCcCw			;swap azi drive direction

mazi3
	movf	MoveSz+2,f			;test if move too small (<64 encoder pulses)
	skpz				;z so check next byte
	goto	mazi4			;nz so move big enough to do

	movf	MoveSz+1,f			;test if nz
	skpz				;z so check next byte
	goto	mazi4			;nz so move big enough

	movfw	MoveSz			;test if big enough
	andlw	0xf0			;is it at least 16 encoder pulses?
	skpz				;requested move is <16 encoder pulses
	goto	mazi4			;move size is not too small
	return				;no so just exit

mazi4
	copy24	MoveSz,AA			;load AA with requested move size
	set24	(Deg180+10),BB		;load BB with max move size + 10
	ifBgtrA	mszok			;branch if MaxMoveSz>MoveSz

	set24	16,MoveSz			;move too big, so limit the error to 16 encoder pulses

mszok	
	goto	MoveSc			;make it happen and jump to MoveSc to save stack depth

;----------------------------------------

MAltSky					;move the SunCube to new alt sky point
	clrGIE				;disable ints

	movlf	Dn,MDir			;AziEnc >= AltSky so we move Dn
	copy24	AltEnc,AA			;load add/sub value
	copy24	AltSky,BB			;load the other value
	ifBleqA	malt1			;branch if AltSky<=AltEnc

	movlf	Up,MDir			;AziEnc < AltSky so we move Up
	copy24	AltSky,AA			;
	copy24	AltEnc,BB			;
	call	Sub24			;do AltSky-AltAzi

malt1
	setGIE				;we are finished with AltSky so turn ints back on

	copy24	AA,MoveSz			;save move size & leave it in AA
	set24	Deg180,BB			;set BB to max move size
	ifBgtrA	mazi3			;branch if Deg180>MoveSz
	
	set24	Deg360,AA			;set AA to Deg360
	copy24	MoveSz,BB			;set BB to move size
	call	Sub24			;move too big so do Deg360-MoveSz to get the correct size move
	copy24	AA,MoveSz			;save adjusted move size

	movlf	7,temp			;swap alt motor directions because of size adjustment
	movfw	MDir			;MDir to w
	subwf	temp,w			;do temp-Mdir
	movwf	MDir			;sub 7-MDir, 7-4 = 3 or 7-3 = 4	

	goto	mazi3			;direction and size adjusted so jump to common exit

;----------------------------------------
; Motor drive & management procedures
;----------------------------------------

CkEnc					;check for a valid encoder pulse, only called by int controller
	movfw	PORTB			;read state of encoder pulses
	andwf	EncSel,w			;isol encoder bit to test
	movwf	tempi			;save it for a moment
	movfw	EncLst			;load last state of encoder pulses
	andwf	EncSel,w			;isol encoder bit to test
	subwf	tempi,w			;test if the proper encoder pulse changed state
	return

;--------------------------------------------------

DoIo					;motor control line setting
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;
	movwf	INDF			;repeat motor control output for 10 us to overcome any capacitor effects
	return

;--------------------------------------------------

SwapCcCw					;swap azi motor drive direction
	movlf	3,temp			;swap azi motor directions for northern hemisphere
	movfw	MDir			;MDir to w
	subwf	temp,w			;do temp-Mdir
	movwf	MDir			;sub 3-MDir, 3-2 = 1 or 3-1 = 2
	return

;----------------------------------------

MoveSc					;move to new sky point
	btfss	Flag2,DoingTAT		;are we doing a TAT track adjust?
	goto	notat			;no so branck to normal processing

	movlw	Cw			;load Cw direction
	subwf	MDir,w			;are we trying to go Cw?
	skpnz				;no so skip
	return				;yes, so exit to stop backward TAT track adjust from happening

	movlw	Cc			;load Cc direction
	subwf	MDir,w			;are we trying to go Cc?
	skpnz				;no so skip to test for proper alt movement
	goto	notat			;yes, so branch as moving Cc and doing a TAT track adjust

	call	TWest			;check if we are facing West (z)
	skpz				;skip if facing west
	goto	ckeast			;facing east so branch

	movlw	Up			;load Up direction
	subwf	MDir,w			;are we trying to move Up when facing West?
	skpnz				;no so skip
	return				;yes so exit to stop unwanted Up movement
	goto	notat

ckeast
	movlw	Dn			;load Dn direction
	subwf	MDir,w			;are we trying to go Dn when facing East?
	skpnz				;no so skip
	return				;yes so exit to stop unwanted Dn movement

notat
	movlw	3			;
	subwf	MDir,w			;test if alt or azi
	skpnc				;skip if MDir = 1 or 2 (azi)
	goto	AbsMSc			;jump if MDir = 3 or 4 (alt)

	btfsc	Flag0,NHemi			;test if Northern hemisphere
	call	SwapCcCw			;yup so swap normal azi direction
	
;----------------------------------------

AbsMSc					;alernative call to bypass hemisphere Cw/Cc switching
	clrGIE				;disable ints
	doio	EncOn,PORTA			;set encoder power bits to on
	dlylms	10			;wait for encoders to power up & stabilize

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckdn			;nope, so check if moving down

	movlf	AltSel,EncSel		;use alt encoder
	doio	UpOData,UpOP		;turn on Up drive
	goto	wmtroff

ckdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckcc			;nope, so check if moving ccw

	movlf	AltSel,EncSel		;use alt encoder
	doio	DnOData,DnOP		;turn on Down drive
	goto	wmtroff

ckcc
	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckcw			;nope, so check if moving cw

	movlf	AziSel,EncSel		;use azi encoder
	doio	CcOData,CcOP		;turn on Cc drive
	goto	wmtroff

ckcw
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpnz				;skip if no know dir found
	goto	setcw
	
	setGIE				;turn ints back on
	return				;we should never get here

setcw
	movlf	AziSel,EncSel		;use azi encoder
	doio	CwOData,CwOP		;turn on Cw drive

wmtroff
	dlylus	25			;delay encoder interrupt enable by 25 us to filter out motor on noise
	movff	PORTB,EncLst		;latch port B & save current encoder states
	bcf	INTCON,RBIF			;clear port b change flag
	bsf	INTCON,RBIE			;enable encoder pulse interrupts
	bsf	Flag0,MRun			;flag we have a motor running
	movlf	2,EncDwnCnt			;set to timeout in 250 - 500 ms if no encoder pulses
	setGIE				;enable ints

wmtr
	btfss	Flag0,MRun			;test if motor still running
	goto	mtrfin			;no so finish up motor stopped

	movf	EncDwnCnt,f			;test if gap between encoder pulses is > 250 - 500 ms
	skpz				;yes so skip and turn mtrs off
	goto	wmtr			;not yet, so wait and test some more
	
mtrfin
	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on
	doio	0,PORTB			;turn off altitude motor

	dlylms	250			;delay another 250 ms to be sure motor has really stopped	
	return

;---------------------------------------

EncPOff
	bcf	INTCON,RBIE			;disable encoder pulse interrupts
	doio	EncOff,PORTA		;turn off encoder power bits
	dlylms	5			;wait for encoders to turn off
	return

;----------------------------------------
; Tracking procedures
;----------------------------------------

DoWU
	clrGIE				;disable ints
	copy24	WUpAzi,AziSky		;load wakeup azisky
	call	MAziSky			;move there and turn ints back on

	btfsc	Flag1,FastTrk		;test if we are in fast track mode
	goto	GoAlt0			;we are in fast track so use alt 0 as start

	clrGIE				;disable ints
	set24	DegSlp,AltSky		;set sleep trigger altitude
	goto	MAltSky			;move there and turn ints back on

;----------------------------------------

UpDateSky
	clrGIE				;disable ints
	copy24	AziEnc,AziSky		;update calculated skypoint to physical
	copy24	AltEnc,AltSky		;update calculated skypoint to physical
	setGIE				;enable ints
	return

;----------------------------------------
;
;TAziCal
;	copy24	AziEnc,AA			;load A with current azi
;	set24	AziCalDeg,BB		;load BB with AziCalDeg azi
;	ifBleqA	setzf			;branch if AziCalDeg<=AziEnc (z)
;	goto	clrzf			;no, so clr z
;
;----------------------------------------

TAltCal					;test if alt <= AltCalDeg (z)
	copy24	AltEnc,AA			;load A with current alt
	set24	AltCalDeg,BB		;load BB with AltCalDeg alt
	ifBgtrA	setzf			;branch if AltCalDeg>AltEnc (z)
	goto	clrzf			;no, so clr z

;----------------------------------------

TSleep					;test if alt <= sleep alt (z)
	copy24	AltEnc,AA			;load A with current alt
	set24	DegSlp,BB			;load BB with sleep deg
	ifBgtrA	setzf			;branch if DegSlp>AltEnc (z)
	goto	clrzf			;no, so clr z

;----------------------------------------	

TDn					;test if alt below horizon (z)
	copy24	AltEnc,AA			;set up to test altitude
	set24	Deg180,BB			;load values to test if facing up
	ifBleqA	setzf			;branch if Deg180<=AltEnc
	goto	clrzf			;yes, so set z

;----------------------------------------

TWest					;test if azi is west, z = west
	copy24	AziEnc,AA			;set up to test azimuth	
	set24	Deg180,BB			;load values to test if facing west
	ifBleqA	clrzf			;branch if Deg180<=Alt/AziEnc

setzf
	Zset
	return

clrzf
	Zclr
	return

;----------------------------------------

Nudge					;nudge sc physical position in MDir direction
	movff	MDir,SvDir			;save original direction
	movlf	MNCnt,NCnt			;set max nudge count
	call	TSunVdc8			;get current solar voltage

N1
	movff	SvDir,MDir			;restore direction from that saved
	call	TSwOff			;test if hand controller not active
	skpz				;skip if no switches active
	goto	N2			;goto error exit

	movfw	LokVdc			;set min solar voltage to do "On Sun" lock
	subwf	SunVdc,w			;sub SunVdc - W(LocVdc), c = SunVdc >= LocVdc, nc = SunVdc < LocVdc
	skpc				;skip if the solar voltage is >= min voltage
	goto	N2			;solar voltage too low

	decfsz	NCnt,f			;dec max Nudge count
	goto	N3			;skip if another nudge is ok

N2
	goto	clrzf			;flag we have an error (hand job, no edge found or solar voltage too low) & exit

N3
	movff	SunVdc,TarVdc		;save last solar voltage as TarVdc
	set24	NSz,MoveSz			;set SunLock nudge size
	call	MoveSc			;move sc

	dlylms	250			;wait for solar voltage to stabilize after motor drive
	call	TSunVdc8			;get new solar voltage [10:8], do SunVdc-TarVdc
	skpnc				;skip if SunVdc<Tarvdc
	goto	N1			;found higher sun, so do it again

	dlylms	250			;wait for solar voltage to stabilize after motor drive
	call	TSunVdc8			;get new solar voltage [10:8], do SunVdc-TarVdc
	skpnc				;skip if SunVdc<Tarvdc
	goto	N1			;found higher sun, so do it again

	goto	setzf			;flag we found an edge (voltage drop) & exit

;----------------------------------------

SunLock					;adjust the physical sky point to the max solar voltage
	movlf	SlRtyCnt,SlRty		;initialize sunlock edge lock retry count

lockazi
	nudgesc	Cc			;find first edge going Cc
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Cc			;find first edge going Cc
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Cw			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Cw			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	AziEnc,TmpEnc		;save first Cw (low azi) edge position

	nudgesc	Cc			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Cc			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	AziEnc,AA			;load AziEnc, sb biggest (Cc edge)
	copy24	TmpEnc,BB			;load TmpEnc, sb smaller (Cw edge)
	ifBleqA	aziok			;branch if AltEnc<=TmpEnc with difference in AA

	copy24	AziEnc,AA			;load AziEnc (Cc edge)
	set24	Deg360,BB			;load enc max
	call	Add24			;TmpEnc is big, so make temp AziEnc (AA) big as well 
	copy24	TmpEnc,BB			;reload 
	call	Sub24			;get difference in AA

aziok
	copy24	AA,MoveSz			;save AA (difference) in MoveSz
	set24	LockSz,BB			;set min SunLock difference to be not an edge lock
	ifBleqA	azimok			;branch difference is ok

	movf	SlRty,f			;is sunlock retry count zero?
	skpnz				;no so skip
	goto	clrzf			;yes so we failed to lock after retries

	decf	SlRty,f			;dec sunlock retry count
	goto	lockazi			;go to try it one more time

azimok
	copy24	MoveSz,AA			;reload move size
	call	Div2			;/ 2 to calc distance to the middle
	call	Mult.75			;reduce final move size by 25%
	copy24	AA,MoveSz			;set move to middle size

	movlf	Cw,MDir			;set final direction	
	call	MoveSc			;make it happen

;-----					;now do altitude sun lock
	movlf	SlRtyCnt,SlRty		;initialize sunlock edge lock retry count

	call	TWest			;z = west, tracking down
	skpnz				;skip to handle east alt lock
	goto	lockwest			;branch to handle west alt lock

lockeast
	nudgesc	Up			;find first edge of the East sun
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Up			;find first edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Dn			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Dn			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	AltEnc,TmpEnc		;save first edge position

	nudgesc	Up			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Up			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	AltEnc,AA			;load AltEnc, sb biggest (up)
	copy24	TmpEnc,BB			;load TmpEnc, sb smaller (dn)
	ifBleqA	altoke			;branch if AltEnc<=TmpEnc

	copy24	AltEnc,AA			;load AltEnc (up)
	set24	Deg360,BB			;load enc max
	call	Add24			;TmpEnc is big, so make temp AltEnc (AA) big as well 
	copy24	TmpEnc,BB			;reload 
	call	Sub24

altoke
	copy24	AA,MoveSz			;save AA (difference) in MoveSz
	set24	LockSz,BB			;set min SunLock difference to be not an edge lock
	ifBleqA	altemok			;branch if difference is ok

	movf	SlRty,f			;is sunlock retry count zero?
	skpnz				;no so skip
	goto	clrzf			;yes so we failed to lock after retries

	decf	SlRty,f			;dec sunlock retry count
	goto	lockeast			;go to try it one more time

altemok
	copy24	MoveSz,AA			;reload move size
	call	Div2			;/ 2 to calc distance to the middle
	call	Mult.75			;reduce final move size by 25%
	copy24	AA,MoveSz			;save move to middle size

	movlf	Dn,MDir			;set direction	
	call	MoveSc			;make it happen
	goto	updsky			;goto update skypoint

lockwest					;handle alt lock when facing west, tracking down
	nudgesc	Dn			;find first edge of West sun
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Dn			;find first edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Up			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Up			;find first real edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	AltEnc,TmpEnc		;save first edge position

	nudgesc	Dn			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	nudgesc	Dn			;find second edge
	skpz				;skip if we found an edge
	return				;we are lost so exit to let next TAT cycle restore sky point

	copy24	TmpEnc,AA			;load TmpEnc, sb biggest (up)
	copy24	AltEnc,BB			;load AltEnc,sb smaller (dn)
	ifBleqA	altokw			;branch if AltEnc<=TmpEnc

	copy24	TmpEnc,AA			;load TmpEnc
	set24	Deg360,BB			;load enc max
	call	Add24			;AltEnc is big, so make TmpEnc big as well 
	copy24	AltEnc,BB			;redo size calc with bigger TmpEnc
	call	Sub24

altokw
	copy24	AA,MoveSz			;save AA (difference) in MoveSz
	set24	LockSz,BB			;set min SunLock difference to be not an edge lock
	ifBleqA	altwmok			;branch difference is ok

	movf	SlRty,f			;is sunlock retry count zero?
	skpnz				;no so skip
	goto	clrzf			;yes so we failed to lock after retries

	decf	SlRty,f			;dec sunlock retry count
	goto	lockwest			;go to try it one more time

altwmok
	copy24	MoveSz,AA			;load move size to AA
	call	Div2			;/ 2 to calc distance to the middle
	call	Mult.75			;reduce final move size by 25%
	copy24	AA,MoveSz			;save move to middle size

	movlf	Up,MDir			;set direction	
	call	MoveSc			;make it happen

updsky
	call	UpDateSky			;update sky point from encoder point
	call	SetOnSun			;set TAT cycles between on sun locks
	goto	setzf			;set Z to flag we did a good SunLock & exit

;----------------------------------------
; Hand controller procedures
;----------------------------------------

HandJob
	call	TSwOff			;test if all switches are off (z)
	skpz				;skip if no switches are on
	goto	cksw			;switch/s are on so find out which one
	movlf	HJsCnt,HJs			;set number of small moves before big
	goto	clrzf			;no switches on so exit with nz

cksw
	movlf	Dn,MDir			;yes so set direction
	btfss	DnIP,DnI			;test if Down requested
	goto	dohj			;go to common HJ stuff

	movlf	Up,MDir			;yes so set direction
	btfss	UpIP,UpI			;test if Up requested
	goto	dohj			;goto common HJ stuff

	movlf	Cw,MDir			;yes so set direction
	btfss	CwIP,CwI			;check if Cw requested
	goto	dohj			;goto common HJ stuff

	movlf	Cc,MDir			;yes so set direction
	btfss	CcIP,CcI			;test if Cc requested
	goto	dohj			;goto common HJ stuff
	goto	clrzf			;no switches on so exit with nz

dohj					;common HJ stuff
	movlw	HJsCnt			;
	subwf	HJs,w			;test if HJs is gtr than 10
	skpc				;skip if HJs >10
	goto	hjsok			;branch if Hjs <=10

	movlf	HJsCnt,HJs			;ensure only 10 small HJ moves until the big one

hjsok
	decfsz	HJs,f			;dec small moves downcounter
	goto	smove			;small moves finished so do big ones

	bsf	Flag0,HJob			;flag this movement is a movement that can be terminated by any switch being pressed
	set24	Deg90,MoveSz		;set big off sun movement size
	goto	finhj			;go to common HJ movement starter

smove
	set24	Deg0.05,MoveSz		;set small on sun movement size

finhj
	call	AbsMSc			;do the selected movement using the absolute entry point

	btfss	Flag1,ResTst		;test if doing a restore test
	call	UpDateSky			;no, so up date sky point from encoder point

	bsf	Flag1,DidHJ			;flag we did a hand job
	movlf	1,OnSunA			;
	movlf	1,THb			;set OnSunA and THb to one to force SunLock on next TAT check
	goto	setzf			;goto set Z

;----------------------------------------

TSwOff					;test if all switches are off (z)
	movfw	PORTB			;read switches state
	andlw	SwAnd			;isolate switch bits
	sublw	SwAnd			;test if any swithes on, 0 = on / grounded
	return				;z = no, nz = tes

;----------------------------------------

WSwOff					;wait for all switches to be off
	dlylms	100			;debounce switch off
	call	TSwOff
	skpz				;skip if any switche is on
	goto	WSwOff			;no so wait some more

	dlylms	100			;debounce switch off
	call	TSwOff
	skpz				;skip if all switches off
	goto	WSwOff			;no so wait some more
	return

;----------------------------------------
; Adc procedures
;----------------------------------------

;TSunVdc7
;	bsf	ADCON0,GO			;start A/D conversion
;
;	btfsc	ADCON0,GO			;Wait for "GO" to be reset by adc complete
;	goto	$-1			;no - so go to wait for adc complete
;
;	movfw	ADRESH			;load adc [10:8]
;	andlw	0xfe			;make it 7 bit resolution [10:7]
;	movwf	SunVdc			;save 7 bit adj result into SunVdc
;	movfw	TarVdc			;load solar target voltage to w
;	subwf	SunVdc,w			;sub SunVdc - W(TarVdc), c = SunVdc >= TarVdc, nc = SunVdc < TarVdc
;	return				;with result in carry

;----------------------------------------

TSunVdc8
	bsf	ADCON0,GO			;start A/D conversion

	btfsc	ADCON0,GO			;Wait for "GO" to be reset by adc complete
	goto	$-1			;no - so go to wait for adc complete

	movff	ADRESH,SunVdc		;load adc msb [10:8] into SunVdc
	movfw	TarVdc			;load solar target voltage to w
	subwf	SunVdc,w			;sub SunVdc - W(TarVdc), c = SunVdc >= TarVdc, nc = SunVdc < TarVdc
	return				;with result in carry

;----------------------------------------
;
;TSunVdc9					;include the 9th adc bit
;	bsf	ADCON0,GO			;start A/D conversion
;
;	btfsc	ADCON0,GO			;Wait for "GO" to be reset by adc complete
;	goto	$-1			;no - so go to wait for adc complete
;
;	clrc				;clear carry
;	rlf	ADRESL,w			;load carry with lsb bit7
;	rlf	ADRESH,w			;rotate lsb bit 7 into msb bit 0
;	movwf	SunVdc			;load adc [9:8] into SunVdc
;	movfw	TarVdc			;load solar target voltage to w
;	subwf	SunVdc,w			;sub SunVdc - W(TarVdc), c = SunVdc >= TarVdc, nc = SunVdc < TarVdc
;	return				;with result in carry
;
;----------------------------------------
; Initialization procedures
;----------------------------------------

InitVdc					;initialize the Adc to the solar input
	bsf	STATUS,RP0			;select bank 1
	movlf	b'01000000',ADCON1		;left justified data, vref = AVdd/AVss, system clock/2 (rb1)
	bcf	STATUS,RP0			;select bank 0
	movlf	b'01001001',ADCON0		;Fosc/16,channel 0, done, adc on
	return

;----------------------------------------
SetTodPS
	movlf	HbPSec,TodPS		;set up tod prescaler	
	return

;----------------------------------------

SetTHb
	movlf	TatTmr,THb			;set up TAT timer downcounter
	return

;----------------------------------------

SetWUpM
	movlf	WUpPC,WUpPS			;set wake up pre scaler
	movlf	low(STPDay),WUpM		;
	movlf	high(STPDay),WUpM+1		;set sleep down counter to max (1,440) minutes
	bcf	Flag0,WUpZ			;reset wake up minutes zero flag
	return

;----------------------------------------

SetOnSun					;set TAT cycles between On Sun updates
	movlf	OnSunM,OnSunA		;load TAT cycles between on sun updates
	return

;----------------------------------------

SetUpIo					;setup the I/O ports
	movlf	IntA,PORTA			;set initial port A output state

	setRP0				;select bank 1
	movlf	0x72,OSCCON			;select intrc 8 Mhz (rb1)
	movlf	DirA,TRISA			;initialize port A data direction register (rb1)
	movlf	AnalA,ANSEL			;select analog input channels (rb1)
	clrRP0				;select bank 0

;--------------------------------------------------

SetHJ
	movlf	IntBHj,PORTB		;set initial port B output state

	setRP0				;select bank 1
	movlf	DirBHj,TRISB		;initialize port B data direction register (rb1)
	movlw	0x07	

finoreg
	movwf	OPTION_REG			;enable global weak pullups, T0 clk to cpu & PSA to T0 w/ 256 prescaler (rb1,3)
	clrRP0				;select bank 0
	return

;----------------------------------------
;
;SetCom
;	movlf	IntBCom,PORTB		;set initial port b state
;
;	setRP0				;select bank 1
;	movlf	DirBCom,TRISB		;initialize port B data direction register (rb1)
;	movlw	0x87
;	goto	finoreg
;
;----------------------------------------

SetTmrs					;set up the various timer values to their initial values
	call	SetTodPS			;set up Tod prescaler
	call	SetTHb			;set up track delay prescaler
	call	SetWUpM			;setup sleep timer
	goto	SetOnSun			;set TAT cycles between on sun updates

;----------------------------------------

EnaInt					;enable interrupts
	movlf	t1low,TMR1L			;(rb0)
	movlf	t1high,TMR1H		;set initial values for the T1 250ms heart beat (rb0)
	movlf	0x31,T1CON			;set up T1 timer for interrupts & /8 prescaler (rb0)
	bcf	PIR1,TMR1IF			;clear any pending T1 interrupt flags (rb0)

	bsf	STATUS,RP0			;select bank 1
	bsf	PIE1,TMR1IE			;enable T1 interrupts (rb1)
	bcf	STATUS,RP0			;back to bank 0
	bsf	INTCON,PEIE			;enable timer interrupts (rb0,1,2,3)
	setGIE				;enable general interrupts (rb0,1,2,3)
	return

;----------------------------------------

ClearRam					;clear ram to zero
	movlf	ram0,FSR			;set pointer to start of ram

nxtclr					;clear bank 0 ram from 0x20 thru 0x7f
	clrf	INDF			;clear @ pointer
	incf	FSR,f			;inc pointer
	btfss	FSR,7			;test if cleared last ram
	goto	nxtclr			;no - so go clear more ram
	return

;-----------------------------------------------------------------------
;####### Start of code (Main Program). #######
;-----------------------------------------------------------------------

Main					;start of code. Power on jumps to here
	call	SetUpIo			;setup I/O ports & clock
	call	Dly1sec			;delay to stabilize input voltage
	call	SetUpIo			;re do IO setup
	call	ClearRam			;clear ram
	call01	SetUpTOD			;set up TOD month index
	call	InitVdc			;initialize the Adc solar input
	call	SetTmrs			;set the various system timers
	call	EnaInt			;set up and enable interrupts
	movlf	HJsCnt,HJs			;set number of small Hand Controller moves before big

;	clrGIE				;disable ints
;	call01	CkMem			;check program memory checksum (z=ok)
;	setGIE				;enable ints
;	skpnz				;skip if we have a non zero result (bad memory checksum)
;	goto	memok
;
;membad
;	movsc	Cw,Deg1.0			;
;	movsc	Cc,Deg1.0			;show'em the mem test failed
;	call	Dly1sec
;	goto	membad			;try to reinitialize to see if that fixes it.
	
memok					;move Cubie in all 4 directions to test motors
	abssc	Up,Deg0.50			;move Dow
	abssc	Dn,Deg0.50			;move Up
	abssc	Cw,Deg0.50			;move Clockwise
	abssc	Cc,Deg0.50			;move Counter clockwise

;----------------------------------------
; Align SunCube to facing equator & true vertical
;----------------------------------------

CkAlign
	btfsc	FsIP,FsI			;test if we are aligned
	goto	SEnc			;yes so zero & store encoders

	call	HandJob			;allow hand controller to move & align SunCube
	goto	CkAlign

;----------------------------------------
; Store Alt and Azi zero
;----------------------------------------

SEnc
	call	Dly1sec			;delay 1 second to debounce jumper removal

	clr24	AltEnc			;
	clr24	AziEnc			;set Alt & Azi encoders to zero

	btfss	Flag1,ResTst		;is this a restore test?
	goto	CkEMPS			;no so get on with it

	bcf	Flag1,ResTst		;reset ResTst
	call01	ResSky			;restore original sky point
	call	MAltSky			;move to current AltSky
	call	MAziSky			;move to current AziAky
	movlf	1,OnSunA			;force first TAT cycle to do an on sun lock
	movlf	MorLok,LokVdc		;set lower morning min solar voltage for a sun lock cycle
	goto	TrackSun			;back to doing some real work

;----------------------------------------
; Test for and get alignment of the Exernal Magnetic Positioning System (EMPS)
;----------------------------------------

CkEMPS
	bsf	Flag0,NHemi			;set to north as default for EMPS search so Cw movement incs AziEnc

	call	FAltMs			;test for Alt EMPS
	btfss	Flag1,MsOK			;test alt EMPS found
	goto	emps1			;branch if no alt EMPS found

	movfw	AltEnc+1			;load supposed EMPS alt encoder byte 2
	iorwf	AltEnc+2,w			;or in byte 3
	skpz				;skip if zero (false EMPS detected)
	goto	emps0	

	call	GoAlt0			;goto back to orgi Alt 0
	bcf	Flag1,MsOK			;reset EMPS present flag
	goto	GetHemi			;get the hemisphere

emps0
	copy24	AltEnc,MsAlt		;get & save EMPS alt position

emps1
	call	GoAlt0			;goto alt 0 to move sensor away from magnet

	btfss	Flag1,MsOK			;test if EMPS found
	goto	GetHemi			;branch if no azi EMPS found

	call	FAziMs			;test for azi EMPS
	btfss	Flag1,MsOK			;test azi EMPS found
	goto	emps2			;branch if no azi EMPS found

	copy24	AziEnc,MsAzi		;get & save azi EMPS position

emps2
	call	GoAzi0			;goto azi 0 to move sensor away from magnet

;----------------------------------------
; Get which hemisphere, Up switch = North, Down switch = South
;----------------------------------------

GetHemi	
	btfsc	CcIP,CcI			;test if Cc switch pushed
	goto	ckhm1			;no so check for down

	bsf	Flag1,FastTrk		;set fast track flag
	abssc	Cc,Deg3.0			;
	call	GoAzi0			;show fast track selected
	goto	GetHemi

ckhm1
	btfss	CwIP,CwI			;test if recalibrate EMPS requested
	goto	CkAlign			;recalibrate the alignment

ckhm2
	btfsc	DnIP,DnI			;test if Down requested
	goto	ckhm3			;no so go check if up request

	bcf	Flag0,NHemi			;Southern hemishpere selected		
	movsc	Dn,Deg3.0			;move sc Down to indicate Southern hemisphere selected
	call	GoAlt0

	set24	Deg360,AA			;load max azi+1
	copy24	MsAzi,BB			;load EMPS northern hemisphere azimuth
	call	Sub24			;get equivalent southern hemisphere azimuth
	copy24	AA,MsAzi			;save southern hemi azi EMPS position

	goto	saziadj			;finish hemi selection processing

ckhm3
	btfsc	UpIP,UpI			;test if Up requested
	goto	GetHemi			;no so start over again

	bsf	Flag0,NHemi			;Northern hemisphere selected
	movsc	Up,Deg3.0			;move sc Down to indicate Southern hemisphere selected
	call	GoAlt0

saziadj
	call	WSwOff			;wait until all switches are turned off

	btfss	Flag1,FastTrk		;test if fast track requested
	goto	notft			;no so skip it

	set24	FTAzi,AziSky		;set fast track azi
	call	MAziSky			;move to first fast track azi
	goto	skipup			;skip going up 30 deg

notft
	movsc	Up,AltCalDeg+Deg5.0		;move up above AltCalDeg deg trigger

skipup
	movlf	MorLok,LokVdc		;set morning min sun voltage for first sun locks
	movlf	1,OnSunA			;force first TAT cycle to do an on sun lock

	clrf	second			;
	clrf	minute			;
	clrf	hour			;clear second & minute to sync TOD to first movement

	call	SetTHb			;set track update timer
	bsf	Flag1,TATGo			;enable TAT calcs

;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
;	bsf	Flag0,DoDump		;turn on diagnostic data dumps
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<

;----------------------------------------
; Finally we get to track the sun
;----------------------------------------

TrackSun					;nudge the motors to track max solar voltage
	doio	0,PORTA			;turn off azimuth motor and encoders
	doio	0,PORTB			;turn off altitude motor

	bcf	Flag0,Doze			;reset we are dozing flag to double downcount sleep timer

	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj

	dlylms	250			;debounce jumper
	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj	

	call01	ReCal			;do encoder recal

wj1
	btfss	FsIP,FsI			;skip if jumper removed
	goto	wj1			;no so wait some more

	dlylms	250			;jumper removed so wait 100 ms to debounce
	btfss	FsIP,FsI			;skip if jumper removed
	goto	wj1			;not yet so wait some more

	goto	finjrc			;got finish recal processing

ckhj
	call	HandJob			;check for and do any hand controller input

	btfss	Flag0,DoTAT			;check if time to adjust physical sky point
	goto	TrackSun			;no, so wait some more

	bcf	Flag0,DoTAT			;reset DoTAT flag

	call	TWest			;test if facing west (z)
	skpz				;skip if facing west (z)
	goto	cktat			;facing east, so skip facing down test				
	
	btfsc	Flag1,AltCalFin		;have we done a AltCal encoder recalibrate?
	goto	finwest			;yes so don't do it again this day

	call	TAltCal			;test if alt <= AltCal (z)
	skpz
	goto	finwest			;not end of day so just do normal processing

	bsf	Flag1,AltCalFin		;flag we have done alt recal

	call01	ReCal			;do encoder recal

finjrc
	call	MAltSky			;
	call	MAziSky			;move to new recal calculated sky point 
	movlf	1,OnSunA			;
	movlf	1,THb			;set OnSunA and THb to one to force SunLock on next TAT check
	goto	TrackSun			;go back to work, do a SunLock at the next TAT time & generate a lot more kWhs

finwest
	btfss	Flag1,FastTrk		;test if in test mode
	goto	slptst			;no so do normal min altitude test

	call	TDn			;test if alt <= 0 deg (z)
	skpnz				;skip if not (nz)
	goto	EndofDay			;facing west and down, so do end of day

slptst
	call	TDn			;test if alt <= 0 deg (z)
	skpnz				;skip if facing above 0 deg (nz)
	goto	EndofDay			;facing west and down, so do end of day

	call	TSleep			;test if alt <= sleep degrees (z)
	skpnz				;skip if facing above sleep alt (nz)
	goto	EndofDay			;facing west and down, so do end of day

cktat
	btfsc	Flag1,FastTrk		;test if we are in fast track mode
	goto	dotatadj			;yes so skip PeakSun search

	decfsz	OnSunA,f			;dec TAT cycles between on sun updates
	goto	dotatadj			;not time for sunlock adj so do tat adj

	movlf	1,OnSunA			;set Tat cycles to 1 so if solar voltage is too low we check it on each new TAT cycle
	movff	LokVdc,TarVdc		;set min solar voltage to do on sun lock

	call	TSunVdc8			;get current solar voltage and test if it is high enough
	skpc				;skip if it solar voltage is >= min voltage
	goto	dotatadj			;no, too low so just do a TAT cycle

	bsf	Flag2,DoingTAT		;flag we are doing a TAT track adjust
	call	MAltSky			;
	call	MAziSky			;move to new TAT calculated sky point before doing the SunLock
	bcf	Flag2,DoingTAT		;clear we are doing a TAT track adjust

	movlf	1,OnSunA			;set Tat cycles to 1 so if SunLock reports an error the SunLock will be retried at the next TAT time
	call	SunLock			;micro adjust the sky point to max voltage
	skpz				;skip if SunLock ok (z flag)
	goto	dotatadj1			;lock failed so do tat instead

	movlf	NorLok,TarVdc		;
	call	TSunVdc8			;test if solar voltage >= norlok voltage
	skpc				;skip if solar voltage is >= NorLok voltage
	goto	tstwest			;no so goto check sleep timer

	movlf	NorLok,LokVdc		;we found the sun so set normal lock min voltage
	bsf	Flag1,Locked		;flag we did a SunLock at normal Vdc
	goto	tstwest			;go to check the sleep timer

dotatadj
	bsf	Flag2,DoingTAT		;flag we are doing a TAT track adjust

dotatadj1
	call	MAltSky			;
	call	MAziSky			;move to new TAT calculated sky point
	bcf	Flag2,DoingTAT		;flag we have finished doing a TAT track adjust
	
tstwest
	call	TWest			;test if facing west, z = west
	skpz				;yes so skip
	call	SetWUpM			;as we are facing east set wake up minutes to max
	goto	TrackSun

;----------------------------------------
; Sleep / End of day processing
;----------------------------------------

EndofDay					;move to overnight stow
	btfss	Flag1,Locked		;skip if NorVdc SunLock happened today
	goto	nolock			;no lock so skip updating WUpAzi

	set24	Deg360,AA			;load max azi+1
	copy24	AziEnc,BB			;load west sleep azi
	call	Sub24			;calc east wake up azi
	copy24	AA,WUpAzi			;save east wake up azi

nolock
	bcf	Flag1,Locked		;reset Normal voltage SunLock happened
	bcf	Flag1,AltCalFin		;reset AltCal done flag
	bsf	Flag0,Doze			;set we are dozing flag to stop double sleep time downcount
	bcf	Flag1,TATGo			;stop TAT calcs changing sky point

	btfss	Flag2,DidRetro		;test if we did a retro track
	goto	noretro			;no so skip retro track processing to stop wrapping the power wires around the pole

	bcf	Flag2,DidRetro		;reset did retro track flag
	set24	Deg180,AziSky		;set to point to pole
	call	MAziSky			;move there
	set24	Deg270,AziSky		;set to point East
	call	MAziSky			;move there
	call	GoAzi0			;move to azi 0

noretro
	call01	ReCal			;recal Azi & Alt encoders
	set24	DegNSlp,AltSky		;set altsky to night sleep alt
	call	MAltSky			;go there
	call	EncPOff			;turn off encoder power to save battery power

	btfss	Flag1,FastTrk		;test if fast track requested
	goto	wmorning			;no so just wait for morning

	set24	FTAzi,WUpAzi		;set fast track wake up azi
	dlylsec	10			;delay for 10 seconds
	goto	morning			;goto wake up processing

;----------------------------------------
; Morning / Wake up processing
;----------------------------------------

wmorning					;with our work day done, its time to sleep & maybe to dream
	btfsc	Flag0,WUpZ			;test if wake up delay is zero
	goto	morning			;yup, so wake up and get to work

	call	HandJob			;any switch touched?
	skpz				;yup so time to get up and go to work
	goto	wmorning			;wait for morning wakeup call	

morning
	call	DoWU			;point Cubie to the wake up sky point
	call	UpDateSky			;update sky point from encoder point
	call	SetWUpM			;set wake up minutes to max & clear WUpZ flag
	bcf	Flag0,Doze			;clear we are dozing flag
	call	SetTHb			;start the THb track timer going
	bsf	Flag1,TATGo			;start the TAT calculations
	movlf	MorLok,LokVdc		;set lower morning min solar voltage for a sun lock cycle
	goto	TrackSun			;go back to work to generate more kWhs and earn some money

;----------------------------------------
; End Program code for Bank 0
;----------------------------------------

 
