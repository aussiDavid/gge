
;***********************************************************************;
;                            Mark9.ASM			;
;                                                           	;
;                    SunCube Solar PV Firmware              	;
;                                                       		;
;    This program & the system design of the SunCube are copyright     	;
;                            Greg Watson        	            ;
;                   2005 2006 2007 2008 2009 2010             	;
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

#define 	Version	"SunCube Firmware Ver 20100607a, "
#define 	CopyRight	"Patents in progress, Copyright(C) Greg Watson 2005-2010. All rights reserved."

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
DegT315	equ	DegAdj*(Deg360-Deg45)

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

NudgeSz	equ	Deg0.20			;size of nudge movement
NudgeCnt	equ	Deg30/NudgeSz		;max deg of nudge movement in any direction
LockSz	equ	Deg1.0			;min size of SunLock width to be accepted as not an edge lock.
NumBrk	equ	1			;number of encoder pulses +1 to apply reverse rotation (breaking)
HJsCnt	equ	10			;number of small HJ moves before big
SunLkRtyCnt	equ	3			;number of sunlock retries when we get a lock error

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

;NCells	equ	9			;normal series connected cells in the SunCube
;VAdj	equ	(SCells*100)/NCells		;voltage adjust value for variable number of series cells

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
ticklos	equ	0			;timer ticks lost before we write the new value
t1val	equ	(tickval+ticklos)		;rolled over T1 vaue
t1low	equ	low(t1val)			;preset for TMR1L
t1high	equ	high(t1val)			;preset for TMR1H

;-----------------------------------------------------------------------
; T1 timer driven 250 ms heartbeat constants
;-----------------------------------------------------------------------

HoursPerDay	equ	24			;hours per day
MinutesPerHour	equ	60		;minutes per hour
SecPerMin	equ	60			;seconds per minute

MinutesPerDay	equ	HoursPerDay*MinutesPerHour	;1 minute sleep ticks (downcounts) per day

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	McI	0			;motor current sense input (pin 17)
#define	McIP	PORTA

#define	CvI	1			;solar voltage sense input (pin 18)
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
; Memory allocations
;-----------------------------------------------------------------------

LSB	equ	0

	cblock	ram0			;variables in ram bank 0

;--------------------------------
; timer loop counters
;--------------------------------

dlyxus	:1				;us delay loop counter
dlyxms	:1				;ms delay loop counter
dlyxsec	:1				;minute delay loop counter

;--------------------------------
; Math variables
;--------------------------------

BB	:3				;24 bit math input

;--------------------------------
; Pointing variables
;--------------------------------

AltSky	:3				;altitude sky point
AltTarget	:3				;alt to move to
AltI	:1				;altitude TAT index value
AltEnc	:3				;altitude encoder position 0 - 139,999
SAltEnc	:3				;saved alt encoder
MagAlt	:3				;magnet Alt position

AziSky	:3				;azimuth sky point
AziTarget	:3				;azi to move to
AziI	:1				;azimuth TAT index value
AziEnc	:3				;azimuth encoder position 0 - 139,999
SAziEnc	:3				;saved azi encoder
MagAzi	:3				;magnet Azi position
WUpAzi	:3				;wake up encoder

AbsDif	:3				;Abs encoder pulse error size
MoveSz	:3				;desired encoder movement (0 - 139,999 pulses)
SMoveSz	:3				;saved last motor move size
TmpEnc	:3				;saved encoder position for edge detection

;------------------------
; Comm variables
;------------------------

baud	:0				;baud delay loop counter
bitcnt	:0				;bits to send counter
rcvchr	:0				;receive character bit rotate buffer
xmtchr	:0				;send character bit rotate buffer
bcdchr	:0				;used to pack 2 received ascii into bcd
xmtcnt	:0				;count of send bytes, used to fire up the Adc during long sends

;------------------------
; time variables
;------------------------

TatIntCnt	:1				;timer ints per TAT update down counter
WUpM	:2				;wake up minutes down counter
SWUpM	:2				;saved wake up minutes
TodPS	:1				;tod update pre scaler
WUpMPS	:1				;wake up minutes downcount pre scaler
EncTOCnt	:1				;encoder inter gap timeout counter

;------------------------
; Motor control variables
;------------------------

MDir	:1				;motor direction register
EncLst	:1				;state of encoder pulses at last interrupt
EncSel	:1				;indicates which encoder pulse should change
SvDir	:1				;saved original direction
BrkCnt	:1				;encoder pulses to apply brake for

;------------------------
; Adc variables
;------------------------

SunVdc	:1				;last value of solar Vdc
TarVdc	:1				;solar Vdc target
LokVdc	:1				;min solar Vdc to do a sun lock
SLokVdc	:1				;solar voltage at the start of a SunLock attempt

;------------------------
; Misc variables
;-----------------------

temp	:1				;
temp1	:1				;
tempb	:1				;
tempw	:1				;temps

TatLkCnt	:1				;TAT cycles between on sun updates
Flag0	:1				;boolean flag byte 0
Flag1	:1				;boolean flag byte 1
Flag2	:1				;boolean flag byte 2
SunLkRty	:1				;sunlock retry count
HJs	:1				;small HJ counter
NCnt	:1				;number of "On Sun" nudge cycles

	endc

;leave NCnt as last variable

;--------------------------------
; Interrupt handler variables
;--------------------------------

	cblock	(ramint+16)-11		;start of bank insensitive ram

saveW	:1				;save W >>>>>KEEP AS FIRST VARIABLE<<
saveST	:1				;save STATUS
savePCL	:1				;save PCLATH
tempi	:1				;used in int handler
AziC 	:1				;azimuth track correction
AltC	:1				;altitude track correction
AA	:3				;24 bit math input
sdlyxus	:1				;saved dlyxus
SFSR	:1				;saved FSR, used by TOD, 24 bit inc and dec

	endc

B0Avil	equ	saveW-NCnt-1		;amount of ram left in bank 0

;--------------------------------
; Checksum variables in bank insensitive ram, used with ints disabled
;--------------------------------

;CkSumL	equ	0x7e			;check sum low byte
;CkSumH	equ	0x7f			;check sum high byte

;-----------------------------------------------------------------------
; Ram bank 1 equates
;-----------------------------------------------------------------------

	cblock	ram1

Sv0	:1	
Sv1	:1	
Sv2	:1	
Sv3	:1	
Sv4	:1	
Sv5	:1				;here we save AA and BB during interrupts

;------------------------
; Tod & time variables
;------------------------

second	:1	
minute	:1	
hour	:1	
day	:1	
month	:1	
yearhi	:1	
yearlo	:1	

dmth	:12

	endc

;-----------------------------------------------------------------------
; EE Data memory allocations
;-----------------------------------------------------------------------

	org	EeData0			;set start for EE data memory

	de	Version			;store firmware date
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
; Flag0 bit equates
;-----------------------------------------------------------------------

WUpMZ0	equ	0			;Wake up minutes zero flag
TMs0	equ	1			;find mag sensor flag
MorLk0	equ	2			;morning sun lock done
HJob0	equ	3			;flag for Hand Job big motor movement request
MRun0	equ	4			;any motor running flag
DoTAT0	equ	5			;TAT timer interrupt sets the TAT track adjust flag
NHemi0	equ	6			;hemisphere, 1 = North
DoDump0	equ	7			;do a diagnostic data dump after every track adjust

;-----------------------------------------------------------------------
; Flag1 bit equates
;-----------------------------------------------------------------------

ResTst1	equ	0			;flag we are doing a restore test
SunVdcLow1	equ	1			;flag sun voltage dropped below min on sun lock voltage
FastTrack1	equ	2			;fast track test mode flag
TATGo1	equ	3			;Ok for TAT to run flag
AltCalFin	equ	4			;flag we have done a AltCal recal of the encoders
RetroTAT	equ	5			;retro azi movement flag
Locked	equ	6			;got NorVdc SunLock
Do2xLk1	equ	7			;do a 2 axis sun lock

;-----------------------------------------------------------------------
; Flag2 bit equates
;-----------------------------------------------------------------------

RetroCbl	equ	0			;we did a retro cable wrap as we crossed solar noon
;	equ	1			;
BGtrA	equ	2			;AbsDiff flag 
LockTog	equ	3			;SunLock Alt or Azi toggle
XSolarNoon2	equ	4			;crossed solar noon flag
DoingTat	equ	5			;flag this axxsky goto is a tat movement
;	equ	6			;
;	equ	7			;

CmpBGtrA	equ	b'00000100'			;used to compliment bit 2, BGtrA when in the Southern hemisphere with azi magnet in the East

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
	call	Nudge			;move sc in altitude
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

movb0b1	macro	regs,regd			;move register regs to regd via w
	movfw	regs			;load source register in bank 0
	setRP0				;select ram bank 1
	movwf	regd			;save in destination register in bank 1
	clrRP0				;select ram bank 0
	endm

;----------------------------------------

movb1b0	macro	regs,regd			;move register regs to regd via w
	setRP0				;select ram bank 1
	movfw	regs			;load source register in bank 1
	clrRP0				;select ram bank 0
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
	movlf	lit,portadr			;set up port
	endm

;--------------------------------

movsc	macro	dir,deg
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call	CkMRetro			;check if we need to do a retro azi adjust then do it
	endm

;--------------------------------

movsc10	macro	dir,deg
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call10	CkMRetro			;check if we need to do a retro azi adjust then do it
	endm

;--------------------------------

abssc	macro	dir,deg
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call	AbsMSc			;make it happen
	endm

;--------------------------------

abssc10	macro	dir,deg			;program mem page 1 abs call
	movlf	dir,MDir			;set movement direction
	set24	deg,MoveSz			;set movement size
	call10	AbsMSc			;make it happen
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

	org	0x0000			;program memory address for the start of page 0 (also power on reset entry point)

	goto	Main			;go to start of main code

	goto	$
	goto	$
	goto	$

;-----------------------------------------------------------------------
; The interrupt controller handles
;
;   250ms master timer interrupts
;     Downcounting & setting track update timer TatIntCntZ flag on zero TatIntCnt downcount
;     Downcounting & setting sleep timer WUpMZ0 flag on zero WUpM downcount  
;   Motor encoder pulse interrupts
;     Updating Azimuth & Altitude encoders & MoveSz drive length from motor encoder pulses
;     Turning the motor off when MoveSz goes zero and resetting MRun0 flag
;   Max stack depth used is 3 including the interrupt. 
;   This means we must limit the main code excecution to no more than 5 nested
;   calls or we will underflow / wrap the stack during interrupt proceesing and lose control
;-----------------------------------------------------------------------

	org	0x0004			;interrupt entry point <<<<<<<<<<<<<<<<<

	movwf	saveW			;save w
	swapf	STATUS,w			;load status into w but in reversed lsb & msb order
	movwf	saveST			;save status flags
	clrf	STATUS			;clear status and select ram bank 0
	movff	PCLATH,savePCL		;save PCLATH (we may have been in program bank 1)
	clrf	PCLATH			;clear it to program bank 0
	movff	FSR,SFSR			;save FSR
	movff	dlyxus,sdlyxus		;save external dlyxus

	btfss	PIR1,TMR1IF			;is this a timer overflow interrupt?
	goto	tstpbc			;no so handle encoder interrupt

;-- save AA and BB in bank 1 -----------------

	movb0b1	AA,Sv0			;
	movb0b1	AA+1,Sv1			;
	movb0b1	AA+2,Sv2			;AA (in common bank ram) saved

	movb0b1	BB,Sv3			;
	movb0b1	BB+1,Sv4			;
	movb0b1	BB+2,Sv5			;BB saved

;------------------------------------------------------------
; Handle T1 timer interrupt & related down counters
;------------------------------------------------------------

	set24	t1val,AA			;load AA with rolled over t1 start target
	clrf	BB+2			;clear msb
	movff	TMR1L,tempi			;save current TMR1L value

wt1tick	movfw	TMR1L			;reload current TMR1L value
	subwf	tempi,w			;sub to see if it has changed / counted up
	skpnz				;skip if it has changed / counted up (nz)
	goto	wt1tick			;no change (z), so go to wait for the T1 timer to count up

	movff	TMR1L,BB			;load new start value lsb first
	movff	TMR1H,BB+1			;then msb
	call	Sub24			;sub to get new time adjusted T1 value AA-BB
	clrf	TMR1L			;clear lsb to ensure no unwanted timer overflow into msb
	movff	AA+1,TMR1H			;store rolled over value msb
	movff	AA,TMR1L			;store rolled over value lsb
	bcf	PIR1,TMR1IF			;reset timer overflow flag

;-- Handle timer heart beat down counters -----

	movf	EncTOCnt,f			;test if z	
	skpz				;yup so skip dec
	decf	EncTOCnt,f			;dec encoder pulse inter gap timeout detector (stalled/no motor)
			
	btfss	Flag1,TATGo1		;test if ok to do TAT calcs
	goto	doWUp			;no so skip TAT stuff

	btfsc	Flag1,FastTrack1		;test if fast track requested
	goto	doftrk			;yes so do fast track

	decfsz	TatIntCnt,f			;dec timer ints until next TAT update
	goto	doWUp			;not zero so just dec it

	call	SetIntPerTat		;set num of Tmr Ints per TAT update

doftrk	bsf	Flag0,DoTAT0		;set DoTAT0 flag so the outer loop has something to do

;-- get current TAT index and data --

	copy24	AltSky,AA			;load alt sky point to find the alt TAT index
	call	Mult34			;do the multiply to get the 5 deg index in AA+2
	movff	AA+2,AltI			;save raw alt index

	movlw	180/5			;load max alt index +1 (36)
	subwf	AltI,w			;test if alt index is >=36
	skpc				;yes, AltI >=36, so skip
	goto	not36			;no so leave it alone

	movlf	35,AltI			;yup so make it 35

not36	movlw	90/5			;load max TAT alt index +1 (18)
	subwf	AltI,w			;test if AltI >= 18
	skpc				;yes, AltI >=18, so skip
	goto	calcazi			;yes, so leave it as it is and just branch

	movwf	AltI			;save result of AltI-18
	movlf	(90/5)-1,temp		;store new base adjust value (17)
	movfw	AltI			;reload adjusted AltI
	subwf	temp,w			;do 17-(AltI-18)
	movwf	AltI			;save result

;----

calcazi	copy24	AziSky,AA			;load azi sky point to find the azi TAT index
	call	Mult34			;do the multiply to get the 5 deg index in AA+2
	movff	AA+2,AziI			;save raw azi index (0-72)

	movlw	360/5			;load max azi index +1 (72)
	subwf	AziI,w			;test if azi index is >=72
	skpc				;yes, AziI >=72, so skip
	goto	not72			;no so leave it alone

	movlf	71,AziI			;yup so make it 71

not72	movlw	180/5			;load max TAT azi index +1
	subwf	AziI,w			;test if AziI >= 36
	skpc				;yes, so skip
	goto	tatc			;no, so leave it as it is and just branch

	movwf	AziI			;save result of AziI-36
	movlf	(180/5)-1,temp		;store new base adjust value (35)
	movfw	AziI			;reload adjusted AziI
	subwf	temp,w			;do 35-(AziI-36)
	movwf	AziI			;store final value

;----

tatc	movff	AziI,AA
	clrf	AA+1
	clrf	AA+2			;load AA with AziI TAT index
	clrf	BB			;
	clrf	BB+1			;
	clrf	BB+2			;clear BB
	call	Mult32			;use x32 multiply to move the AziI index 5 bits left

	movfw	AltI			;load Altitude TAT index
	addwf	AA,f			;add in Altitude TAT index to Azimuth TAT and store
	bsf	AA+1,3			;full TAT index now in AA+2/B1

	setRP1				;Bank 2 for EEADRH
	movff	AA,EEADR 			;lsb of program address to read (rb2)
	movff 	AA+1,EEADRH			;msb of program address to read (rb2)
					;
	setRP0				;Bank 3 for EECON1
	bsf 	EECON1,EEPGD 		;select program memory (rb3)
	bsf 	EECON1,RD	 		;do read
	nop 				;
	nop				;delay for read data

	clrRP0				;Bank 2 for EEDATA
	movff 	EEDATA,AziC 		;store lsb as Azimuth TAT correction (rb2)
	movfw 	EEDATH			;load high byte
	andlw	0x3f			;make sure only 6 bits valid
	movwf	AltC	 		;store msb as Altitude TAT correction (rb2)
	clrRP1				;back to bank 0

	bcf	Flag1,RetroTAT		;clear retro tat azi movement flag

	if	Retro == 1			;test if TAT has retro movement

	btfss	AltC,5			;test if retro azi movement flag is set
	goto	calti			;no so branch

	bsf	Flag1,RetroTAT		;set retro tat azi movement flag
	bcf	AltC,5			;clear retro flag so alt adjustment is as programmed

calti	
	endif				;end conditional retro movement code

;-- calc new altsky --

	copy24	AziEnc,AA			;set up to test azimuth	
	set24	(Deg180-1),BB		;load values to test if facing west
	ifBleqA	adjalte			;branch if facing East

	copy24	AltSky,AA			;load AA with current sky point
	movff	AltC,BB			;
	clrf	BB+1			;
	clrf	BB+2			;load BB+ with TAT alt adjustment
	call	Sub24			;subtract as the sun drops in the western sky
	goto	adjaltf			;go to save the new sky point

adjalte	copy24	AltSky,AA			;load AA with current sky point
	movff	AltC,BB			;
	clrf	BB+1			;
	clrf	BB+2			;load BB+ with TAT alt adjustment
	call	Add24			;add as the sun climbs in the eastern sky

adjaltf	copy24	AA,AltSky			;save new AltSky point

;-- calc new azisky --

	copy24	AziSky,AA			;load AA with current sky point
	movff	AziC,BB
	clrf	BB+1
	clrf	BB+2			;load BB+ with TAT adjustment

	btfss	Flag1,RetroTAT		;test if we need to do a retro track adjust
	goto	noretro2			;no so do normal add to get new azimuth

	call	Sub24			;we are tracking retro so sub to get new azimuth
	goto	retrofin			;finish up new azimuth calc

noretro2	call	Add24			;add as the sun moves to bigger azi numbers during the day

retrofin	copy24	AA,AziSky			;save new AziSky point
	set24	Deg360,BB			;check if azisky rolled over
	ifBgtrA	ckxnoon			;branch if Deg360>AziSky

	copy24	AA,AziSky			;store rolled over azisky

ckxnoon	btfsc	Flag2,XSolarNoon2		;test if xsolarnoon flag is set
	goto	doWUp			;set so skip the cross solar noon test stuff below
	
	copy24	AziSky,AA			;load azisky
	set24	Deg180,BB			;load Deg180
	ifBleqA	doWUp			;branch if we have not crossed to the west

	bsf	Flag2,XSolarNoon2		;set crossed solar noon flag

	copy24	AziSky,AA			;load azisky
	set24	Deg90,BB			;load Deg90
	ifBgtrA	doWUp			;branch if facing to the equator, ie doing a non retro track

	bsf	Flag2,RetroCbl		;we are facing the pole and did a retro cable wrap during solar noon cross

;-- Handle wake up down counter ---------

doWUp					;handle sleep delay
	decfsz	WUpMPS,f			;dec wake up pre scaler
	goto	dotod			;not zero so go do tod stuff

	call	SetWUpMPS			;set wake up prescaler ticks to 1 minute
	call01	DecWupD			;dec wake up minutes by 1

	btfss	Flag2,XSolarNoon2		;test if we have crossed solar noon (facing west)
	goto	dotod			;no so skip double dec of wakeup timer

	call01	DecWupD			;dec wake up delay by an additional 1 minute as we are facing west

;-- Handle Tod updater --

dotod
	decfsz	TodPS,f			;dec tod pre scaler
	goto	tmrfin			;not zero so get out of here

	call	SetTodPS			;set tod pre scaler
	call01	UpDTod			;update Tod

tmrfin	movb1b0	Sv0,AA			;
	movb1b0	Sv1,AA+1			;
	movb1b0	Sv2,AA+2			;AA restored

	movb1b0	Sv3,BB			;
	movb1b0	Sv4,BB+1			;
	movb1b0	Sv5,BB+2			;BB restored
	goto	intfin			;get out of here


;---------------------------------------------------------------
; Handle encoder pulse edge input / port B change interrupt
;---------------------------------------------------------------

tstpbc
	btfss	INTCON,RBIE			;is the encoder interrupt enabled
	goto	intfin			;no so get out of here
	btfss	INTCON,RBIF			;is it an encoder interrupt?
	goto	intfin			;no so get out of here

	call	CkEnc			;check if valid encoder pulse or noise
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	30			;30 us noise delay
	call	CkEnc			;and again
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	dlylus	30			;30 us noise delay
	call	CkEnc			;one more time for luck
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	movlf	3,EncTOCnt			;set encoder max inter gap time to max 500 - 750 ms

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

brkoff	bcf	Flag0,MRun0			;yes so flag move completed

	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on
	doio	0,PORTB			;turn off altitude motor
	goto	ckifup			;movement finished but motor still moving, so update encoder position

decenc1	movlf	MoveSz,FSR			;set pointer to MoveSz
	call01	Dec24			;dec enc pulses to move
	movfw	MoveSz			;load lsb
	iorwf	MoveSz+1,w			;or in lsb+1
	iorwf	MoveSz+2,w			;or in lsb+2 & test if movenc is zero
	skpz				;skip if movement finished
	goto	ckifup			;no, so update encoder

	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on
	doio	0,PORTB			;turn off altitude motor

	dlylus	50			;wait 50 micro seconds for drive lines to drop before turning on reverse break drive

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckdn1			;nope, so check if moving down

	doio	DnOData,DnOP		;turn on reverse Dn drive as a break
	goto	brkdly

ckdn1	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckccw1			;nope, so check if moving ccw

	doio	UpOData,UpOP		;turn on reverse Up drive as a brake
	goto	brkdly

ckccw1	movlw	Cc
	subwf	MDir,w			;check if moving cc
	skpz
	goto	ckcw1			;nope, so check if moving cw

	doio	CwOData,CwOP		;turn on Cw drive as a break
	goto	brkdly

ckcw1	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	ckifup

	doio	CcOData,CcOP		;turn on Cc drive as a break

brkdly	movlf	NumBrk,BrkCnt		;break for the next NumBrk + the rest of this encoder pulses

ckifup	movlf	AltEnc,FSR			;select Alt encoder to work on

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckifdn			;nope, so check if moving down

	call01	Inc24			;inc alt encoder position
	goto	encfin

ckifdn	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckifcc			;nope, so check if moving cc

	call01	Dec24			;dec alt encoder
	goto	encfin

ckifcc	movlf	AziEnc,FSR			;select Azi encoder to work on

	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckifcw			;nope, so check if moving cw

	btfss	Flag0,NHemi0			;test if Northern hemishpere
	goto	DoInc			;handle southern hemi

DoDec	call01	Dec24			;dec azi encoder for Cc in northern hemi
	goto	encfin	

DoInc	call01	Inc24			;inc azi encoder for Cc in southern hemi
	goto	encfin

ckifcw	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	encfin			;nope,we should never get here

	btfss	Flag0,NHemi0		;test if Northern hemishpere
	goto	DoDec			;dec Azi encoder for Cw in southern hemi
	goto	DoInc			;inc Azi encoder for Cw in northern hemi

encfin	btfss	Flag0,TMs0			;test if we are looking for the magnet
	goto	tstHj			;no so check if Hj movement and all switches are off
	
	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	dlylus	20			;delay for 20 us as noise filter

	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	dlylus	20			;delay for 20 us as noise filter

	btfsc	MsIP,MsI			;test if magnet found
	goto	tstHj			;no so check if Hj

	bcf	Flag0,TMs0			;found it, so clear looking for magnet flag
	call01	SaveEncs			;save magnet position

setsz1	clr24	MoveSz			;
	incf	MoveSz,f			;set size to 1 to terminate movement on next encoder pulse
	goto	adjenc			;

tstHj	btfss	Flag0,HJob0			;is this a HJob0 movement?
	goto	adjenc			;no so just finish the encoder pulse processing

	call	TSwOff			;test if all switches are off
	skpz				;skip if no switches are on
	goto	adjenc			;switch still on, so let HJ commanded movement continue

	bcf	Flag0,HJob0			;no switches on so turn off HJob0 flag & kill movement
	goto	setsz1			;set size to 1 to terminate movement on next encoder pulse

adjenc	movff	PORTB,EncLst		;save current encoder pulse state

errpbc	bcf	INTCON,RBIF			;clear port B change flag

;-- end specific interrupt handler code --

intfin
	movff	SFSR,FSR			;restore FSR
	movff	sdlyxus,dlyxus		;restore dlyxus
	movff	savePCL,PCLATH		;restore PCLATH
	swapf	saveST,w			;load saved status flags
	movwf	STATUS			;restore status flags
	swapf	saveW,f			;swap nibbles to prepare for next nibble swap into w
	swapf	saveW,w			;restore w without effecting status flags
	retfie				;go back to where we came from with interrupts enabled	

;------------------------------------------------------------
; 24 bit unsigned integer calculation procedures
;------------------------------------------------------------

AbsDiff					;calc abs(AA-BB)
	copy24	AA,TmpEnc			;save AA for later use
	bcf	Flag2,BGtrA			;remember BB<=AA
	ifBleqA	absexit			;do AA-BB, if BB <= AA then branch

absrev	bsf	Flag2,BGtrA			;remember BB>AA
	copy24	BB,AA			;BB > AA so swap
	copy24	TmpEnc,BB			;load old AA
	call	Sub24			;do sub and exit with difference in AA

absexit	copy24	AA,AbsDif			;save abs difference
	return
	
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
					;and fall through to do a Sub24
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

dlyus	nop				;entry for dlylus macro wih delay value in dlyxus, loop time 2us
	decfsz	dlyxus,f			;dec ms count & test for zero
	goto	dlyus			;no - so do it again
	nop				;
	return				;ius exit

;---------------------------------------

Dly1sec
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms

;------------------------------------------------------------

Dly250ms
	movlw	250			;delay for 250ms

;----------------------------------------

DlyWMs					;delay for w * ms
	movwf	dlyxms			;save ms loop count

doxms	movlf	(2000-10)/8,dlyxus		;load delay 1ms constant

d1ms	nop				;1 op, 0.5 us
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

DlyWSec	movwf	dlyxsec			;delay w seconds

nxtsec	call	Dly1sec			;wait for 1 second
	decfsz	dlyxsec,f			;count down the seconds
	goto	nxtsec			;not zero yet
	return				;finally we have waited w seconds
	
;----------------------------------------
; SunCube sky point control procedures
;--------------------------------------------------

GotoAziSky
	clrGIE				;stop ints changing AziSky
	copy24	AziSky,AziTarget		;setup to move to current AziSky
	setGIE				;allow ints to change AziSky

GotoAziTarget				;move the SunCube to AziTarget
	movlf	Cc,MDir			;if AziTarget >= AziEnc we move Cc
	copy24	AziTarget,AA		;load AziTarget to AA
	copy24	AziEnc,BB			;load AziEnc to BB
	ifBleqA	mazi1			;branch if AziEnc<=AziTarget

	movlf	Cw,MDir			;AziEnc > AziTarget so we move Cw
	copy24	AziEnc,AA			;load AziEnc to AA
	copy24	AziTarget,BB		;load AziTarget to BB
	call	Sub24			;do AziEnc-AziTarget

mazi1	copy24	AA,MoveSz			;save move size & leave it in AA
	set24	Deg180,BB			;set BB to max move size
	ifBgtrA	ckazidir			;branch if Deg180>MoveSz
	
	set24	Deg360,AA			;set AA to Deg360
	copy24	MoveSz,BB			;set BB to move size
	call	Sub24			;move too big so do Deg360-MoveSz to get the correct move size
	copy24	AA,MoveSz			;save adjusted move size
	call	SwapCcCw			;swap azi drive direction

ckazidir	btfss	Flag2,DoingTat		;test if this azisky movement is a tat adjustment
	goto	mazi3			;no so branch

	btfss	Flag1,RetroTAT		;skip if doing a retro tat adj
	goto	ckdirCc			;no so check for a normal tat dir

	movlw	Cw			;we are doing a retro tat, so test if asked to move Cw
	subwf	MDir,w			;do the test
	skpz				;skip if going Cw
	return				;going Cc so exit to terminate the movement
	goto	mazi3			;direction is ok

ckdirCc	movlw	Cc			;we are doing a normal tat, so test if moving Cc
	subwf	MDir,w			;do the test
	skpz				;skip if going Cc
	return				;going dn so exit to terminate the movement

mazi3	movf	MoveSz+2,f			;test if move too small (<32 encoder pulses)
	skpz				;z so check next byte
	goto	mazi4			;nz so move big enough to do


	movf	MoveSz+1,f			;test if nz
	skpz				;z so check next byte
	goto	mazi4			;nz so move big enough

	movfw	MoveSz			;test if big enough
	andlw	0xe0			;is it at least 32 encoder pulses?
	skpz				;requested move is <32 encoder pulses
	goto	mazi4			;move size is not too small
	return				;no so just exit

mazi4	copy24	MoveSz,AA			;load AA with requested move size
	set24	(Deg180+10),BB		;load BB with max move size + 10
	ifBgtrA	mszok			;branch if MaxMoveSz>MoveSz

	set24	Deg1.0,MoveSz		;move too big, so limit the error to 1 deg encoder pulses

mszok	goto	MoveCubie			;make it happen and jump to MoveCubie to save stack depth

;----------------------------------------

GotoAltSky
	clrGIE				;stop ints changing AltSky
	copy24	AltSky,AltTarget		;setup to move to current AltSky
	setGIE				;allow ints to change AltSky

GotoAltTarget				;move the SunCube to AltTarget
	movlf	Dn,MDir			;AziEnc >= AltTarget so we move Dn
	copy24	AltEnc,AA			;load AltEnc
	copy24	AltTarget,BB		;load AltTarget
	ifBleqA	malt1			;branch if AltTarget <= AltEnc

	movlf	Up,MDir			;AziEnc < AltTarget so we move Up
	copy24	AltTarget,AA		;
	copy24	AltEnc,BB			;
	call	Sub24			;do AltTarget-AltEnc

malt1	copy24	AA,MoveSz			;save move size
	set24	Deg180,BB			;set BB to max move size
	ifBgtrA	ckaltdir			;branch if Deg180>MoveSz
	
	set24	Deg360,AA			;set AA to Deg360
	copy24	MoveSz,BB			;set BB to move size
	call	Sub24			;move too big so do Deg360-MoveSz to get the correct size move
	copy24	AA,MoveSz			;save adjusted move size

	movlf	7,temp			;swap alt motor directions because of size adjustment
	movfw	MDir			;MDir to w
	subwf	temp,w			;do temp-Mdir
	movwf	MDir			;sub 7-MDir, 7-4 = 3 or 7-3 = 4	

ckaltdir	btfss	Flag2,DoingTat		;test if this altsky movement is a tat adjustment
	goto	mazi3			;no so branch

	call	TWest			;test if facing west
	skpz				;yes so skip
	goto	ckeast4			;no so do facing east test

	movlw	Dn			;we are West, so test if moving dn
	subwf	MDir,w			;do the test
	skpz				;skip if going dn
	return				;going up so exit to terminate the movement
	goto	mazi3			;direction is ok, so branch

ckeast4	movlw	Up			;we are East, so test if moving up
	subwf	MDir,w			;do the test
	skpz				;skip if going up
	return				;going dn so exit to terminate the movemen
	goto	mazi3			;direction and size adjusted so jump to common exit

;----------------------------------------
; Motor drive & management procedures
;--------------------------------------------------

CkEnc					;check for a valid encoder pulse, only called by int controller
	movfw	PORTB			;read state of encoder pulses
	andwf	EncSel,w			;isol encoder bit to test
	movwf	tempi			;save it for a moment
	movfw	EncLst			;load last state of encoder pulses
	andwf	EncSel,w			;isol encoder bit to test
	subwf	tempi,w			;test if the proper encoder pulse changed state
	return

;--------------------------------------------------

SwapCcCw					;swap azi motor drive direction
	movlf	3,temp			;swap azi motor directions for northern hemisphere
	movfw	MDir			;MDir to w
	subwf	temp,w			;do temp-Mdir
	movwf	MDir			;sub 3-MDir, 3-2 = 1 or 3-1 = 2
	return

;----------------------------------------

CkMRetro					;check if we need to do a retro track azi adj and if so do it
	movlw	3			;
	subwf	MDir,w			;test if alt or azi
	skpnc				;skip if MDir = 1 or 2 (azi)
	goto	MoveCubie			;jump if MDir = 3 or 4 (alt)

	btfsc	Flag1,RetroTAT		;test if last TAT adj was retro 
	call	SwapCcCw			;yup so swap azi direction
					;and fall through to MoveCubie
;----------------------------------------

MoveCubie					;move to new sky point
	movlw	3			;
	subwf	MDir,w			;test if alt or azi
	skpnc				;skip if MDir = 1 or 2 (azi)
	goto	AbsMSc			;jump if MDir = 3 or 4 (alt)

	btfsc	Flag0,NHemi0		;test if Northern hemisphere
	call	SwapCcCw			;yup so swap normal azi direction

;----------------------------------------

AbsMSc					;alernative call to bypass hemisphere Cw/Cc switching
;	movlf	6,EncTOCnt			;set encoder timeout to 1 sec to detect stuck motor, each encoder pulse also set it
	copy24	MoveSz,SMoveSz		;save motor movement size for later use

	clrGIE				;disable ints
	doio	EncOn,PORTA			;set encoder power bits to on

	movlf	AltSel,EncSel		;use alt encoder
	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckdn			;nope, so check if moving down

	doio	UpOData,UpOP		;turn on Up drive
	goto	wmtroff

ckdn	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckcc			;nope, so check if moving ccw

	doio	DnOData,DnOP		;turn on Down drive
	goto	wmtroff

ckcc	movlf	AziSel,EncSel		;use azi encoder
	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckcw			;nope, so check if moving cw

	doio	CcOData,CcOP		;turn on Cc drive
	goto	wmtroff

ckcw	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpnz				;skip if no know dir found
	goto	setcw
	
	setGIE				;turn ints back on because
	return				;we should never get here

setcw	doio	CwOData,CwOP		;turn on Cw drive

wmtroff	dlylus	25			;delay encoder interrupt enable by 25 us to filter out motor on noise
	movff	PORTB,EncLst		;latch port B & save current encoder states
	bcf	INTCON,RBIF			;clear port b change flag
	bsf	INTCON,RBIE			;enable encoder pulse interrupts
	bsf	Flag0,MRun0			;flag we have a motor running
	movlf	3,EncTOCnt			;set missing encoder pulse timeout to 500 - 750 ms
	setGIE				;enable ints

wmtr	btfss	Flag0,MRun0			;test if motor still running
	goto	mtrfin			;no so finish up motor stopped

	movf	EncTOCnt,f			;test if gap between encoder pulses is > 250 - 500 ms (motor stalled)
	skpz				;yes so skip and turn off a stalled motor
	goto	wmtr			;not yet, so wait and test some more

	doio	EncOn,PORTA			;turn off azimuth motor but leave encoders powered on
	doio	0,PORTB			;turn off altitude motor

mtrfin	dlylms	250			;delay 250 ms to be sure motor has really stopped	
	bcf	INTCON,RBIE			;disable encoder pulse interrupts
	return

;---------------------------------------

EncPOff
	doio	EncOff,PORTA		;turn off encoder power bits
	dlylms	5			;wait for encoders to turn off
	return

;----------------------------------------
; Tracking procedures
;----------------------------------------

UpDateSky
	call	UpDateAziSky		;update azisky from azienc
					;fall through to update altsky from altenc
;----------------------------------------

UpDateAltSky
	clrGIE
	copy24	AltEnc,AltSky		;update calculated skypoint to physical
	setGIE				;enable ints
	return

;----------------------------------------

UpDateAziSky
	clrGIE
	copy24	AziEnc,AziSky		;update calculated skypoint to physical
	setGIE				;enable ints
	return

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

TSW					;test if facing South West (z)
	copy24	AziEnc,AA			;load AA with current Azi Encoder value
	set24	Deg90,BB			;load BB with 90 deg encoder value
	ifBgtrA	setzf			;branch if Deg90>AziEnc (z)
	goto	clrzf			;no, so clr z

;----------------------------------------	

TAltGtr90					;test if alt is > 90 deg
	copy24	AltEnc,AA			;load AA with current Alt Encoder value
	set24	Deg90,BB			;load BB with 90 deg encoder value
	ifBleqA	setzf			;branch if Deg90 <= AltEnc (z)
	goto	clrzf			;no, so clr z

;----------------------------------------

TDn					;test if alt below horizon (z)
	copy24	AltEnc,AA			;set up to test altitude
	set24	Deg180,BB			;load values to test if facing up
	ifBleqA	setzf			;branch if Deg180<=AltEnc

clrzf	Zclr				;clear zflag, branched to by many
	return				;just exit

;----------------------------------------

TWest					;test if azi is west, z = west
	copy24	AziEnc,AA			;set up to test azimuth	
	set24	Deg180,BB			;load values to test if facing west
	ifBleqA	clrzf			;branch if Deg180<=Alt/AziEnc

setzf	Zset				;set z flag, branched to by many
	return				;just exit

;----------------------------------------

Nudge					;nudge sc physical position in MDir direction
	movff	MDir,SvDir			;save original nudge direction as hemi swap adj may swap it
	movlf	NudgeCnt,NCnt		;set max nudge count
	call	TSunVdc8			;get current solar voltage

Nagn	movff	SvDir,MDir			;restore direction from that saved as it may have been swapped due to hemi swap

	call	TSwOff			;test if hand controller not active
	skpz				;skip if no switches active
	goto	clrzf			;goto error exit

	movfw	LokVdc			;set min solar voltage to do "On Sun" lock
	subwf	SunVdc,w			;sub SunVdc - W(LocVdc), c = SunVdc >= LocVdc, nc = SunVdc < LocVdc
	skpc				;skip if the solar voltage is >= min voltage
	goto	clrzf			;solar voltage too low

	decfsz	NCnt,f			;dec max Nudge count
	goto	doN			;skip if another nudge is ok
	goto	clrzf			;flag we have an error (hand job, no edge found or solar voltage too low) & exit

doN	movff	SunVdc,TarVdc		;save last solar voltage as TarVdc
	set24	NudgeSz,MoveSz		;set SunLock nudge size
	call	CkMRetro			;check if we need to do a azi retro track adj then move the SunCube

	call	TAltGtr90			;test if alt locked over the top, > 90 deg (z)
	skpnz				;skip if alt <= 90 deg
	goto	clrzf			;yes so do an error exit

	call	TSunVdc8			;get new solar voltage [10:8], do SunVdc-TarVdc
	skpnc				;skip if SunVdc<TarVdc
	goto	Nagn			;found SunVdc>=TarVdc, so do it again

	dlylms	250			;wait 250ms for solar voltage to stabilize after motor drive
	call	TSunVdc8			;get new solar voltage [10:8], do SunVdc-TarVdc
	skpnc				;skip if SunVdc<TarVdc
	goto	Nagn			;found SunVdc>=TarVdc, so do it again
	goto	setzf			;flag we found an edge (voltage drop) & exit

;----------------------------------------
;
;CkAziLock					;check if we did a large TAT azi movement and need to do a AziLock
;	btfsc	Flag1,FastTrack1		;test if in fast track
;	return				;yes so exit
;	
;	movff	LokVdc,TarVdc		;set min solar voltage to do on sun lock
;	call	TSunVdc8			;get current solar voltage and test if it is high enough
;	skpc				;skip if solar voltage is >= min voltage
;	return				;return if solar voltage is < min voltage, too low to do lock
;
;	movlw	175			;test if AziC adjustment was <= 175
;	subwf	AziC,W			;do the test (f-w)
;	skpc				;skip if AziC > 175
;	return				;no so exit
;
;	nudgesc	Cc			;find peak in Cc direction
;	movsc	Cw,SlopDeg			;reverse direction and remove slop
;
;	nudgesc	Cw			;find peak in Cw direction
;	movsc	Cc,SlopDeg			;reverse direction and remove slop
;
;	goto	UpDateAziSky		;update azisky to new azisky point
;
;------------------------------------------------------------

LoadSize					;setup to check if edge to edge size is big enough
	copy24	AA,MoveSz			;save AA (difference) in MoveSz
	set24	LockSz,BB			;set min SunLock difference to be not an edge lock
	return

;------------------------------------------------------------

CalcCntr
	copy24	MoveSz,AA			;load move size to AA
	call	Div2			;/ 2 to calc distance to the middle
	call	Mult.75			;reduce final move size by 25% to compensate for motor overrun
	copy24	AA,MoveSz			;save move to middle size
	return

;------------------------------------------------------------

LockAzi					;adjust the physical sky point to the max solar voltage
	movlf	SunLkRtyCnt,SunLkRty		;initialize sunlock edge lock retry count
	movlf	1,TatLkCnt			;set Tat cycles to 1 so a lock error will force another try on the next TAT cycle
	call	TSunVdc8			;get current solar voltage
	movff	SunVdc,SLokVdc		;save solar voltage at the start of the SunLock attempt

rtylockazi
	nudgesc	Cw			;find first edge going Cw
	skpz				;skip if we found an edge
	goto	badazilk			;we are lost so check for retry

	movsc	Cc,SlopDeg			;compensate for worm gear back lash and move away from edge
	nudgesc	Cc			;find first real edge
	skpz				;skip if we found an edge
	goto	badazilk			;we are lost so check for retry

	copy24	AziEnc,TmpEnc		;save first Cc (high azi) edge position

	movsc	Cw,SlopDeg			;compensate for worm gear back lash and move away from edge
	nudgesc	Cw			;find second edge
	skpz				;skip if we found an edge
	goto	badazilk			;we are lost so check for retry

	copy24	TmpEnc,AziTarget		;load TmpEnc, sb higher Cc edge
	call01	BumpAziTarget		;if necessary make AA >= 180 deg
	copy24	AziTarget,TmpEnc		;save it

	copy24	AziEnc,AziTarget		;load AziEnc, sb lower Cw edge
	call01	BumpAziTarget		;if necessary make AA >= 180 deg

	copy24	AziTarget,AA		;load AA with adjusted AziEnc edge
	copy24	TmpEnc,BB			;load BB with adjusted TmpEnc edge
	call	AbsDiff			;get AA = abs(AA-BB)
	call	LoadSize			;check if edge size diff is big enough to be real
	ifBleqA	azimok			;branch difference is ok

badazilk
	call	TSunVdc8			;get current solar voltage
	movfw	SLokVdc			;load start of lock solar voltage
	subwf	SunVdc,w			;sub SunVdc - W(SLokVdc), c = SunVdc >= SLokVdc, nc = SunVdc < SLokVdc
	skpc				;skip restore to TAT (start azi sky point) if SunVdc >= SLokVdc as we are closer to the sun!
	call	GotoAziSky			;lock failed and lower solar voltage, so restore azi sky point from TAT before next lock attempt

	decfsz	SunLkRty,f			;dec sunlock retry count
	goto	rtylockazi			;go to try it one more time
	goto	clrzf			;exit with zero flag reset to signal lock failed

azimok
	call	CalcCntr			;calc move size to get into the centre of the SPA
	movlf	Cc,MDir			;set azi lock final direction	
	call	CkMRetro			;make it happen with retro tat track adjusted
	movsc	Cc,SlopDeg			;make an additional move to adjust for motor slop

	call	UpDateAziSky		;update azisky from encoder point
	call	SetTatsPerLk		;set TAT cycles between on sun locks
	goto	setzf			;set Z to flag we did a good SunLock & exit

;------------------------------------------------------------

LockAlt					;now do altitude sun lock
	movlf	SunLkRtyCnt,SunLkRty		;initialize sunlock edge lock retry count
	movlf	1,TatLkCnt			;set Tat cycles to 1 so a lock error will force another try on the next TAT cycle
	call	TSunVdc8			;get current solar voltage
	movff	SunVdc,SLokVdc		;save solar voltage at the start of the SunLock attempt

	call	TWest			;z = west, tracking down
	skpnz				;skip to handle east alt lock
	goto	lockwest			;branch to handle west alt lock

lockeast
	nudgesc	Dn			;find first edge of the East sun
	skpz				;skip if we found an edge
	goto	badaltelk			;we are lost so check for retry

	movsc	Up,SlopDeg			;compensate for any worm gear back lash and move away from edge
	nudgesc	Up			;find first real edge
	skpz				;skip if we found an edge
	goto	badaltelk			;we are lost so check for retry

	movsc	Dn,SlopDeg			;compensate for any worm gear back lash and move away from edge
	nudgesc	Dn			;find second edge
	skpz				;skip if we found an edge
	goto	badaltelk			;we are lost so check for retry

	copy24	TmpEnc,AA			;load TmpEnc, sb bigger (up)
	copy24	AltEnc,BB			;load AltEnc, sb smaller (dn)
	call	Sub24			;calc difference
	call	LoadSize			;check if edge size diff is big enough to be real
	ifBleqA	altemok			;branch if difference is ok

badaltelk	call	TAltGtr90			;test if alt locked over the top, > 90 deg (z)
	skpnz				;skip if alt <= 90 deg
	call	GotoAltSky			;yes so move down to old altsky point

	call	TSunVdc8			;get current solar voltage
	movfw	SLokVdc			;load start of lock solar voltage
	subwf	SunVdc,w			;sub SunVdc - W(SLokVdc), c = SunVdc >= SLokVdc, nc = SunVdc < SLokVdc
	skpc				;skip restore to TAT (start alt sky point) if SunVdc >= SLokVdc as we are closer to the sun!
	call	GotoAltSky			;lock failed and lower solar voltage, so restore alt sky point from TAT before next lock attempt

	decfsz	SunLkRty,f			;dec sunlock retry count
	goto	lockeast			;go to try it one more time
	goto	clrzf			;exit with zero flag reset to signal lock failed

altemok	movlf	Up,MDir			;set final lock move direction direction	
	goto	finlockalt			;goto finish LockAlt

;------------------------------------------------------------

lockwest					;handle alt lock when facing west, tracking down
	nudgesc	Up			;find first edge of West sun
	skpz				;skip if we found an edge
	goto	badaltwlk			;we are lost so check for retry

	movsc	Dn,SlopDeg			;compensate for worm gear back lash and move away from edge
	nudgesc	Dn			;find first real edge
	skpz				;skip if we found an edge
	goto	badaltwlk			;we are lost so check for retry

	copy24	AltEnc,TmpEnc		;save first edge position

	movsc	Up,SlopDeg			;compensate for worm gear back lash and move away from edge
	nudgesc	Up			;find second edge
	skpz				;skip if we found an edge
	goto	badaltwlk			;we are lost so check for retry

	copy24	AltEnc,AA			;load AltEnc, sb bigger (up)
	copy24	TmpEnc,BB			;load TmpEnc, sb smaller (dn)
	call	Sub24			;calc difference
	call	LoadSize			;check if edge size diff is big enough to be real
	ifBleqA	altwmok			;branch difference is ok

badaltwlk	call	TAltGtr90			;test if alt locked over the top, > 90 deg (z)
	skpnz				;skip if alt <= 90 deg
	call	GotoAltSky			;yes so move back down to altsky point

	call	TSunVdc8			;get current solar voltage
	movfw	SLokVdc			;load the solar voltage saved at the start of the lock attempt
	subwf	SunVdc,w			;sub SunVdc - W(SLokVdc), c = SunVdc >= SLokVdc, nc = SunVdc < SLokVdc
	skpc				;skip restore to TAT (start alt sky point) if SunVdc >= SLokVdc as we are closer to the sun!
	call	GotoAltSky			;lock failed and lower solar voltage, so restore alt sky point from TAT before next lock attempt

	decfsz	SunLkRty,f			;dec sunlock retry count
	goto	lockwest			;go to try it one more time
	goto	clrzf			;exit with zero flag reset to signal lock failed

altwmok	movlf	Dn,MDir			;set final lock move direction	

finlockalt	call	CalcCntr			;calc move size to get into the centre of the SPA
	call	MoveCubie			;make it happen
	set24	SlopDeg,MoveSz		;set movement size
	call	AbsMSc			;do an additional move in the same direction as the last to compensate for motor slop

	call	TAltGtr90			;test if alt locked over the top, > 90 deg (z)
	skpnz				;skip if alt <= 90 deg
	call	GotoAltSky			;yes so move down to old altsky point

	call	UpDateAltSky		;update alt sky point from encoder point
	call	SetTatsPerLk		;set TAT cycles between on sun locks
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

	bsf	Flag0,HJob0			;flag this movement can be terminated by all switches being found to be off
	set24	Deg90,MoveSz		;set big off sun movement size
	goto	finhj			;go to common HJ movement starter

smove
	set24	Deg0.05,MoveSz		;set small on sun movement size

finhj
	call	AbsMSc			;do the selected movement using the absolute move entry point

	btfss	Flag1,ResTst1		;test if doing a restore test
	call	UpDateSky			;no, so allow update of sky point from encoder point

	bcf	Flag0,HJob0			;turn off hand job flag if not turned off by int controller
	bsf	Flag1,Do2xLk1		;flag we need to do a 2 axis lock
	goto	setzf			;goto set Z

;----------------------------------------

TSwOff					;test if all switches are off (z)
	movfw	PORTB			;read switches state
	andlw	SwAnd			;isolate switch bits
	sublw	SwAnd			;test if any swithes on, 0 = on / grounded
	return				;z = no, nz = yes

;----------------------------------------

WSwOff					;wait for all switches to be off
	dlylms	100			;debounce switch off
	call	TSwOff
	skpz				;skip if all switches are off
	goto	WSwOff			;no so wait some more

	dlylms	100			;debounce switch off
	call	TSwOff
	skpz				;skip if all switches are off
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

SetIntPerTat
	movlf	IntsPerTat,TatIntCnt		;set up TAT timer downcounter (as defined by the TAT)
	return

;----------------------------------------

SetTodPS
	movlf	IntsPerMin,TodPS		;set timer ints per TOD update (1 minute)	
	return

;----------------------------------------

SetWUpM
	clrGIE
	call	SetWUpMPS			;set wake up minutes pre scaler
	movlf	low(MinutesPerDay),WUpM		;
	movlf	high(MinutesPerDay),WUpM+1	;set sleep down counter to minutes per day (1,440)
	bcf	Flag0,WUpMZ0		;reset wake up minutes zero flag
	setGIE
	return

;----------------------------------------

SetWUpMPS
	movlf	IntsPerMin,WUpMPS		;set timer ints per wake up timer downcount (1 minute)
	return

;----------------------------------------

SetTatsPerLk				;set TAT cycles between On Sun updates
	movlf	TatsPerLk,TatLkCnt		;load TAT cycles between on sun updates
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
	call	SetWUpM			;setup sleep timer
	call	SetIntPerTat		;set up Timer ints per TAT
	call	SetTatsPerLk		;set TAT cycles between on sun updates
	return

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
;####### Start of Code (Main Program) #######
;-----------------------------------------------------------------------

Main					;start of code. Power on jumps to here
	call	SetUpIo			;setup I/O ports & clock
	call	Dly1sec			;delay to stabilize input voltage
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
; Align SunCube to polar and true vertical
;----------------------------------------

CkAlign
	bsf	Flag0,NHemi0		;set to north as default for EMPS search so Cw movement incs AziEnc

	call01	DoAlign			;do Cubie polar alignment while facing the Equator
	clr24	AziEnc			;done so set azi zero

	bsf	Flag0,TMs0			;set test for mag sensor flag
	abssc	Cw,Deg60			;do absolute Cw movement and terminate when azi mag sensor found
	copy24	SAziEnc,MagAzi		;get & save azi EMPS position

	set24	Deg90,AziTarget		;set desired azi target
	call	GotoAziTarget		;move Cubie there

	call01	DoAlign			;do Cubie vertical alignment while facing west
	clr24	AltEnc			;done so set alt zero

	bsf	Flag0,TMs0			;set test for mag sensor flag
	abssc	Dn,Deg60			;do absolute Dn movement and terminate when alt mag sensor found
	copy24	SAltEnc,MagAlt		;get & save EMPS alt position

	call01	GoAlt0			;goto alt 0 to move sensor away from magnet
	call01	GoAzi0			;goto azi 0 to finish this section
	call	UpDateSky			;set axx skypoint from encoders

;----------------------------------------
; Get which hemisphere, Up switch = North, Down switch = South
;----------------------------------------

GetHemi	
	btfsc	CcIP,CcI			;test if Cc switch pushed
	goto	ckhm1			;no so check for down

	bsf	Flag1,FastTrack1		;set fast track flag
	abssc	Cc,Deg3.0			;
	call01	GoAzi0			;show fast track selected
	goto	GetHemi

ckhm1
	btfsc	CwIP,CwI			;test if recalibrate EMPS requested
	goto	ckhm2

	abssc	Cw,Deg3.0			;
	call01	GoAzi0			;show recal selected
	goto	CkAlign			;recalibrate the alignment again

ckhm2
	btfsc	DnIP,DnI			;test if Down requested
	goto	ckhm3			;no so go check if up request

	bcf	Flag0,NHemi0		;Southern hemishpere selected		
	movsc	Dn,Deg3.0			;move sc Down to indicate Southern hemisphere selected
	call01	GoAlt0

	set24	Deg360,AA			;load max azi+1
	copy24	MagAzi,BB			;load EMPS northern hemisphere azimuth
	call	Sub24			;get equivalent southern hemisphere azimuth
	copy24	AA,MagAzi			;save southern hemi azi EMPS position

	goto	saziadj			;finish hemi selection processing

ckhm3
	btfsc	UpIP,UpI			;test if Up requested
	goto	GetHemi			;no so start over again

	bsf	Flag0,NHemi0		;Northern hemisphere selected
	movsc	Up,Deg3.0			;move sc Down to indicate Southern hemisphere selected
	call01	GoAlt0

saziadj
	call	WSwOff			;wait until all switches are turned off

	btfss	Flag1,FastTrack1		;test if fast track requested
	goto	notft			;no so skip it

	set24	FTAzi,AziSky		;set fast track azi
	call	GotoAziSky			;move to first fast track azi
	goto	skipup			;skip going up 30 deg

notft
	set24	(AltCalDeg+Deg10),AltSky	;set first altsky point
	call	GotoAltSky			;go there

skipup
	movlf	MorVdc,LokVdc		;set morning min sun voltage for first sun locks

	setRP0				;select ram bank 1
	clrf	second			;
	clrf	minute			;
	clrf	hour			;clear second, minute & hour to sync TOD to first movement
	clrRP0				;select ram bank 0

	call	SetTmrs			;initialize all timers and down counters
	set24	Deg270,WUpAzi		;set default wake up azi so we point East in the morning if no sun lock on the first day
	bsf	Flag1,TATGo1		;enable TAT calcs

;----------------------------------------
; Finally we get to track the sun
;----------------------------------------

TrackSun					;nudge the motors to track max solar voltage
	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj

	dlylms	250			;debounce jumper
	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj	

	call01	CkSetHome			;do manual encoder recal & return to alt/azisky point with polar cable wrap intack

ckhj	call	HandJob			;check for and do any hand controller input

	btfsc	Flag1,FastTrack1		;are we in fast track mode
	goto	cktat			;yes so skip the 2 axis sunlock request by handjob

	btfsc	Flag1,Do2xLk1		;skip if 2 axis lock not requested by HJ
	goto	dolock			;yes 2 axis lock requested to do it

cktat	btfss	Flag0,DoTAT0		;check if time to adjust physical sky point
	goto	TrackSun			;no, so wait some more

	bcf	Flag0,DoTAT0		;reset DoTAT0 flag, set by int handler after TAT update done

	call	TWest			;test if facing west (z)
	skpz				;skip if facing west (z)
	goto	dotat1			;facing east, so skip facing down test				
	
	btfsc	Flag1,AltCalFin		;have we done a AltCal encoder recalibrate?
	goto	finwest			;yes so don't do it again this day

	call	TAltCal			;test if alt <= AltCal (z)
	skpz				;yes, so recal encoders to get a good value before we hit sleep alt
	goto	finwest			;no, not end of day so just do normal processing

	bsf	Flag1,AltCalFin		;flag we have done alt recal

	btfsc	Flag1,FastTrack1		;test if in fast track
	bcf	Flag1,TATGo1		;doing fast track so stop tat changes

	btfss	Flag0,NHemi0		;skip if in the Northern hemisphere
	goto	clrofazimag			;in the southern hemisphere, the magnet is to the East so just branch

	copy24	AziEnc,AA			;load current azi position
	set24	Deg60,BB			;load azi position clear of the magnet
	ifBleqA	clrofazimag			;no in the possible magnet influence zone so branch 

	copy24	BB,AziTarget		;set new azi target
	call	GotoAziTarget		;move to clear the azi magnet

clrofazimag	call01	ReCalAlt			;recal altenc and adjust altsky
	call	GotoAltSky			;move to adjusted altsky
	call	GotoAziSky			;move to azisky

	btfsc	Flag1,FastTrack1		;test if in fast track
	bsf	Flag1,TATGo1		;doing fast track so restart tat changes

finwest	btfss	Flag1,FastTrack1		;test if in test mode
	goto	slptst			;no so do normal min altitude test

	call	TDn			;test if alt <= 0 deg (z)
	skpnz				;skip if facing above 0 deg (nz)
	goto	EndofDay			;facing west and down, so do end of day
	goto	dotat1			;not below 0 alt so continue

slptst	call	TSleep			;test if alt <= sleep degrees (z)
	skpnz				;skip if facing above sleep alt (nz)
	goto	EndofDay			;facing west and down, so do end of day

dotat1	bsf	Flag2,DoingTat		;flag this is a tat movement to stop anti tat movement
	call	GotoAziSky			;move to TAT calculated azi sky point
;	call	CkAziLock			;check if azi movement was large and we need to do a LockAzi
	call	GotoAltSky			;move to TAT calculated alt sky point
	bcf	Flag2,DoingTat		;clear tat movement flag

	decfsz	TatLkCnt,f			;dec TAT cycles between on sun updates
	goto	tstwest			;not time for sunlock adj so goto tstwest

	btfsc	Flag1,FastTrack1		;test if we are in fast track mode
	goto	tstwest			;yes so skip PeakSun search

	movlf	NorVdc,TarVdc		;set norvdc as min target
	call	TSunVdc8			;get current solar voltage and test if it is high enough to do a sun lock
	skpnc				;solar voltage < NorVdc, so skip
	goto	setnorvdc			;it is >= so branch

	bsf	Flag1,Do2xLk1		;request a 2 axis lock to find the best sun when using MorVdc
	movlf	MorVdc,LokVdc		;set up to use MorVdc voltage

;	btfss	Flag1,AltCalFin		;test if we have done the alt recal
;	bcf	Flag1,Locked		;no so clr the locked flag as we have lost the sun 

	goto	dolock1
	
setnorvdc	movlf	NorVdc,LokVdc		;set min solar voltage to do on sun lock

dolock1	movff	LokVdc,TarVdc		;set min target voltage
	call	TSunVdc8			;get current solar voltage and test if it is high enough to do a sun lock
	skpnc				;skip if solar voltage is < min voltage
	goto	dolock			;solar voltage >= MorVdc

	bcf	Flag1,Do2xLk1		;clear 2 axis lock request
	goto	tstwest			;solar voltage is still too low, so branch past all the sun lock code

;------ time to do a SunLock to update sky point ------

dolock	btfss	Flag1,Do2xLk1		;test if we have we been asked to do a 2 axis lock
	goto	do1xlk			;no so do altering alt/azi 1 axis lock to make on sun lock take less time

	call	LockAlt			;micro adjust the alt sky point to max power
	skpz
	call	GotoAltSky

	call	LockAzi			;micro adjust the azi sky point to max power
	skpz
	call	GotoAziSky

	movff	LokVdc,TarVdc		;set current lokvdc as min target
	call	TSunVdc8			;get current solar voltage and test if it is high enough that we don't need another lock cycle
	skpnc				;solar voltage < LokVdc, so skip as we have not yet found the hot spot
	goto	twoxlkfin			;it is >= so branch

	call	LockAlt			;
	skpz
	call	GotoAltSky

	call	LockAzi			;do another pair to be sure we are there
	skpz
	call	GotoAziSky

twoxlkfin	bcf	Flag1,Do2xLk1		;we just did what was asked, so clear 2 axis lock request
	goto	setlkcnt			;goto set tat count to next lock

do1xlk	btfsc	Flag2,LockTog		;test SunLock tog, 0 = do LockAzi, 1 = do LockAlt
	goto	dolockalt			;goto set lock tog

	bsf	Flag2,LockTog		;set lock tog to flag LockAlt as next lock
	call	LockAzi			;micro adjust the azi sky point to max power
	skpz
	call	GotoAziSky
	goto	setlkcnt

dolockalt	bcf	Flag2,LockTog		;clr lock tog to select LockAzi as next lock
	call	LockAlt			;micro adjust the alt sky point to max power
	skpz
	call	GotoAltSky
	
setlkcnt	call	SetTatsPerLk		;finished lock, so set TAT count until next lock

	movlf	NorVdc,TarVdc		;set min target voltage
	call	TSunVdc8			;get current solar voltage and test if it is high enough to do a sun lock
	skpnc				;skip if solar voltage is < min voltage
	bsf	Flag1,Locked		;solar voltage >= NorVdc so set we got a sunlock flag

tstwest	call	TWest			;test if facing west
	skpz				;skip if facing west
	call	SetWUpM			;as have not crossed solar noon, set sleep minutes to max
	goto	TrackSun

 ;----------------------------------------
; Sleep / End of day processing
;----------------------------------------

EndofDay					;move to overnight stow
	bcf	Flag1,TATGo1		;we are done tracking for the day, so turn off TAT calcs to stop AziSky & AltSky from changing

	btfsc	Flag2,XSolarNoon2		;skip if we did not cross solar noon
	goto	cklocked			;yes we crossed solar noon, so sleep time is ok
					;
	movlf	low(1440/2),WUpM		;	
	movlf	high(1440/2),WUpM+1		;we don't have a valid time sync so set sleep time to 12 hours
					;
cklocked	movff	WUpM,SWUpM			;
	movff	WUpM+1,SWUpM+1		;save today's wake up minutes

	call01	ReCalAzi			;recal azi enc, unwrap retro cable and adjust azisky to get corrected EOD azi
	bcf	Flag2,RetroCbl		;clr retro cable wrap flag
					;
	set24	DegNSlp,AltTarget		;set altsky to night sleep alt
	call	GotoAltTarget		;go there
	bcf	Flag1,AltCalFin		;clr AltCal done flag
					;
	call	EncPOff			;turn off encoder power to save battery power
					;
	btfss	Flag1,Locked		;skip if we had sun and did a sunlock today
	goto	nolock			;no so set default wakeup azi
					;
	bcf	Flag1,Locked		;clr Normal voltage SunLock happened
	movlw	CmpBGtrA			;load w with possible BGtrA bit compliment byte
	btfss	Flag0,NHemi0		;skip if in the Northern hemisphere
	xorwf	Flag2,f			;we are in the Southern hemisphere so compliment the encoder error adjust add/sub flag
					;
	copy24	AziSky,AA			;load recal adjusted true west sleep azisky
	call01	CalcAxx			;adjust west sleep azi
	copy24	AA,BB			;save adjusted west sleep azi
	set24	Deg360,AA			;load max azi+1
	call	Sub24			;calc east wake up azi in AA
	copy24	AA,WUpAzi			;save adjusted wake up East azi
	goto	lockfin			;we have a valid sync to use those sleep time and wake up azi calculations
					;
nolock	set24	FTAzi,WUpAzi		;likewise we have no valid last west azi, so set 270 deg as wake up azi
					;
lockfin	btfss	Flag1,FastTrack1		;test if fast track requested
	goto	wmorning			;no so just wait for morning
					;
	set24	FTAzi,WUpAzi		;set fast track wake up azi
	dlylsec	10			;delay for 10 seconds
	goto	morning			;goto wake up processing

;----------------------------------------
; Morning / Wake up processing
;----------------------------------------

wmorning	btfsc	Flag0,WUpMZ0		;test if wake up delay is zero
	goto	morning			;yup, so wake up and get to work
					;
	bsf	Flag1,ResTst1		;stop HJ changing axxsky
	call	HandJob			;any switch touched?
	skpz				;yup so time to get up and go to work
	goto	wmorning			;wait for morning wakeup call	
					;
morning	call	SetTmrs			;reset all system timers and downcounters

	copy24	WUpAzi,AziSky		;load wakeup azisky
	clr24	AltSky			;set fast track wup alt
					;
	bsf	Flag1,TATGo1		;start the TAT calculations so when we wakeup from sleep we know where the sun is
	bcf	Flag2,XSolarNoon2		;clr crossed solar noon flag as this day is just starting
	bcf	Flag1,Locked		;clr we did a good sunlock flag
					;
	btfss	Flag1,FastTrack1		;test if we are in fast track mode
	goto	notft1			;
					;
wupsleep	bsf	Flag1,Do2xLk1		;set 2 axis lock request for first sunlock
	call	GotoAltSky			;
	call	GotoAziSky			;move to first tast track sky point
	goto	TrackSun			;in fast track so do it
					;
notft1	set24	DegSlp,AltSky		;load on sun wakeup altsky

ckforsun	movlf	WUpVdc,TarVdc		;set min solar voltage, reflected from the ground, to wake up from sleep
	call	TSunVdc8			;get current solar voltage
	skpnc				;skip if solar voltage < WUpVdc
	goto	wupsleep			;the sun is out, so go to work to generate kWhs and earn money for the MAN
					;
	btfss	Flag2,XSolarNoon2		;test if solar noon crossed
	goto	rstime			;we have not yet crossed solar noon so don't do sleep test
					;yes we have crossed solar noon, so test for sleep time
	copy24	AltSky,AA			;load AA with current AltSky
	set24	DegSlp,BB			;load BB with sleep Alt
	ifBgtrA	morning			;branch if AltSky >= sleep Alt as the TAT says we are at EOD
	goto	dly1min			;no so skip sleep time restore
					;
rstime	call	SetWUpM			;sync the WUpM prescaler
	movff	SWUpM,WUpM			;
	movff	SWUpM+1,WUpM+1		;restore saved wake up minutes
					;
dly1min	bsf	Flag1,ResTst1		;stop HJ changing axxsky
	call	HandJob			;any switch touched?
	skpnz				;no, so not time to get up & go to work
	goto	wupsleep			;wake and go to work sleepy head, the MAN needs you to generate kWhs	
	goto	ckforsun			;go to test the solar voltage again

;----------------------------------------
; End Program code for Bank 0
;----------------------------------------
;
;----------- temp storage of useful DEBUG Code -------------
;
;debug
;
;debug1
;	call01	DoAlign
;	call01	ClrEnc
;	call01	DoAlign
;	movlf	50,tempb
;
;debug2
;	movsc	Up,Deg0.10
;	movsc	Dn,Deg0.10
;	decfsz	tempb,f
;	goto	debug2
;
;	call01	GoAlt0
;	goto	debug1	
;
;end
;
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
;	bsf	Flag0,DoDump0		;turn on diagnostic data dump
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
;
;	movsc	Cw,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;	movsc	Cc,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;
;	btfss	Flag0,DoTAT0	
;	goto	debug1
;
;	movsc	Dn,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;	movsc	Dn,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;
;debug1
;	btfss	Flag1,FastTrack1	
;	goto	debug2
;
;	movsc	Up,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;	movsc	Up,Deg0.50			;debug output so we can see we got here
;	dlylms	250			;delay 250ms so we can see if 1 or 2 moves were done
;
;debug2
