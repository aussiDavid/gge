

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
; Set up for CPU type
;-----------------------------------------------------------------------

	LIST P=PIC16f88,R=DEC,f=INHX32
	#include p16f88.inc


;-----------------------------------------------------------------------
; Set up for CPU power on configuration
;-----------------------------------------------------------------------

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


;-----------------------------------------------------------------------
; Physical movement equates
;-----------------------------------------------------------------------

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
#define	AnalA	b'00000011'			;initial port A analog, 1=analog input
#define	DirA	b'00110011'			;initial port A direction, 0=output,1=input
#define	IntA	b'00000000'			;initial port A data

#define	EncOn	b'00001100'			;used to turn on encoder power outputs
#define	EncOff	b'00000000'			;used to turn off encoder power outputs


;-----------------------------------------------------------------------
; Port B defines
;-----------------------------------------------------------------------

#define	PB0	0			;unused
#define	PB0P	PORTB

#define	HJOn	1			;hand controller status, 1 = active
#define	HJOnP	PORTB

#define	Rd	2			;receive data input
#define	RdP	PORTB

#define	Td	3			;transmit data output
#define	TdP	PORTB

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
#define	DirB	b'11000111'			;initial port B direction, 0=output,1=input
#define	IntB	b'00000000'			;initial port B data
 
#define	AziSel	b'10000000'			;select azi encoder pulse
#define	AltSel	b'01000000'			;select alt encoder pulse


;-----------------------------------------------------------------------
; Switch bits defines
;-----------------------------------------------------------------------

#define	DnSw	0			;Dn (down) switch, low = switch closed
#define	UpSw	1			;Up (up) switch, low = switch closed
#define	CcSw	2			;Cc (counter clockwise) switch, low = switch closed
#define	CwSw	3			;Cw (clock wise) switch, low = switched closed

#define	SwAnd	b'00001111'			;input switch bits, 1 = off


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

SAA	:3	
SBB	:3				;used to save AA and BB during interrupts


;--------------------------------
; Pointing variables
;--------------------------------

AltSun	:3				;altitude sky point
AltSunS	:3				;last AltSun from 24F
AltTarget	:3				;alt to move to
AltEnc	:3				;altitude encoder position 0 - 139,999

AziSun	:3				;azimuth sky point
AziSunS	:3				;last AziSun from 24F
AziTarget	:3				;azi to move to
AziEnc	:3				;azimuth encoder position 0 - 139,999

AbsDif	:3				;Abs encoder pulse error size
MoveSz	:3				;desired encoder movement (0 - 139,999 pulses)
SMoveSz	:3				;saved last motor move size
TmpEnc	:3				;saved encoder position for edge detection


;------------------------
; Comm variables
;------------------------

baud	:1				;baud delay loop counter
bitcnt	:1				;bits to send counter
rcvchr	:1				;receive character bit rotate buffer
xmtchr	:1				;send character bit rotate buffer
bcdchr	:1				;used to pack 2 received ascii into bcd
xmtcnt	:1				;count of send bytes, used to fire up the Adc during long sends


;------------------------
; time variables
;------------------------

TatIntCnt	:1				;timer ints per TAT update down counter
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
SLokVdc	:1				;solar voltage at the start of a SunLock attempt


;------------------------
; Misc variables
;-----------------------

temp	:1				;
temp1	:1				;
tempb	:1				;
tempw	:1				;temps

TatLkCnt	:1				;TAT cycles between on sun updates
SwBits	:1				;switch clone byte from 24F
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

	cblock	(ramint+16)-09		;start of bank insensitive ram

saveW	:1				;save W >>>>>KEEP AS FIRST VARIABLE<<
saveST	:1				;save STATUS
savePCL	:1				;save PCLATH
tempi	:1				;used in int handler
AA	:3				;24 bit math input
sdlyxus	:1				;saved dlyxus
SFSR	:1				;saved FSR, used by TOD, 24 bit inc and dec

	endc

B0Avil	equ	saveW-NCnt-1		;amount of ram left in bank 0


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

HJob0	equ	0			;flag for Hand Job big motor movement request
MRun0	equ	1			;any motor running flag
DoTAT0	equ	2			;TAT timer interrupt sets the TAT track adjust flag
NHemi0	equ	3			;hemisphere, 1 = North
DoDump0	equ	4			;do a diagnostic data dump after every track adjust


;-----------------------------------------------------------------------
; Flag1 bit equates
;-----------------------------------------------------------------------

FastTrack1	equ	0			;fast track test mode flag
RetroTAT	equ	1			;retro azi movement flag
DoSunLk1	equ	2			;do a 2 axis sun lock


;-----------------------------------------------------------------------
; Flag2 bit equates
;-----------------------------------------------------------------------

RetroCbl	equ	0			;we did a retro cable wrap as we crossed solar noon
DoingTat	equ	1			;flag this axxsky goto is a tat movement

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

SendR	macro				;convert nibble in lsb of w into ascii and send it down the line

	andlw	0x0f			;zap w[7:4] to 0 (ms nibble)
	iorlw	0x30			;make it a ascii number by oring in 0x30
	call	Send8n			;send it down the line
	endm

;----------------------------------------

SndL	macro	lit			;send literal

	movlw	lit			;load lit to send
	call	Send8n			;send it
	movlw	','			;load deliminiter
	call	Send8n			;send it as well
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

DlyHB	macro				;delay for 1/2 9600 baud rate (52 us)
	movlf	((52*2)-16)/3,baud		;load delay for 1/2 9600 baud time
	decfsz	baud,f			;dec loop counter & test for zero
	goto	$-1
	endm

;----------------------------------------

DlyB	macro				;delay for 9600 baud rate (104 us)
	movlf	((104*2)-10)/3,baud		;load delay for 9600 baud
	decfsz	baud,f			;dec loop counter & test for zero
	goto	$-1			;no - so do it again
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

	copy24	AA,SAA			;AA saved
	copy24	BB,SBB			;BB saved

	btfss	PIR1,TMR1IF			;is this a timer overflow interrupt?
	goto	tstpbc			;no so handle encoder interrupt


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

;-- Handle encoder timeout timer ----------------------------

	movf	EncTOCnt,f			;test if z	
	skpz				;yup so skip dec
	decf	EncTOCnt,f			;dec encoder pulse inter gap timeout detector (stalled/no motor)
			
;-- Handle track adjust timer--------------------------------

	decfsz	TatIntCnt,f			;dec timer ints until next TAT update
	goto	intfin			;not zero so just dec it

	call	SetTatIntCnt		;set num of Tmr Ints per TAT update
	bsf	Flag0,DoTAT0		;set DoTAT0 flag so the outer loop has something to do
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

decenc1	copy24	MoveSz,AA			;set pointer to MoveSz
	call	Dec24			;dec enc pulses to move
	copy24	AA,MoveSz			;update MoveSz

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

ckifup	copy24	AltEnc,AA			;select Alt encoder to work on

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckifdn			;nope, so check if moving down

	call	Inc24			;inc alt encoder position
	copy24	AA,AltEnc			;update AltEnc
	goto	encfin

ckifdn	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckifcc			;nope, so check if moving cc

	call	Dec24			;dec alt encoder
	copy24	AA,AltEnc			;update AltEnc
	goto	encfin

ckifcc	copy24	AziEnc,AA			;select Azi encoder to work on

	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckifcw			;nope, so check if moving cw

	btfss	Flag0,NHemi0			;test if Northern hemishpere
	goto	DoInc			;handle southern hemi

DoDec	call	Dec24			;dec azi encoder for Cc in northern hemi
	copy24	AA,AziEnc			;update AziEnc
	goto	encfin	

DoInc	call	Inc24			;inc azi encoder for Cc in southern hemi
	copy24	AA,AziEnc			;update AziEnc
	goto	encfin

ckifcw	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	encfin			;nope,we should never get here

	btfss	Flag0,NHemi0		;test if Northern hemishpere
	goto	DoDec			;dec Azi encoder for Cw in southern hemi
	goto	DoInc			;inc Azi encoder for Cw in northern hemi

encfin	btfss	Flag0,HJob0			;is this a HJob0 movement?
	goto	adjenc			;no so just finish the encoder pulse processing

	btfsc	HJOnP,HJOn			;test if any switch active
	goto	adjenc			;switch still on, so let HJ commanded movement continue

	bcf	Flag0,HJob0			;no switches on so turn off HJob0 flag & kill movement

	clr24	MoveSz			;
	incf	MoveSz,f			;set size to 1 to terminate movement on next encoder pulse

adjenc	movff	PORTB,EncLst		;save current encoder pulse state

errpbc	bcf	INTCON,RBIF			;clear port B change flag

;-- end specific interrupt handler code --

intfin
	copy24	SAA,AA			;AA restored
	copy24	SBB,BB			;BB restored

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
	ifBleqA	absexit			;do AA-BB, if BB <= AA then branch

absrev	copy24	BB,AA			;BB > AA so swap
	copy24	TmpEnc,BB			;load old AA
	call	Sub24			;do sub and exit with difference in AA

absexit	copy24	AA,AbsDif			;save abs difference
	return

;------------------------------------------------------------	

Inc24					;inc encoder count, only called by int handler
	movlw	Max1			;test if enc at max
	subwf	AA,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc encoder value

	movlw	Max2			;load next value to test
	subwf	AA+1,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc encoder value

	movlw	Max3			;load that bytes max value
	subwf	AA+2,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc it

	clr24	AA			;encoder inced and rolled over to zero
	return				;so finally return	

inc241
	incfsz	AA,f			;inc lsb
	return				;return if no overflow

	incfsz	AA+1,f	 		;inc lsb+1
	return				;return if no overflow

	incf	AA+2,f			;simple inc lsb+2 will do here
	return				;finished here, so return

;----------------------------------------

Dec24					;dec encoder count, only called by interrupt handler
	movfw	AA			;test if lsb is zero
	iorwf	AA+1,w			;test if lsb+1 is zero
	iorwf	AA+2,w			;test if lsb+2 is zero
	skpz				;yes so test next byte
	goto	dec241			;no so go to dec it

	set24	Max1,AA			;set max value
	return				;with encoder at max as a result of a underflow

dec241
	movlw	1			;seed to test for underflow (nc) on subtract
	subwf	AA,f			;dec lsb
	skpnc				;test for nc / underflow
	return				;none so exit

	subwf	AA+1,f			;dec lsb+1
	skpnc				;test for nc / underflow
	return				;none so exit

	decf	AA+2,f			;simple dec of lsb+2 will do here
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

GotoAziSun
	clrGIE				;stop ints changing AziSun
	copy24	AziSun,AziTarget		;setup to move to current AziSun
	setGIE				;allow ints to change AziSun

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

GotoAltSun
	clrGIE				;stop ints changing AltSun
	copy24	AltSun,AltTarget		;setup to move to current AltSun
	setGIE				;allow ints to change AltSun

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

	call	TSWest			;test if facing west
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
					;fall through to turn off the encoder power
;---------------------------------------

EncPOff
	doio	EncOff,PORTA		;turn off encoder power bits
	dlylms	5			;wait for encoders to turn off
	return

;----------------------------------------
; Tracking procedures
;----------------------------------------

BumpAziTarget				;make target >= 180 deg
	copy24	AziTarget,AA		;load target address
	set24	(Deg180-1),BB		;load deg180-1
	ifBleqA	nobump			;if AA<=BB no need to bump it up

	copy24	AziTarget,AA		;reload target
	call	Add24			;make AA >= 180 deg
	copy24	AA,AziTarget		;make targetazi >= 180

nobump
	return

;----------------------------------------

GoAlt0					;drive to alt 0 
	clr24	AltTarget			;set target alt to zero
	call	GotoAltTarget		;make it happen

tstup
	call	TDn			;test if we are pointing down (z)
	skpz				;facing down, so skip
	return				;facing up so exit

	movsc	Up,Deg0.10			;facing down so nudge it up a bit
	goto	tstup			;test if we are up yet

;----------------------------------------

GoAzi0
	clr24	AziTarget			;set target azi to 0
	call	GotoAziTarget		;make it happen
	bcf	Flag1,RetroTAT		;reset RetroTAT flag to stop movsc moving in the wrong direction

tstw
	call	TWest			;test if we are pointing west (z)
	skpnz				;facing east, so skip
	return				;facing west so exit

	movsc	Cc,Deg0.10			;facing east so nudge it west a bit
	goto	tstw			;test if we are west yet

;----------------------------------------

DoAlign					;move the SunCube to do physical alignment
	btfsc	FsIP,FsI			;skip if jumper installed
	goto	DoAlign			;jumper NOT installed, so go wait for it to happen

	call	Dly1sec			;debounce jumper installation
	btfsc	FsIP,FsI			;skip if jumper installed
	goto	DoAlign			;jumper NOT installed, so go wait for it to happen

ckalign
	btfsc	FsIP,FsI			;test if we are aligned
	goto	ckalign2			;yes so zero & store encoders

	call	HandJob			;allow hand controller to move & align SunCube
	goto	ckalign

ckalign2
	call	Dly1sec			;debounce jumper removal

	btfss	FsIP,FsI			;test if we are aligned
	goto	ckalign			;no so allow more movement
	call	ClrEnc			;set new encoder reference point
	return				;yes so exit

;------------------------------------------------------------

ClrSky					;set axxsky to zero
	clr24	AltSun			;clear altsky
	clr24	AziSun			;clear azisky
	return

;------------------------------------------------------------

ClrEnc
	clr24	AltEnc			;
	clr24	AziEnc			;set axxenc to zero
	return

;-----------------------------------------------------------------------


CkSetHome					;show home position and manually adjust if incorrect
	call	GoAlt0			;move to what the alt encoder thinks is Alt 0
	call	GoAzi0			;move to what the azi encoder thinks is Azi 0

	call	DoAlign			;do physical Cubie alignment

	call	GetSunPos			;get latest solar position
	call	GotoAltSun			;move to current AltSun
	call	GotoAziSun			;move to current AziSun

	return

;------------------------------------------------------------

UpDateSky
	call	UpDateAziSun		;update azisky from azienc
					;fall through to update altsky from altenc
;----------------------------------------

UpDateAltSun
	copy24	AltEnc,AltSun		;update calculated skypoint to physical
	return

;----------------------------------------

UpDateAziSun
	copy24	AziEnc,AziSun		;update calculated skypoint to physical
	return

;----------------------------------------	

TAltGtr90					;test if alt is > 90 deg
	copy24	AltEnc,AA			;load AA with current Alt Encoder value
	set24	Deg90,BB			;load BB with 90 deg encoder value
	ifBleqA	setzf			;branch if Deg90 <= AltEnc (z)
	goto	clrzf			;no, so clr z

;----------------------------------------

TDn					;test if pointing below the horizon (z)
	copy24	AltEnc,AA			;set up to test altitude
	set24	Deg180,BB			;load values to test if facing up
	ifBleqA	setzf			;branch if Deg180<=AltSun
	goto	clrzf			;no, so clr z

;----------------------------------------

TWest					;test if pointing west, z = west
	copy24	AziEnc,AA			;set up to test azimuth	
	set24	Deg180,BB			;load values to test if sun is west
	ifBleqA	clrzf			;branch if Deg180<=AziSun
	goto	setzf

;----------------------------------------

TSDn					;test if Sun is below the horizon (z)
	copy24	AltSun,AA			;set up to test altitude
	set24	Deg180,BB			;load values to test if facing up
	ifBleqA	setzf			;branch if Deg180<=AltSun (sun below the horizon)

clrzf	Zclr				;clear zflag, branched to by many
	return				;just exit

;----------------------------------------

TSWest					;test if sun is west, z = west
	copy24	AziSun,AA			;set up to test azimuth	
	set24	Deg180,BB			;load values to test if sun is west
	ifBleqA	clrzf			;branch if Deg180<=AziSun

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

	movlw	NorVdc			;set min solar voltage to do "On Sun" lock
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
	call	BumpAziTarget		;if necessary make AA >= 180 deg
	copy24	AziTarget,TmpEnc		;save it

	copy24	AziEnc,AziTarget		;load AziEnc, sb lower Cw edge
	call	BumpAziTarget		;if necessary make AA >= 180 deg

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
	call	GotoAziSun			;lock failed and lower solar voltage, so restore azi sky point from TAT before next lock attempt

	decfsz	SunLkRty,f			;dec sunlock retry count
	goto	rtylockazi			;go to try it one more time
	goto	clrzf			;exit with zero flag reset to signal lock failed

azimok
	call	CalcCntr			;calc move size to get into the centre of the SPA
	movlf	Cc,MDir			;set azi lock final direction	
	call	CkMRetro			;make it happen with retro tat track adjusted
	movsc	Cc,SlopDeg			;make an additional move to adjust for motor slop

	call	UpDateAziSun		;update azisky from encoder point
	call	SetTatsPerLk		;set TAT cycles between on sun locks
	goto	setzf			;set Z to flag we did a good SunLock & exit

;------------------------------------------------------------

LockAlt					;now do altitude sun lock
	movlf	SunLkRtyCnt,SunLkRty		;initialize sunlock edge lock retry count
	movlf	1,TatLkCnt			;set Tat cycles to 1 so a lock error will force another try on the next TAT cycle
	call	TSunVdc8			;get current solar voltage
	movff	SunVdc,SLokVdc		;save solar voltage at the start of the SunLock attempt

	call	TSWest			;z = west, tracking down
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
	call	GotoAltSun			;yes so move down to old altsky point

	call	TSunVdc8			;get current solar voltage
	movfw	SLokVdc			;load start of lock solar voltage
	subwf	SunVdc,w			;sub SunVdc - W(SLokVdc), c = SunVdc >= SLokVdc, nc = SunVdc < SLokVdc
	skpc				;skip restore to TAT (start alt sky point) if SunVdc >= SLokVdc as we are closer to the sun!
	call	GotoAltSun			;lock failed and lower solar voltage, so restore alt sky point from TAT before next lock attempt

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
	call	GotoAltSun			;yes so move back down to altsky point

	call	TSunVdc8			;get current solar voltage
	movfw	SLokVdc			;load the solar voltage saved at the start of the lock attempt
	subwf	SunVdc,w			;sub SunVdc - W(SLokVdc), c = SunVdc >= SLokVdc, nc = SunVdc < SLokVdc
	skpc				;skip restore to TAT (start alt sky point) if SunVdc >= SLokVdc as we are closer to the sun!
	call	GotoAltSun			;lock failed and lower solar voltage, so restore alt sky point from TAT before next lock attempt

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
	call	GotoAltSun			;yes so move down to old altsky point

	call	UpDateAltSun		;update alt sky point from encoder point
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

cksw	movf	SwBits,f			;test if SwBits = 0 (comm error)
	skpnz				;skip if valid HJ byte
	return

	movlf	Dn,MDir			;yes so set direction
	btfss	SwBits,DnSw			;test if Down requested
	goto	dohj			;go to common HJ stuff

	movlf	Up,MDir			;yes so set direction
	btfss	SwBits,UpSw			;test if Up requested
	goto	dohj			;goto common HJ stuff

	movlf	Cw,MDir			;yes so set direction
	btfss	SwBits,CwSw			;check if Cw requested
	goto	dohj			;goto common HJ stuff

	movlf	Cc,MDir			;yes so set direction
	btfss	SwBits,CcSw			;test if Cc requested
	goto	dohj			;goto common HJ stuff
	goto	clrzf			;no switches on so exit with nz

dohj	movlw	HJsCnt			;
	subwf	HJs,w			;test if HJs is gtr than 10
	skpc				;skip if HJs >10
	goto	hjsok			;branch if Hjs <=10

	movlf	HJsCnt,HJs			;ensure only 10 small HJ moves until the big one

hjsok	decfsz	HJs,f			;dec small moves downcounter
	goto	smove			;small moves finished so do big ones

	bsf	Flag0,HJob0			;flag this movement can be terminated by all switches being found to be off
	set24	Deg90,MoveSz		;set big off sun movement size
	goto	finhj			;go to common HJ movement starter

smove	set24	Deg0.05,MoveSz		;set small on sun movement size

finhj	call	AbsMSc			;do the selected movement using the absolute move entry point

	bcf	Flag0,HJob0			;turn off hand job flag if not turned off by int controller
	goto	setzf			;goto set Z

;----------------------------------------

TSwOff					;test if all switches are off (z)
	movlf	0x0f,SwBits			;set all sw off state as default
	btfss	HJOnP,HJOn			;test if any switch active flag from 24F is high
	goto	setzf			;no so exit with z set

	movlw	'H'			;request switch status byte
	call	Send8n			;send request to the SuperTAT chip

	call	Recv8n			;get switch status byte
	movwf	SwBits			;got HJ byte so up date our copy
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
; SuperTAT comms procedures
;----------------------------------------

GetSunPos
	copy24	AziSun,AziSunS		;
	copy24	AltSun,AltSunS		;save last 24F SunPos

	movlw	'T'			;request TAT
	call	Send8n			;send request to the SuperTAT chip

	call	Recv8n			;get char
	movwf	AziSun+2			;get SunAz1 (msb) from SuperTAT chip
	call	Recv8n			;get char
	movwf	AziSun+1			;get SunAz2 from SuperTAT chip
	call	Recv8n			;get char
	movwf	AziSun			;get SunAz3 from SuperTAT chip

	call	Recv8n			;get char
	movwf	AltSun+2			;get SunAlt1 (msb) from SuperTAT chip
	call	Recv8n			;get char
	movwf	AltSun+1			;get SunAlt2 from SuperTAT chip
	call	Recv8n			;get char
	movwf	AltSun			;get SunAlt3 from SuperTAT chip

	call	Recv8n			;get hemisphere
	movwf	temp			;save hemi
	bsf	Flag0,NHemi0		;assume north
	btfsc	temp,0			;skip if south
	return

	bcf	Flag0,NHemi0		;we are south, so reset north
	return

;----------------------------------------

Send8n					;sent byte in w as 8N RS232 (low = 1)
	movwf	xmtchr			;save byte to be sent
	movlf	8,bitcnt			;init shift count
	clrGIE				;disable ints during xmit

	bsf	TdP,Td			;set Td high / spacing / 0 for start bit
	DlyB				;delay to send start bit

next8n
	rrf	xmtchr,f			;rotate right lsb into carry
	skpc				;skip if carry set
	goto	dozero8n			;no carry - so send 0
	bcf	TdP,Td			;yes there is a carry - so put 1 on TD line
	goto	dobaud8n			;goto baud delay

dozero8n
	nop				;to make bits symetrical
	bsf	TdP,Td			;put 0 on TD line

dobaud8n
	DlyB				;delay for 1 baud time

	decfsz	bitcnt,f			;test if more bits to send
	goto	next8n			;yes - so do it again

	bcf	TdP,Td			;no - so set td low / marking / 1 for stop bit
	DlyB				;delay for 1 baud time to generate 1 stop bit

	goto	enGIE			;enable ints & exit

;----------------------------------------

Recv8n					;receive 8N byte from inverted RS232 input (low = 1)
	movlf	(50000/((5*256)/2)),temp1	;50 ms no start bit timeout
	clrGIE				;disable ints during recv

wsb	btfsc	RdP,Rd			;test for start bit (Rd line high)
	goto	sbfound			;found start bit

	decfsz	temp,f			;dec minor loop and test = 0
	goto	wsb			;not yet so wait some more

	decfsz	temp1,f			;dec major and test = 0
	goto	wsb			;not yet so wait some more

	clrc				;clear char received flag
	return				;as no sb found for 50 ms

sbfound	DlyHB				;delay for 1/2 baud time
	btfss	RdP,Rd			;test for start bit (Rd line high)
	goto	wsb			;false start bit, go to look again

	bsf	bitcnt,3			;set bit counter to receive 8 bits

r8na
	rrf	rcvchr,f			;rotate partial received comm char right one bit through carry
	DlyB				;yes - so delay full baud to get into middle of next bit
	nop				;
	nop				;
	nop				;delays to make receive same loop time as xmit	
	btfss	RdP,Rd			;test status of Rd, high = 0 bit value
	bsf	rcvchr,7			;set msb of comm ch
	decfsz	bitcnt,f			;test if more bits to receive
	goto	r8na			;yes - so do it

	DlyB				;delay into the middle of the stop bit
	movfw	rcvchr
	clrf	rcvchr			;load w with received char
	setc				;set carry to flag valid character received

	btfsc	RdP,Rd			;skip if stop bit ok
	clrc				;clr c to flag stop bit error

enGIE	setGIE				;enable ints
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

SetTatIntCnt
	movlf	IntsPerTat,TatIntCnt		;set up TAT timer downcounter (as defined by the TAT)
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

	movlf	IntB,PORTB			;set initial port B output state

	setRP0				;select bank 1
	movlf	DirB,TRISB			;initialize port B data direction register (rb1)
	movlw	0x07	

	movwf	OPTION_REG			;enable global weak pullups, T0 clk to cpu & PSA to T0 w/ 256 prescaler (rb1,3)
	clrRP0				;select bank 0
	return

;----------------------------------------

SetTmrs					;set up the various timer values to their initial values
	call	SetTatIntCnt		;set up Timer ints per TAT
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
	call	InitVdc			;initialize the Adc solar input
	call	SetTmrs			;set the various system timers
	call	EnaInt			;set up and enable interrupts
	movlf	HJsCnt,HJs			;set number of small Hand Controller moves before big

	abssc	Up,Deg0.50			;move Dow
	abssc	Dn,Deg0.50			;move Up
	abssc	Cw,Deg0.50			;move Clockwise
	abssc	Cc,Deg0.50			;move Counter clockwise

;----------------------------------------
; Align SunCube to polar and true vertical
;----------------------------------------

	call	DoAlign			;do Cubie polar alignment while facing the Equator
	call	SetTmrs			;initialize all timers and down counters
	bsf	Flag0,DoTAT0		;set DoTat0 to get sun pos data from the SuperTAT chip

;----------------------------------------
; Time to track the sun
;----------------------------------------

TrackSun					;nudge the motors to track max solar voltage
	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj

	dlylms	250			;debounce jumper
	btfsc	FsIP,FsI			;skip if jumper installed (align mode)
	goto	ckhj			;no, so goto check for hj	

	call	CkSetHome			;do manual encoder recal & return to alt/azisky point with polar cable wrap intack
	goto	dolock			;do a sun lock after recal

ckhj	call	HandJob			;check for and do any hand controller input
	skpnz				;skip if no HJ
	goto	dolock			;did HJ so do a sunlock

	btfss	Flag0,DoTAT0		;check if time to adjust physical sky point
	goto	TrackSun			;no, so wait some more
	bcf	Flag0,DoTAT0		;clear do tat flag

	call	GetSunPos			;get AltSun and AziSun solar position from SuperTAT chip
	call	TSDn			;test if sun <= 0 deg (z)
	skpnz				;skip if sun above 0 deg (nz)
	goto	EndofDay			;sun elow the horizon, so do end of day

	bsf	Flag2,DoingTat		;flag this is a tat movement to stop anti tat movement
	call	GotoAziSun			;move to TAT calculated azi sky point
	call	GotoAltSun			;move to TAT calculated alt sky point
	bcf	Flag2,DoingTat		;clear tat movement flag

	decfsz	TatLkCnt,f			;dec TAT cycles between on sun updates
	goto	TrackSun			;not time for sunlock, so go back to work

;------ time to do a SunLock to update sky point ------

dolock	call	SetTatsPerLk		;reset TAT count until next lock
	bcf	Flag1,DoSunLk1		;reset lock request

	movlf	NorVdc,TarVdc		;set min target voltage
	call	TSunVdc8			;get current solar voltage and test if it is high enough to do a sun lock
	skpc				;skip if solar voltage is >= NorLok
	goto	TrackSun			;solar voltage < NorLok, so no sun lock

	call	LockAlt			;micro adjust the sky point to max power
	skpz				;skip if no lock error
	call	GotoAltSun			;lock error so restore to AltSun
					;
	call	LockAzi			;micro adjust the sky point to max power
	skpz				;skip if no lock error
	call	GotoAziSun			;lock error so restore to AziSun
					;
	call	GetSunPos			;get real time sun position
	copy24	AltSun,AltEnc		;update physical position from solar position
	copy24	AziSun,AziEnc		;
	goto	TrackSun			;

;----------------------------------------
; Sleep / End of day processing
;----------------------------------------

EndofDay					;move to overnight stow
 	btfss	Flag2,RetroCbl		;test if we did a retro cable wrap
	goto	pointeast			;no, so skip retro track processing to stop wrapping the power wires around the pole

	bcf	Flag2,RetroCbl		;clear Retro cable wrap flag

	set24	Deg180,AziTarget		;set to point to pole
	call	GotoAziTarget		;move there

pointeast	set24	Deg270,AziTarget		;set to point East
	call	GotoAziTarget		;move there
					;
	set24	DegNSlp,AltTarget		;set altsky to night sleep alt
	call	GotoAltTarget		;go there


;----------------------------------------
; Morning / Wake up processing
;----------------------------------------

wmorning					;test if wake up delay is zero
	btfss	Flag0,DoTAT0		;check if time to adjust physical sky point
	goto	wmorning			;no, so wait some more
	bcf	Flag0,DoTAT0		;clear do tat flag

	call	GetSunPos			;get AltSun and AziSun solar position from SuperTAt chip

	call	TSDn			;test if sun <= 0 deg (z)
	skpnz				;skip if sun above 0 deg (nz)
	goto	wmorning			;sun still below the horizon so wait some more
	goto	TrackSun			;the sun is up, so time to go to work

;----------------------------------------
; End Program code for Bank 0
;----------------------------------------
