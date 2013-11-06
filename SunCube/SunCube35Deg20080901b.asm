
;***********************************************************************
;                            SunCube.ASM                               ;
;                                                                      ;
;                   SunCube Solar PV Firmware                          ;
;                                                                      ;
;    This pogram & the system design of the SunCube are copyright      ;
;                          Greg Watson                                 ;
;                      2005 2006 2007 2008                             ;
;                                                                      ;
;                      All rights reserved                             ;
;***********************************************************************

;-----------------------------------------------------------------------
; Set up for CPU type & power on configuration
;-----------------------------------------------------------------------

	LIST P=PIC16f88,R=DEC,f=INHX32

	#include p16f88.inc

;Program Configuration Register 1
	__CONFIG    _CONFIG1,_CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_IO

;Program Configuration Register 2
	__CONFIG    _CONFIG2,_IESO_OFF & _FCMEN_OFF

;-----------------------------------------------------------------------
; Program creation date and version
;-----------------------------------------------------------------------

#define 	Version			"SunCube(tm) Tracker Firmware Version 20080901,"
#define 	CopyRight 		"Copyright(C) Gren Watson. All rights reserved"

;-----------------------------------------------------------------------
; Memory constants
;-----------------------------------------------------------------------

ram0	equ	0x20			;start of bank 0 ram
ramint	equ	0x70			;start of bank insensitive ram
EeData0	equ	0x2100			;start of ee data memory

;-----------------------------------------------------------------------
; Movement constants
;-----------------------------------------------------------------------

MRatio	equ	100			;motor planetary gear box ratio
SRatio	equ	100			;suncube worm gear ratio
FRatio	equ	MRatio*SRatio		;final gear ratio
PPR	equ	14			;encoder pulse edges per motor rev

Deg360	equ	FRatio*PPR		;pulses per 360 deg movement
Deg180	equ	Deg360/(3600/1800)	;pulses per 180 deg movement
Deg120	equ	Deg360/(3600/1200)	;pulses per 120 deg movement
Deg90	equ	Deg360/(3600/900)	;pulses per 90 deg movement
Deg75	equ	Deg360*10/(36000/750)	;pulses per 75 deg movement
Deg60	equ	Deg360/(3600/600) 	;pulses per 60 deg movement
Deg45	equ	Deg360/(3600/450)	;pulses per 45 deg movement
Deg30	equ	Deg360/(3600/300)	;pulses per 30 deg movement
Deg25	equ	Deg360*10/(36000/250)	;pulses per 25 deg movement
Deg20	equ	Deg360*10/(36000/200)	;pulses per 20 deg movement
Deg15	equ	Deg360*10/(36000/150)  	;pulses per 15 deg movement
Deg11	equ	Deg360*10/(36000/110)	;pulses per 11 deg movement
Deg10	equ	Deg360*10/(36000/100) 	;pulses per 10 deg movement

Deg7.5	equ	Deg360*10/(36000/75)	;pulses per 7.5 deg movement
Deg5.0	equ	Deg360*10/(36000/50)	;pulses per 5.0 deg movement
Deg4.0	equ	Deg360*10/(36000/40)	;pulses per 4.0 deg movement
Deg3.6	equ	Deg360*10/(36000/36)	;pulses per 3.6 deg movement
Deg2.5	equ	Deg360*10/(36000/25)	;pulses per 2.5 deg movement
Deg2.0	equ	Deg360*10/(36000/20)	;pulses per 2.0 deg movement
Deg1.5	equ	Deg360*10/(36000/15)	;pulses per 1.5 deg movement
Deg1.0	equ	Deg360*10/(36000/10)	;pulses per 1.0 deg movement

Deg0.75	equ	Deg360/(36000/75)	;pulses per 0.75 deg movement
Deg0.50	equ	Deg360/(36000/50)	;pulses per 0.5 deg movement
Deg0.40	equ	Deg360/(36000/40)	;pulses per 0.4 deg movement
Deg0.30	equ	Deg360/(36000/30)	;pulses per 0.3 deg movement
Deg0.25	equ	Deg360/(36000/25)	;pulses per 0.25 deg movement
Deg0.20	equ	Deg360/(36000/20)	;pulses per 0.2  deg movement
Deg0.15	equ	Deg360/(36000/15)	;pulses per 0.15 deg movement
Deg0.125 equ	Deg360/(360000/125)	;pulses per 0.125 deg movement
Deg0.10	equ	Deg360/(36000/10)	;pulses per 0.1 deg movement
Deg0.06	equ	Deg360/(36000/06)	;pulses per 0.06 deg movement
Deg0.05	equ	Deg360/(36000/05)	;pulses per 0.05 deg movement
Deg0.04	equ	Deg360/(36000/04)	;pulses per 0.04 deg movement
Deg0.03	equ	Deg360/(36000/03)	;pulses per 0.03 deg movement
Deg0.02	equ	Deg360/(36000/02)	;pulses per 0.02 deg movement
Deg0.01	equ	Deg360/(36000/01)	;pulses per 0.01 deg movement

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

Max1	equ	low(Deg360-1)
Max2	equ	low(Deg360/256)
Max3	equ	Deg360/65536

KCnt	equ	3			;number of TAT adjusts between "On Sun" adjusts
NSz	equ	Deg0.05			;size of nudge steps
MNCnt	equ	Deg2.0/Deg0.05		;no more than 2 degs of "On Sun" nudge cycles as we are then outside the SPA sky point window
NResSz	equ	NSz*MNCnt		;size of lost sun movement back to start

BrkMs	equ	6			;ms of applied reverse voltage to brake motor to a stop

;looking down, from above yoke with electronics box to left

Cw	equ	1			;moving Cw/left,dec enc position
Cc	equ	2			;moving Cc/right,inc enc position

;looking at yoke with electronics box in centre, SunCube pointing to the right

Up	equ	3			;moving	Up,inc enc position
Dn	equ	4			;moving DOWN,dec enc position

;-----------------------------------------------------------------------
; Voltage equates
;-----------------------------------------------------------------------

AdcRuv	equ	5000000/256		;adc resolution in micro volts

Vdc30	equ	(30000000/7800)*1000 	;Vdc after dividers in uv
Adc30V	equ	Vdc30/AdcRuv         	;Adc value
	
Vdc29	equ	(29000000/7800)*1000 	;Vdc after dividers in uv
Adc29V	equ	Vdc29/AdcRuv         	;Adc value
	
Vdc28	equ	(28000000/7800)*1000 	;Vdc after dividers in uv
Adc28V	equ	Vdc28/AdcRuv         	;Adc value
	
Vdc27	equ	(27000000/7800)*1000 	;Vdc after dividers in uv
Adc27V	equ	Vdc27/AdcRuv         	;Adc value
	
Vdc26	equ	(26000000/7800)*1000 	;Vdc after dividers in uv
Adc26V	equ	Vdc26/AdcRuv         	;Adc value
	
Vdc25	equ	(25000000/7800)*1000 	;Vdc after dividers in uv
Adc25V	equ	Vdc25/AdcRuv	     	;Adc value

Vdc24	equ	(24000000/7800)*1000 	;Vdc after dividers in uv
Adc24V	equ	Vdc24/AdcRuv	     	;Adc value

Vdc23	equ	(23000000/7800)*1000 	;Vdc after dividers in uv
Adc23V	equ	Vdc23/AdcRuv	     	;Adc value

Vdc22	equ	(22000000/7800)*1000 	;Vdc after dividers in uv
Adc22V	equ	Vdc22/AdcRuv	     	;Adc value

Vdc21	equ	(21000000/7800)*1000 	;Vdc after dividers in uv
Adc21V	equ	Vdc21/AdcRuv	     	;Adc value

Vdc20	equ	(20000000/7800)*1000 	;Vdc after dividers in uv
Adc20V	equ	Vdc20/AdcRuv	     	;Adc value

Vdc19	equ	(19000000/7800)*1000 	;Vdc after dividers in uv
Adc19V	equ	Vdc19/AdcRuv         	;Adc value
	
Vdc18	equ	(18000000/7800)*1000 	;Vdc after dividers in uv
Adc18V	equ	Vdc18/AdcRuv         	;Adc value
	
Vdc17	equ	(17000000/7800)*1000 	;Vdc after dividers in uv
Adc17V	equ	Vdc17/AdcRuv         	;Adc value
	
Vdc16	equ	(16000000/7800)*1000 	;Vdc after dividers in uv
Adc16V	equ	Vdc16/AdcRuv         	;Adc value

Vdc15	equ	(15000000/7800)*1000 	;Vdc after dividers in uv
Adc15V	equ	Vdc15/AdcRuv         	;Adc value
	
Vdc14	equ	(14000000/7800)*1000 	;Vdc after dividers in uv
Adc14V	equ	Vdc14/AdcRuv         	;Adc value

Vdc13	equ	(13000000/7800)*1000 	;Vdc after dividers in uv
Adc13V	equ	Vdc13/AdcRuv         	;Adc value
	
Vdc12	equ	(12000000/7800)*1000 	;Vdc after dividers in uv
Adc12V	equ	Vdc12/AdcRuv         	;Adc value

Vdc11	equ	(11000000/7800)*1000 	;Vdc after dividers in uv
Adc11V	equ	Vdc11/AdcRuv         	;Adc value
	
Vdc10	equ	(10000000/7800)*1000 	;Vdc after dividers in uv
Adc10V	equ	Vdc10/AdcRuv         	;Adc value

Vdc03	equ	(03000000/7800)*1000 	;Vdc after dividers in uv
Adc03V	equ	Vdc03/AdcRuv         	;Adc value

Vdc02	equ	(02000000/7800)*1000 	;Vdc after dividers in uv
Adc02V	equ	Vdc02/AdcRuv         	;Adc value

Vdc1.5	equ	(01500000/7800)*1000 	;Vdc after dividers in uv
Adc1.5V	equ	Vdc1.5/AdcRuv         	;Adc value

Vdc01	equ	(01000000/7800)*1000 	;Vdc after dividers in uv
Adc01V	equ	Vdc01/AdcRuv         	;Adc value

Vdc0.5	equ	(00500000/7800)*1000 	;Vdc after dividers in uv
Adc0.5V	equ	Vdc0.5/AdcRuv         	;Adc value

;-----------------------------------------------------------------------
; Comm equates
;-----------------------------------------------------------------------

cr	equ	0x0d			;carriage return
lf	equ	0x0a			;line feed
enq	equ	'?'			;initial wake up command
wak	equ	' '			;wake up character

;-----------------------------------------------------------------------
; Flag bit equates
;-----------------------------------------------------------------------

WUpZ	equ	0			;Wake up minutes zero flag
THbZ	equ	1			;THb went zero flag
Doze	equ	2			;flag to indicate are are dozing as we wait for the sun to rise
HJob	equ	3			;flag for Hand Job big motor movement request
MRun	equ	4			;any motor running flag
MBrk	equ	5			;motor break on flag
Hemi	equ	6			;hemisphere 1 = North
DoDump	equ	7			;do a diagnostic data dump after every track adjust

;-----------------------------------------------------------------------
; Timer 1 equates
;-----------------------------------------------------------------------

tius	equ	4			;4 us per count
ticks	equ	65536			;16 bits
maxtime	equ	tius*ticks		;max time from 0x0000 to 0x0000 (262,144 us)
tickval	equ	(maxtime-250000)/tius 	;value to generate T1 ints every 250ms
ticklos	equ	1			;timer ticks lost before we write the new value
tick01	equ	1			;value to adjust 1 relative calculating to 0 relative counting
tickadj	equ	ticklos-tick01		;tick value adjustment for time lost and number base convesion
t1low	equ	low(tickval+tickadj)	;preset for TMR1L
t1high	equ	high(tickval+tickadj)	;preset for TMR1H

;-----------------------------------------------------------------------
; T1 timer driven 250 ms heartbeat constants
;-----------------------------------------------------------------------

TATsec	equ	33			;seconds per track adjust
HbPSec	equ	4			;heart beats per second
TrkTmr	equ	TATsec*HbPSec		;heart beats per track adjust
DayMin	equ	24*60			;minutes in a day
SecDay	equ	DayMin*60		;seconds in a day
HbDay	equ	SecDay*HbPSec		;heart beats in a day

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	McI	0			;Motor current sense input
#define	McIPort	PORTA

#define	CvI	1			;Solar voltage sense input
#define	CvIPort	PORTA

#define	En2	2			;Motor encoder power
#define	En2Port	PORTA

#define	En3	3			;Motor encoder power
#define	En3Port	PORTA

#define	En4	4			;Motor encoder power
#define	En4Port	PORTA

#define FsI	5			;Find sun jumper
#define FsIPort	PORTA

#define	CwO	6			;rotate Cw output
#define	CwOPort	PORTA
#define	CwOData	b'01011100'

#define	CcO	7			;rotate Cc output
#define CcOPort	PORTA
#define	CcOData	b'10011100'

;                 76543210
#define AnalA	b'00000011'		;1=analog input
#define	DirA	b'00100011'		;0=output,1=input
#define IntA	b'00011100'		;initial port A data

#define EncOn	b'00011100'		;OR used to turn on encoder power outputs
#define	EncOff	b'11100011'		;AND used to turn off encoder power outputs

;-----------------------------------------------------------------------
; Port B defines
;-----------------------------------------------------------------------

#define	DnI	0			;down switch
#define	DnIPort	PORTB

#define	Td	0			;transmit data output
#define	TdPort	PORTB

#define	UpI	1			;up switch
#define	UpIPort	PORTB

#define	Rd	1			;receive data input
#define RdPort	PORTB

#define	CcI	2			;cc switch
#define	CcIPort	PORTB

#define	Cts	2			;clear to send output
#define	CtsPort	PORTB

#define CwI	3			;cw switch
#define CwIPort	PORTB

#define	Cd	3			;carrier detect output
#define	CdPort	PORTB

#define	UpO	4			;rotate Up output
#define	UpOPort	PORTB
#define	UpOData	b'00010000'

#define	DnO	5			;rotate DOWN output
#define	DnOPort	PORTB
#define	DnOData	b'00100000'

#define	AlI	6			;encoder pulses from the Altitude motor
#define AlIPort	PORTB

#define	AzI	7			;encoder pulses from the Azimuth motor
#define	AzIPort	PORTB

;                 76543210
#define DirBHj	b'11001111'		;0=output,1=input
#define	DirBCom	b'11000010'		;0=output,1=input
#define	IntBHj	b'00001111'		;initial port B data for hand controller
#define	IntBCom	b'00001110'		;initial port B data for Comms with CTS & CD high, TD low
 
#define	SwAnd	b'00001111'		;input switch bits
#define	EncAnd	b'11000000'		;encoder pulse bits
#define	AziSel	b'10000000'		;select azi encoder pulse
#define	AltSel	b'01000000'		;select alt encoder pulse

;-----------------------------------------------------------------------
; EE Data memory allocations
;-----------------------------------------------------------------------

	org	EeData0			;set start for EE data memory

E0	res	32			;32 bytes of test data storage
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
; loop counters
;--------------------------------

dlyxms	res	1			;W x 1ms delay loop counter
dlyms	res	1			;delay 1ms loop counter
crcnt	res	1			;creep counter

;--------------------------------
; Math variables
;--------------------------------

Tmp0	res	1
Tmp1	res	1
Tmp2	res	1

#define	_C	STATUS,0
#define	_Z	STATUS,2

;--------------------------------
; Pointing variables
;--------------------------------

AziSky	res	3			;new azimuth sky point
AltSky	res	3			;new altitude sky point
AltI	res	1			;Azimuth TAT index value
AziI	res	1			;Altitude TAT index value
AltEnc	res	3			;altitude encoder position 0 - 139,999
AziEnc	res	3			;azimuth encoder position 0 - 139,999
MovEnc	res	3			;desired encoder movement (0 - 139,999 pulses)
SvEnc	res	3			;temp encoder storage

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

THb	res	1			;track update down counter
WUpM	res	2			;Wake up minutes down counter

TodPS	res	1			;Tod update pre scaler
WUpPS	res	1			;Sleep heart beat pre scaler

;------------------------
; Motor control variables
;------------------------

MDir	res	1			;motor direction register
EncLst	res	1			;state of encoder pulses at last interrupt
EncSel	res	1			;indicates which encoder pulse should change

;------------------------
; Adc variables
;------------------------

SunVdc	res	1			;last value of solar Vdc
TarVdc	res	1			;solar Vdc target

;------------------------
; Misc variables
;------------------------

temp	res	1			;
temp1	res	1			;
tempb	res	1			;
tempw	res	1			;temps

Flags	res	1			;boolean flag byte
SFSR	res	1			;saved FSR
EeAdr	res	1			;EE address
Slice	res	1			;sky scan slice cont
NCnt	res	1			;number of "On Sun" nudge cycles

;leave NCnt as last variable

;--------------------------------
; Interrupt handler variables
;--------------------------------

	org	ramint+16-9		;start of bank insensitive ram
savewi	res	1			;save int stuff
savest	res	1			;save int stuff
saveFSR	res	1			;save int stuff
tempi	res	1			;used in int handler
AltC	res	1			;Azimuth track correction
AziC	res	1			;Altitude track correction
AA0	res	1
AA1	res	1
AA2	res	1			;40 bit encoder & adjusted value
B0Avil	equ	savewi-NCnt-1		;amount of ram left in bank 0

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------

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

dlylms	macro	dlyl			;delay for lit ms
	movlw	dlyl			;set up delay lit in w
	call	Dlywms			;now do the delay
	endm

;--------------------------------

copyenc	macro	enc1,enc2		;move encoder data around
	movff	enc1,enc2
	movff	enc1+1,enc2+1
	movff	enc1+2,enc2+2
	endm

;----------------------------------------

movff	macro	regs,regd		;move register regs to regd via w
	movfw	regs			;load source register
	movwf	regd			;save in destination register
	endm

;--------------------------------

movlf	macro	lit,reg			;load literal into register via w
	movlw	lit			;load literal into w
	movwf	reg			;store w into reg
	endm

;--------------------------------

setdeg	macro	deg,enc
	movlf	low(deg),enc
	movlf	high(deg),enc+1
	movlf	deg/65536,enc+2
	endm

;--------------------------------

movsc	macro	dir,deg
	setdeg	deg,MovEnc		;set movement size
	movlf	dir,MDir		;set movement direction
	call	MoveSc			;make it happen
	endm

;--------------------------------
;
;dosq	macro	deg			;four position scan
;
;	movsc	Up,deg			;move to position 1
;	movsc	Cc,deg
;	call	DoVdc			;get solar intensity
;	skpnc				;c = Sun >= Target
;	retlw	1			;nc = Sun < Target
;
;	movsc	Cw,deg*2		;move to position 2
;	call	DoVdc
;	skpnc				;no,so check another sky point
;	retlw	2			;yes so return
;
;	movsc	Dn,deg*2		;move to position 1
;	call	DoVdc
;	skpnc				;no,so check another sky point
;	retlw	3			;yes so return
;
;	movsc	Cc,deg*2		;move to position 4
;	call	DoVdc
;	skpnc				;no,so check another sky point
;	retlw	4			;yes so return
;
;	movsc	Cw,deg
;	movsc	Up,deg			;back to home
;	retlw	0
;	endm
;
;-----------------------------------------------------------------------
; >>>>>>>>>>>>>>> Power on entry point <<<<<<<<<<<<<<<
;-----------------------------------------------------------------------

	org	0x0000			;power on reset entry point <<<<<<<<<<<<<<<

	goto	Main			;go to start of main code

;-----------------------------------------------------------------------
; The interrupt controller handles
;   250ms master timer interrupts
;     Downcounting & setting track update timer THbZ flag on zero THb downcount
;     Downcounting & setting sleep timer WUpZ flag on zero WUpM downcount  
;   Motor encoder pulse interrupts
;     Updating Azimuth & Altitude encoders & MovEnc drive length from motor encoder pulses
;     Turning the motor off when MovEnc goes zero and resetting MRun flag
; DecEnc, IncEnc & DecWUpD are called, so we will use another stack position.
;   This means we must limit the main code excecution to no more than 6 nested
;   calls or we will underflow / wrap the stack and lose control
;-----------------------------------------------------------------------

	org	0x0004			;interrupt entry point <<<<<<<<<<<<<<<<<

	movwf	savewi			;save w
	swapf	STATUS,w		;load status into w but in reversed lsb & msb order
	movwf	savest			;save status flags
	clrf	STATUS			;clear status and select register bank 0

;-- Handle T1 timer interrupt & related down counters --

	btfss	PIR1,TMR1IF		;is this a timer overflow interrupt
	goto	tstpbc			;no so check if encoder interrupt

	movlf	t1high,TMR1H		;
	movlf	t1low,TMR1L		;load new start value
	bcf	PIR1,TMR1IF		;reset timer overflow flag

;-- Handle track heart beat down counter -----

	decfsz	THb,f
	goto	doWUp			;not zero so just dec it
	movlf	TrkTmr,THb		;set num of THbs per track update

	bsf	Flags,THbZ		;set THbZ flag

;-- Handle wake up down counter ---------

doWUp					;handle sleep delay

	decfsz	WUpPS,f			;dec wake up pre scaler
	goto	dotod			;not zero so go do tod stuff
	movlf	HbPSec*60,WUpPS		;set wake up pre scaler

	btfsc	Flags,Doze		;are we dozing & facing East?
	goto	decdoze			;yup so dec the sleep counter

	call	TWest			;z=west
	skpz				;skip if we are facing west
	goto	dotod			;no so don't downcount the sleep delay

	call	DecWupD			;dec wake up delay by 1 minute
decdoze
	call	DecWupD			;dec wake up delay by 1 minute			

;-- Handle Tod updater --

dotod

	decfsz	TodPS,f			;dec tod pre scaler
	goto	intfin			;not zero so get out of here
	movlf	HbPSec,TodPS		;set tod pre scaler

	call	UpDTod			;update Tod
	goto	intfin			;get out of here

;-- Handle encorder change / port B change interrupt --

tstpbc

	btfss	INTCON,RBIE		;is the encoder interrupt enabled
	goto	intfin			;no so get out of here
	btfss	INTCON,RBIF		;is it an encoder interrupt?
	goto	intfin			;no so get out of here

	movff	FSR,saveFSR		;save FSR

	movfw	PORTB			;read state of encoder pulses
	andwf	EncSel,w		;isol encoder bit to test
	movwf	tempi			;save it for a moment
	movfw	EncLst			;load last state of encoder pulses
	andwf	EncSel,w		;isol encoder bit to test
	subwf	tempi,w			;test if the proper encoder pulse changed state
	skpnz				;yes it is a encoder change from the motor being driven
	goto	finpbc			;no so get out of here

	movfw	MovEnc			;load lsb
	iorwf	MovEnc+1,w		;or in lsb+1
	iorwf	MovEnc+2,w		;or in lsb+2 & test if movenc is zero
	skpz				;is movement finished?
	goto	decenc1			;no so go to dec move count

	btfsc	Flags,MBrk		;are we breaking
	goto	ckifup			;yes so leave motor drive state alone, just count the encoder pulse
	bcf	Flags,MRun		;flag all motors stopped
	movlf	IntA,PORTA		;turn off azimuth motor but leave encoders powered on for now
	clrf	PORTB			;turn off altitude motor
	goto	ckifup			;movement finished but motor still moving, so update encoder position

decenc1
	movlf	MovEnc,FSR
	call	DecEnc			;dec enc pulses to move

ckifup
	movlf	AltEnc,FSR		;select Alt encoder to work on

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckifdn			;nope, so check if moving down

	call	IncEnc			;inc alt encoder position
	goto	encfin

ckifdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckifcc			;nope,so check if moving cc

	call	DecEnc			;dec alt encoder
	goto	encfin

ckifcc
	movlf	AziEnc,FSR		;select Azi encoder to work on

	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckifcw			;nope, so check if moving cw

	btfss	Flags,Hemi		;test if Northern hemishpere
	goto	DoInc			;handle southern hemi

DoDec
	call	DecEnc			;dec azi encoder for Cc in northern hemi
	goto	encfin	

DoInc
	call	IncEnc			;inc azi encoder for Cc in southern hemi
	goto	encfin

ckifcw
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	goto	encfin			;nope,we should never get here

	btfss	Flags,Hemi		;test if Northern hemishpere
	goto	DoDec			;dec Azi encoder for Cw in southern hemi
	goto	DoInc			;inc Azi encoder for Cw in northern hemi

encfin
	btfss	Flags,HJob		;is this a HJob movement
	goto	adjenc			;no so just delay past the leading edge of the encoder oulse

	movfw	PORTB			;read state of switches
	andlw	SwAnd			;isol out switch bits
	sublw	SwAnd			;test if they are all 1s/ off
	skpz				;skip if no switches are on
	goto	adjenc			;yes so let movement continue

	bcf	Flags,HJob		;no switches on so turn off HJob flag
	setdeg	Deg0.05,MovEnc		;turn long movement into short movement

adjenc
	movlf	200/3,tempi		;set for 1oo us delay at 8mhz clock rate

encx
	decfsz	tempi,f			;do delay to move past edge of encoder pulse
	goto	encx

finpbc
	movff	PORTB,EncLst		;save current encoder pulse state
	bcf	INTCON,RBIF		;clear port B change flag

;-- end specific interrupt handler code --

intfin
	movff	saveFSR,FSR		;reload FSR
	swapf	savest,w		;load saved status flags
	movwf	STATUS			;restore status flags
	swapf	savewi,f		;swap nibbles to prepare for next nibble swap into w
	swapf	savewi,w		;restore w without effecting status flags
	retfie				;go back to where we came from with interrupts enabled	

;-----------------------------------------------------------------------
; Time Procedures
;-----------------------------------------------------------------------

UpDTod					;update time and date

	incf	second,f		;inc second counter
	movlw	60			;load max second + 1 (0 - 59)
	subwf	second,w		;sub and put result in W
	skpz				;skip next op if second = 60
	return				;no - so go back to where we were

	clrf	second			;yes - so clear second

	incf	minute,f		;now inc minute count
	movlw	60			;load max minute + 1 (0 - 59)
	subwf	minute,w		;sub and put result in w
	skpz				;skip next op if minute = 60
	return				;no - so go back to where we came from

	clrf	minute			;yes - so clear minute

	incf	hour,f			;now inc hour count
	movlw	24			;load max hour + 1 (0 - 23)
	subwf	hour,w			;sub and put result in w
	skpz				;skip next op if hour = 24
	return				;no - so go back to where we came from

	clrf	hour			;yes - so clear hour

	incf	day,f			;now inc day count
	movfw	month			;load month (1 - 12)
	addlw	dmth-1			;add days in month array base address
	movwf	FSR			;store result in indirect addressing register
	movfw	INDF			;load days + 1 in month into w
	subwf	day,w			;sub and put result in w
	skpz				;skip next op if day = 1 + max in month
	return				;no - so go back to where we came from

	clrf	day			;yes - so clear day
	incf	day,f			;inc start day to 1

	incf	month,f			;now inc month count
	movlw	13			;load max month + 1 (1 - 12)
	subwf	month,w			;sub and put result in w
	skpz				;skip next op if month = 13
	return				;no - so go back to where we came from

	clrf	month			;yes - so clear month
	incf	month,f			;inc month to start from 1

	incf	yearlo,f		;inc year low
	movlw	100			;load max year low + 1 (0 - 99)
	subwf	yearlo,w		;sub and put result in w
	skpz				;skip next op if yearlo = 100
	goto	doleap			;no - so go do leap year adjust

	clrf	yearlo			;yes - so clear yearlo
	incf	yearhi,f		;inc to next century (like this code will EVER be executed!) 

doleap
	movlw	29+1			;assume it is a leap year (yearlo mod 4 = 0)
	btfss	yearlo,0		;is bit 0 zero?
	movlw	28+1			;no - so it is not a leap year
	btfss	yearlo,1		;is bit 1 zero
	movlw	28+1			;no - so it is not a leap year
	movwf	dmth+1			;store days in Feb for this year

	return

;-----------------------------------------------------------------------
; General comms procedures
;-----------------------------------------------------------------------

SetHJ

	banksel	PORTB
	movlf	IntBHj,PORTB		;set initial port B state

	banksel	TRISB			;select proper bank
	movlf	DirBHj,TRISB		;initialize port B data direction register

	banksel	OPTION_REG
	bcf	OPTION_REG,7		;enable global weak pullups

	banksel	PORTB			;back to bank 0
	dlylms	10			;delay 10ms for the port lines to settle down

	return

;----------------------------------------

SetCom

	banksel	PORTB
	movlf	IntBCom,PORTB		;set initial port b state

	banksel	TRISB
	movlf	DirBCom,TRISB		;initialize port B data direction register

	banksel	OPTION_REG
	bsf	OPTION_REG,7		;disable global weak pullups

	banksel	PORTB			;back to bank 0
	dlylms	10			;delay 10ms for the port lines to settle down

	return

;----------------------------------------

Send8n					;sent byte in w as 8N RS232 (low = 1)

	movwf	xmtchr			;save byte to be sent

	movlf	8,bitcnt		;init shift count

	bsf	TdPort,Td		;set Td high / spacing / 0 for start bit
	DlyB				;delay to send start bit

next8n
	rrf	xmtchr,f		;rotate right lsb into carry
	skpc				;skip if carry set
	goto	dozero8n		;no carry - so send 0
	bcf	TdPort,Td		;yes there is a carry - so put 1 on TD line
	goto	dobaud8n		;goto baud delay

dozero8n
	bsf	TdPort,Td		;put 0 on TD line

dobaud8n
	DlyB				;delay for 1 baud time

	decfsz	bitcnt,f		;test if more bits to send
	goto	next8n			;yes - so do it again

	bcf	TdPort,Td		;no - so set td low / marking / 1 for stop bit
	DlyB				;
	DlyB				;delay for 2 baud time to generate 2 stop bits

	return

;----------------------------------------

Recv8n					;receive 8N byte from inverted RS232 input (low = 1)
	clrc				;clear carry as no valid char received

	btfss	RdPort,Rd		;test for start bit (Rd line low)
	return				;false start bit

	DlyHB				;delay for 1/2 baud time
	btfss	RdPort,Rd		;test for start bit (Rd line low)
	return				;false start bit

	movlf	8,bitcnt		;set bit counter to receive 8 bits
	clrf	rcvchr			;clear comm received character
	clrc				;clear carry

r8na
	rrf	rcvchr,f		;rotate partial received comm char right one bit through carry
	DlyB				;yes - so delay full baud to get into middle of next bit
	btfss	RdPort,Rd		;test status of Rd
	bsf	rcvchr,7		;set msb of comm ch
	decfsz	bitcnt,f		;test if more bits to receive
	goto	r8na			;yes - so do it

	DlyB				;delay into the middle of the stop bit
	movfw	rcvchr			;load w with received char
	setc				;set carry to flag valid character received

	return

;----------------------------------------------------------
; Comms conversion procedures
;----------------------------------------------------------

BtoBcd

	clrf	temp			;clear temp msb
	movwf	temp1			;store binary

sub10
	movlw	10	
	subwf   temp1,w			;sub 10 from binary in w
	btfss   STATUS,C		;test if w > 10
	goto    over			;no - so finish up conversion
	movwf	temp1			;yes - so store new binary - 10
	incf    temp,f			;inc msb count
	goto    sub10			;goto do another -10 cycle

over
	swapf	temp,w			;move lshexade to mshexade and leave in w
	addwf	temp1,w			;put final result in w as two hexades

	return

;----------------------------------------

CovHex					;convert 3:4 into Hex Ascii

	andlw	0x0f			;isolate ls hexade
	iorlw	0x30			;assume it is <=9
	movwf	temp			;save result
	sublw	0x39			;test if > 9
	skpnc				;yes - so make it A-F
	goto	finhex			;no - so goto return with Ascii in w

	movlw	('A'-'9')-1		;load adjustment (Decimal to Alpha adjustment factor)
	addwf	temp, f			;make adjustment to alpha (A-F)

finhex
	movfw	temp			;load converted hex character

	return

;----------------------------------------

SendHex					;send binary in w as 2 hex numbers

	movwf	tempw			;save binary
	swapf	tempw,w			;swap hexades to convert 7:4
	call	CovHex			;convert w 3:4 into Hex & leave in w
	call	Send8n			;send it

	movfw	tempw			;load original again
	call	CovHex			;convert 3:4
	call	Send8n			;sendit

	return

;----------------------------------------

SendBin3				;convert binary in w into 3 packed bcd nibbles & send to comms

	movlw	200			;save original value
	subwf	tempb,w			;test if >=200
	skpc				;skip if >=200
	goto	ck100			;go to check if it is >100

	movlw	'2'			;load ascii 2
	call	Send8n			;send it
	movlw	200			;load 200
	subwf	tempb,f			;sub 200 from value
	goto	do99			;go to handle the rest

ck100
	movlw	100			;reload saved value
	subwf	tempb,w			;test if >=100
	skpc				;skip if >=100
	goto	snd0			;go to handle the rest

	movlw	'1'			;load ascii 1
	call	Send8n			;send it
	movlw	100			;load 100
	subwf	tempb,f			;sub 100 from value
	goto	do99			;go to handle the rest

snd0
	movlw	'0'			;load ascii 0
	call	Send8n			;send it

do99
	movfw	tempb			;load value
	SndBcd2				;send it

	return

;----------------------------------------

GetBin					;get 2 bytes, convert into bcd and convert into binary

	call	Recv8n			;receive 1st ascii in w
	andlw	0x0f			;isolate 3:4
	movwf	bcdchr			;store it away
	swapf	bcdchr,f		;swap hexades

	call	Recv8n			;receive 2nd ascii in w
	andlw	0x0f			;isolate 3:4
	iorwf	bcdchr,w		;or in first bcd and return with result in w

	call	BcdtoB			;convert packed bcd in w into binary and leave in w

	return

;--------------------------------

SendDec					;send two packed BCD digits in w with a decimal point between

	movwf	tempw			;save w

	swapf	tempw,w			;load msb of revs and swap hexades to send left first
	SendR				;send it

	movlw	'.'			;load '.'
	call	Send8n			;send decimal point

	movfw	tempw			;reload to send right hexade
	SendR				;send it

	return

;----------------------------------------

GetDec					;receive three ascii x.x and pack their ls hexade into 1 char

	call	Recv8n			;receive 1st ascii in w
	andlw	0x0f			;isolate 3:4
	movwf	bcdchr			;store it away
	swapf	bcdchr,f		;swap hexades

	call	Recv8n			;get decimal point

	call	Recv8n			;receive 2nd ascii in w
	andlw	0x0f			;isolate 3:4
	iorwf	bcdchr,w		;or in first bcd and return with result in w

	return

;--------------------------------

BcdtoB					;convert packed bcd in w (max = 99) into binary

	movwf	temp1			;store bcd
	movwf	temp			;store bcd

	swapf	temp1,w			;swap hexades to make +10 loop counter
	andlw	0x0f			;zap out old ls hexade
	skpnz				;skip if ms <> 0 (conversion needed)
	goto	ebcdtob			;no - so just reload original

	movwf	temp1			;store back with only +10 loop counter bits

	movfw	temp			;load temp
	andlw	0x0f			;zero bits 7:4
	movwf	temp			;store bits 3:4 (ls hexade) to form add base

add10
	movlw	10			;load 10
	addwf	temp,f			;add it to base
	decfsz	temp1,f			;dec +10 loop counter
	goto	add10			;goto do it again

ebcdtob
	movfw	temp			;load binary result into w

	return

;----------------------------------------

SendLfCr				;send message end

	movlw	lf
	call	Send8n			;send line feed

	movlw	cr
	call	Send8n			;send carrage return

	return

;----------------------------------------

SendFd					;send delimiter

	movlw	','
	call	Send8n			;send ','

	return

;----------------------------------------
; Comms sending and receiving procedures
;----------------------------------------

SendSC

	call	SendDate		;send date
	call	SendFd			;,

	call	SendTime		;send time
	call	SendFd			;,

	call	SendAzi			;send azi encoder
	call	SendFd			;,

	call	SendAlt			;send alt encoder
	call	SendFd			;,

	call	SendTAT			;send TAT data
	call	SendFd			;,

	call	SendAdc			;send adc data
	call	SendFd			;,

	movfw	Flags			;load flag byte
	call	SendHex			;send it
	call	TWest			;get West status
	call	SendHex			;send it
	call	SendLfCr		;end message

	return

;----------------------------------------

SendAzi					;send hhhhhh,

	movfw	AziEnc			;load lsb
	call	SendHex			;send lsb
	movfw	AziEnc+1		;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AziEnc+2		;load lab+2
	call	SendHex			;send lsb+2

	return

;----------------------------------------

SendAlt					;send hhhhhh,

	movfw	AltEnc			;load lsb
	call	SendHex			;send lsb
	movfw	AltEnc+1		;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AltEnc+2		;load lab+2
	call	SendHex			;send lsb+2

	return

;----------------------------------------

SendAdc					;send SunVdc,TarVdc,	

	call	DoVdc			;get solar voltage
	movfw	SunVdc			;load SunVdc
	call	SendBin3		;send it
	call	SendFd			;,
	movfw	TarVdc			;load TarAdc TAT index
	call	SendBin3		;send it

	return

;----------------------------------------

SendTAT					;send AziI,AltI,AziC,AltC,

	movfw	AziI			;load AziI TAT index
	call	SendBin3		;send it

	call	SendFd			;,

	movfw	AltI			;load AltI TAT index
	call	SendBin3		;send it

	call	SendFd			;,

	movfw	AziC			;load AziC TAT track adj
	call	SendBin3		;send it

	call	SendFd			;,

	movfw	AltC			;load AltC TAT track adj
	call	SendBin3		;send it

	return

;----------------------------------------

SendDate				;send the date as "dd/mm/yyyy, "

	movfw	day			;load day
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	movlw	'/'			;load '/'
	call	Send8n			;send it

	movfw	month			;load month
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	movlw	'/'			;load '/'
	call	Send8n			;send it

	movfw	yearhi			;load year high
	SndBcd2				;send binary in w as 2 numeric bcds to comms
	movfw	yearlo			;load year low
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	return

;----------------------------------------

SendTime				;send the time as "hh:mm:ss, "

	movfw	hour			;load hour
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	movlw	':'			;loas ':'
	call	Send8n			;send it

	movfw	minute			;load minute
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	movlw	':'			;loas ':'
	call	Send8n			;send it

	movfw	second			;load second
	SndBcd2				;send binary in w as 2 numeric bcds to comms

	return

;----------------------------------------

GetTime					;get time hh:mm:ss

	call	GetBin			;get HH
	movwf	hour			;store in hour

	call	Recv8n			;:

	call	GetBin			;get MM
	movwf	minute			;store in minute

	call	Recv8n			;:

	call	GetBin			;get SS
	movwf	second			;store in second

	return

;----------------------------------------

GetDate					;get date dd/mm/yyyy

	call	GetBin			;get DD
	movwf	day			;store in day

	call	Recv8n			;/

	call	GetBin			;get MM
	movwf	month			;store in month

	call	Recv8n			;/

	call	GetBin			;get YY high
	movwf	yearhi			;store in year hi

	call	GetBin			;get YY low
	movwf	yearlo			;store in year lo

	return

;----------------------------------------

TogDump					;toggle auto disgnostic data dump on and off

	call	Recv8n			;get next byte
	movwf	tempw			;save w
	sublw	'1'			;test = 1
	skpnz				;no - so skip enable
	bsf	Flags,DoDump		;enable optical quality monitoring

	movfw	tempw			;load received byte
	sublw	'0'			;test = 0
	skpnz				;no - so skip disbale
	bcf	Flags,DoDump		;disable optical quality monitoring

	return

;----------------------------------------

GoAzi

	return

;----------------------------------------

GoAlt

	return

;----------------------------------------
; TAT index generation and TAT data retrieval
;----------------------------------------

DoTAT					;index the TAT to get the Alt & Azi track adjust values
	copyenc	AltEnc,AA0
	call	DoMult34		;do the multiply to get the 5 deg index
	movff	AA2,AltI		;save altitude index

	movlw	180/5			;load max TAT alt index +1
	subwf	AltI,w			;test if AltI greater >= 36
	skpc				;yes it is
	goto	tat1			;no so leave it as it is

	movlw	180/5			;AltI >=36
	subwf	AltI,f			;subtract 36 to keep in in the range 0 - 35

;----

	copyenc	AziEnc,AA0
	call	DoMult34		;do the multiply
	movff	AA2,AziI		;save azimuth index

	movlw	180/5			;load max TAT azi index +1
	subwf	AziI,w			;test if AziI greater >= 36
	skpc				;yes it is
	goto	tat1			;no so leave it as it is

	movlw	180/5			;AziI >=36
	subwf	AziI,f			;subtract 36 to keep in in the range 0 - 35

;----

tat1
	movff	AziI,AA0
	clrf	AA1
	clrf	AA2			;load Azimuth TAT index to multiply by 32
	call	DoMult32		;do the multiply to move the Azi index into 10:8

	movfw	AltI			;load Altitude TAT index
	addwf	AA0,f			;add in Altitude TAT index to Azimuth TAT and store
	bsf	AA1,3			;full TAT index now in AARGB0/B1

	banksel EEADRH			;Select Bank of EEADRH
	movff	AA0,EEADR 		;lsb of program address to read
	movff 	AA1,EEADRH		;msb of program address to read
					;
	banksel EECON1			;select Bank of EECON1
	bsf 	EECON1,EEPGD 		;select program memory
	bsf 	EECON1,RD 		;do read
	nop 				;
	nop				;delay for read data

	banksel EEDATA			;select Bank of EEDATA
	movff 	EEDATA,AziC 		;store lsb as Azimuth TAT correction
	movff 	EEDATH,AltC 		;store msb as Altitude TAT correction
	banksel	0			;back to start

	return

;----------------------------------------

DoMult2

	clrc
	rlf	AA0,f
	rlf	AA1,f
	rlf	AA2,f

	return

;----------------------------------------

DoMult32

	call	DoMult2			;x2
	call	DoMult2			;x4
	call	DoMult2			;x8
	call	DoMult2			;x16
	call	DoMult2			;x32

	return

;----------------------------------------

DoMult34

	copyenc	AA0,Tmp0
	clrc
	rlf	Tmp0,f
	rlf	Tmp1,f
	rlf	Tmp2,f			;mult by 2 and save

	call	DoMult2			;x2
	call	DoMult2			;x4
	call	DoMult2			;x8
	call	DoMult2			;x16
	call	DoMult2			;x32

	call	Add24			;add X2 (Tmp0,1,2) + X32 (AA0,1,2) value to get X34 (AA0,1,2)

	return

;----------------------------------------

Add24					;24 bit add

	movfw	Tmp0			;Tmp0,1,2 + AA0,1,2. Result in AA0,1,2
	addwf 	AA0,f			;AA0+Tmp0

	movfw	Tmp1
	btfsc 	_C
	incfsz 	Tmp1,W
	addwf 	AA1,f			;AA1+Tmp1
	
	movfw	Tmp2
	btfsc 	_C
	incfsz 	Tmp2,W
	addwf 	AA2,f			;AA2+Tmp2			

	return

;----------------------------------------

Sub24					;24 bit subtract

	movfw 	Tmp0			;AA0,1,2 - Tmp0,1,2. Result in AA0,1,2
	subwf 	AA0,f			;AA0-Tmp0

	movfw 	Tmp1
	btfss 	_C
	incfsz 	Tmp1,w
	subwf 	AA1,f			;AA1-Tmp1

	movfw 	Tmp2
	btfss 	_C
	incfsz 	Tmp2,w
	subwf 	AA2,f			;AA2-Tmp1

	return

;----------------------------------------
; Time procedures
;----------------------------------------

DecWupD					;dec 16 bit Wake up delay

	movf	WUpM,f			;is sleep delay lsb zero
	skpnz				;no so skip
	goto	ckWb1			;yes so check msb

	decf	WUpM,f			;no so dec it
	goto	ckWUpDZ			;check if downcount finished

ckWb1
	decf	WUpM,f			;dec sleep delay lsb to make it non zero
	decf	WUpM+1,f		;dec sleep delay msb for borrow

ckWUpDZ
	movfw	WUpM			;load lsb
	iorwf	WUpM+1,w		;or in msb
	skpnz				;skip if not zero
	bsf	Flags,WUpZ		;set wake up minutes zero flag

	return

;----------------------------------------

Dly10us					;1us call

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop				;8us nop delay (0.5us per nop)

	return				;1us exit

;----------------------------------------

Dly5ms

	movlw	5			;delay for 5ms
	goto	Dlywms

;----------------------------------------

Dly10ms

	movlw	10			;delay for 10 ms
	goto	Dlywms

;----------------------------------------

Dly25ms

	movlw	25			;delay for 25 ms
	goto	Dlywms

;----------------------------------------

Dly100ms				;delay for 100 ms

	movlw	100
	goto	Dlywms

;----------------------------------------

Dly150ms				;delay for 150ms

	movlw	150
	goto	Dlywms

;----------------------------------------

Dly250ms

	movlw	250			;delay for 250ms

;----------------------------------------

Dlywms					;delay for w * ms

	movwf	dlyxms			;save ms loop count

doxms
	movlf	995/4,dlyms		;load delay 1ms constant

d1ms
	nop				;to make minor loop = 4us / 16 clocks
;	nop
;	nop
	nop
	nop
	decfsz	dlyms,f			;dec ms count & test for zero
	goto	d1ms			;no - so do it again

	decfsz	dlyxms,f		;dec ms count & test for zero
	goto	doxms			;no - so do it again

	return				;yes - so exit

;---------------------------------------

Dly1sec

	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms

	return

;----------------------------------------
; EEprom procedures
;----------------------------------------

EeRead

	movfw	EeAdr			;load Ee address

	banksel	EEADR		 	;select bank of EEADR
	movwf	EEADR			;load address

	banksel	EECON1		 	;select bank of EECON1
	bcf	EECON1,EEPGD		;select data memory
	bsf 	EECON1,RD 		;EE Read
	nop				;
	nop				;

	banksel	EEDATA	 		;select bank of EEDATA
	movfw 	EEDATA		 	;W = EEDATA
	banksel	PORTA			;select default bank 0

	return

;----------------------------------------

EeWrite

	banksel EECON1 			;Select Bank of EECON1

WEeFin
	btfsc 	EECON1,WR	 	;Wait for write
	goto 	WEeFin 			;to complete

	banksel	EEDATA	 		;Select Bank of EEADR
	movwf 	EEDATA 			;Data Memory Value to write

	banksel	EeAdr
	movfw	EeAdr			;load Ee address

	banksel	EEADR
	movwf	EEADR			;Store it

	banksel EECON1	 		;Select Bank of EECON1
	bcf 	EECON1,EEPGD		;Point to DATA memory
	bsf 	EECON1,WREN 		;Enable writes
	bcf 	INTCON,GIE	 	;Disable INTs.
	movlf 	0x55,EECON2 		;Write 55h
	movlf 	0xAA,EECON2	 	;Write AAh
	bsf 	EECON1,WR 		;Set WR bit to begin write
	bsf 	INTCON,GIE	 	;Enable INTs
	bcf 	EECON1,WREN 		;Disable writes
	banksel	PORTA			;back to bank 0

	return

;----------------------------------------

StoTAT					;store debug TAT data

	movlf	low(E0),EeAdr
	movfw	AziI
	call	EeWrite			;store alt index

	movlf	low(E0+1),EeAdr
	movfw	AltI
	call	EeWrite			;store azi index

	movlf	low(E0+2),EeAdr
	movfw	AltC
	call	EeWrite			;store alt TAT adjust value

	movlf	low(E0+3),EeAdr
	movfw	AziC
	call	EeWrite			;store azi TAT adjuat value

;----------------------------------------

StoEnc
	movlf	low(E0+4),EeAdr
	movfw	AziEnc+2
	call	EeWrite			;store it

	movlf	low(E0+5),EeAdr
	movfw	AziEnc+1
	call	EeWrite			;store it

	movlf	low(E0+6),EeAdr
	movfw	AziEnc
	call	EeWrite			;store it

;-------

	movlf	low(E0+7),EeAdr
	movfw	AltEnc+2
	call	EeWrite			;store it

	movlf	low(E0+8),EeAdr
	movfw	AltEnc+1
	call	EeWrite			;store it

	movlf	low(E0+9),EeAdr
	movfw	AltEnc
	call	EeWrite			;store it

	return

;----------------------------------------
; Shaft encoder procedures
;----------------------------------------

IncEnc					;inc encoder count

	movff	FSR,SFSR		;save original FSR
	movlw	Max1			;test if Alt at max
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	encinc			;no so goto inc encoder value

	incf	FSR,f			;inc to next byte
	movlw	Max2			;load next value to test
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	encinc			;no so goto inc encoder value

	incf	FSR,f			;inc to next byte
	movlw	Max3			;load that bytes max value
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	encinc			;no so goto inc it

	movff	SFSR,FSR		;restore original FSR
	clrf	INDF
	incf	FSR,f			;inc to next byte
	clrf	INDF
	incf	FSR,f			;inc to next byte
	clrf	INDF			;encoder inced and rolled over to zero

	return				;so finally return	

encinc
	movff	SFSR,FSR		;restore FSR
	incfsz	INDF,f			;inc lsb

	return				;return if no overflow

	incf	FSR,f			;inc pointer to next byte
	incfsz	INDF,f	 		;inc lsb+1

	return				;return if no overflow

	incf	FSR,f			;inc to next byte
	incf	INDF,f			;simple inc lsb+2 will do here

	return				;finished here, so return

;----------------------------------------

DecEnc					;dec encoder count

	movff	FSR,SFSR		;save original FSR
	movf	INDF,f			;test if lsb is zero
	skpz				;yes so test next byte
	goto	encdec			;no so go to dec it

	incf	FSR,f			;inc pointer to next byte
	movf	INDF,f			;test if lsb+1 is zero
	skpz				;yes so test next byte
	goto	encdec			;no so go to dec it

	incf	FSR,f			;inc pointer to next byte
	movf	INDF,f			;test if lsb+2 is zero
	skpz				;yes so test next byte
	goto	encdec			;no so go to dec it

	movff	SFSR,FSR		;restore original FSR
	movlf	Max1,INDF		;set max value for this byte
	incf	FSR,f			;inc to next byte
	movlf	Max2,INDF		;set max value for this byte
	incf	FSR,f			;inc to next byte
	movlf	Max3,INDF		;set max value for this byte

	return				;with encoder at max as a result of a underflow

encdec
	movff	SFSR,FSR		;restore original FSR
	movlw	1			;seed to test for underflow (nc) on subtract
	subwf	INDF,f			;dec lsb
	skpnc				;test for nc / underflow

	return				;none so exit

	incf	FSR,f			;set up to test next byte
	subwf	INDF,f			;dec lsb+1
	skpnc				;test for nc / underflow

	return				;none so exit

	incf	FSR,f			;set up to handle final byte
	decf	INDF,f			;simple dec of lsb+2 will do here

	return

;----------------------------------------
; SunCube sky point control procedures
;----------------------------------------

AAltSp

	copyenc	AltSky,AA0		;load AA with current sky point

	movff	AltC,Tmp0
	clrf	Tmp1
	clrf	Tmp2			;load Tmp with TAT adjustment

	call	TWest			;z=west
	skpz				;skip if west
	goto	adjalt1			;we are pointing east so dec it

	call	Sub24			;subtract as the sun drops in the western sky
	goto	adjalt2			;go to save the new sky point

adjalt1
	call	Add24			;add as the sun climbs in the eastern sky

adjalt2
	copyenc	AA0,AltSky		;save new Alt sky point

	return

;----------------------------------------

AAziSp

	copyenc	AziSky,AA0		;load AA with current sky point

	movff	AziC,Tmp0
	clrf	Tmp1
	clrf	Tmp2			;load Tmp with TAT adjustment

	btfss	Flags,Hemi		;skip if in Northern hemisphere
	goto	adjazi1			;we are in the southern hemisphere so inc it

	call	Sub24			;subtract as the sun moves Cw in the northern hemisphere
	goto	adjazi2			;go to save the new sky point

adjazi1
	call	Add24			;add as the sun moves Cc in the southern hemisphere

adjazi2
	copyenc	AA0,AziSky		;save new Azi sky point

	return

;----------------------------------------

MAziSp					;move the SunCube to new azi sky point

	copyenc	AziEnc,AA0		;load add/sub value
	copyenc	AziSky,Tmp0		;load the other value
	call	Sub24			;sub AziEnc-AziSky
	btfss	AA2,7			;did we have a underflow?
	goto	mazi1			;no go to handle Cc move

	copyenc	AziEnc,Tmp0		;
	copyenc	AziSky,AA0		;
	call	Sub24			;do SkyEnc-AziSky
	movlf	Cc,MDir			;AziEnc < AziSky so we move Cc
	goto	mazi2

mazi1
	movlf	Cw,MDir			;AziEnc >= AziSky so we move Cw

mazi2
	copyenc	AA0,MovEnc		;set movement size

	movf	MovEnc+2,f		;test if nz
	skpz				;z so check next byte
	goto	mazi3			;nz so move big enough to do

	movf	MovEnc+1,f		;test if nz
	skpz				;z so check next byte
	goto	mazi3			;nz so move big enough

	movfw	MovEnc			;test if big enough
	andlw	0xe0			;is it at least 32 encoder pulses?
	skpnz				;nz move is >=32 encoder pulses

	return				;z so move too small

mazi3
	call	MoveSc			;make it happen

	return

;----------------------------------------

MAltSp					;move the SunCube to new alt sky point
	copyenc	AltEnc,AA0		;load add/sub value
	copyenc	AltSky,Tmp0		;load the other value
	call	Sub24			;sub AltEnc-AltSky
	btfss	AA2,7			;did we have a underflow?
	goto	malt1			;no go to handle Dn move

	copyenc	AltEnc,Tmp0		;
	copyenc	AltSky,AA0		;
	call	Sub24			;do SkyEnc-AltAzi
	movlf	Up,MDir			;AziEnc < AltSky so we move Up
	goto	malt2

malt1
	movlf	Dn,MDir			;AziEnc >= AltSky so we move Dn

malt2
	goto	mazi2			;go to check if move size is big enough

;----------------------------------------
; Motor drive & management procedures
;----------------------------------------

MoveSc					;move to new sky point
	movfw	PORTA			;load state of port A
	iorlw	EncOn			;set encoder power bits to on
	movwf	PORTA			;write results back to port A
	call	Dly5ms			;wait for encoder filter cap to charge
	movff	PORTB,EncLst		;save current encoder states
	bcf	INTCON,RBIF		;clear port b change flag
	bsf	INTCON,RBIE		;enable encoder pulse interrupts

	bsf	Flags,MRun		;flag we have a motor running
	movlw	Up
	subwf	MDir,w			;check if moving up
	skpnz
	goto	DoUp			;nope,so check if moving down

ckdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpnz
	goto	DoDn			;nope,so check if moving ccw

ckccw
	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpnz
	goto	DoCc			;nope,so check if moving cw

ckcw
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpnz
	goto	DoCw

	return				;we should never get here

;----------------------------------------

DoDn
	movlf	AltSel,EncSel		;use alt encoder
	movlw	DnOData
	movwf	DnOPort			;turn on Down drive

	btfsc	Flags,MRun		;test if motor still running
	goto	$-1			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	Flags,MBrk		;flag we are breaking
	movlw	UpOData
	movwf	UpOPort			;turn on reverse Up drive as a brake
	goto	DoBrk			;goto wait for breaking to finish

;----------------------------------------

DoUp
	movlf	AltSel,EncSel		;use alt encoder
	movlw	UpOData
	movwf	UpOPort			;turn on Up drive

	btfsc	Flags,MRun		;test if motor still running
	goto	$-1			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	Flags,MBrk		;flag we are breaking
	movlw	DnOData
	movwf	DnOPort			;turn on reverse Dn drive as a break
	goto	DoBrk			;goto wait for breaking to finish

;----------------------------------------

DoCc
	movlf	AziSel,EncSel		;use azi encoder
	movlw	CcOData
	movwf	CcOPort			;turn on Cc drive

	btfsc	Flags,MRun		;test if motor still running
	goto	$-1			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	Flags,MBrk		;flag we are breaking
	movlw	CwOData
	movwf	CwOPort			;turn on reverse Cw drive as a break
	goto	DoBrk			;goto wait for breaking to finish

;----------------------------------------

DoCw
	movlf	AziSel,EncSel		;use azi encoder
	movlw	CwOData
	movwf	CwOPort			;turn on Cw drive

	btfsc	Flags,MRun		;test if motor still running
	goto	$-1			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	Flags,MBrk		;flag we are breaking
	movlw	CcOData
	movwf	CcOPort			;turn on reverse Cc drive as a break

DoBrk
	dlylms	BrkMs			;delay BrkMs for reverse drive to almost stop motor
	movlf	IntA,PORTA		;turn off azimuth motor but leave encoders powered on for now
	clrf	PORTB			;turn off altitude motor
	bcf	Flags,MBrk		;turn off we are breaking flag
	call	Dly250ms		;delay 250 ms to be sure we are stopped	

	bcf	INTCON,RBIE		;disable encoder pulse interrupts
	movfw	PORTA			;load state of port A 
	andlw	EncOff			;turn off encoder power bits
	movwf	PORTA			;write result back to port A
	call	Dly5ms			;wait for encoder filter cap to discharg

	copyenc	AltEnc,AltSky	 	;update alt sky point
	copyenc	AziEnc,AziSky	 	;update azi sky point

	return

;----------------------------------------
; Tracking procedures
;----------------------------------------

GoAlt0					;drive to altitude zero

	copyenc	AltEnc,MovEnc	 	;set up slew back to zero alt
	movlf	Dn,MDir			;set direction down
	call	MoveSc			;slew to 0 altitude

	return

;----------------------------------------

TWest					;test if facing west, z = west

	copyenc	AziEnc,AA0		;	
	setdeg	Deg180,Tmp0		;
	movfw 	Tmp0			;AA0,1,2 - Tmp0,1,2. Result in AA0,1,2
	subwf 	AA0,f			;AA0-Tmp0

	movfw 	Tmp1			;do 24 bit subtract in line to save call and too deep a stack for interrupts
	btfss 	_C			;		
	incfsz 	Tmp1,w			;
	subwf 	AA1,f			;AA1-Tmp1

	movfw 	Tmp2			;
	btfss 	_C			;
	incfsz 	Tmp2,w			;
	subwf 	AA2,f			;AA2-Tmp1
	comf	AA2,w			;load AA2 inverted
	andlw	0x80			;test for underflow/, azi < 180

	return				;nz = East (sunrise), z = West (sunset)

;----------------------------------------

TMinAlt					;z means < 0 altitude

	copyenc	AltEnc,AA0		;
	setdeg	Deg180,Tmp0		;
	call	Sub24			;Do AltEnc-Deg180
	movfw	AA2			;load msd
	andlw	0x80			;z means < 0

	return

;----------------------------------------

DrillIt

;	call	NudgeCw
;	call	NudgeCc
;	call	NudgeDn
;	call	NudgeUp
;	call	SetTHb

	return

;----------------------------------------

Up2.0					;move Up 2.0 deg and test solar voltage

	movsc	Up,Deg2.0		;slew up 2.0 deg
	call	DoVdc			;read solar voltage

	return

;----------------------------------------

Dn2.0					;move Up 2.0 deg and test solar voltage

	movsc	Dn,Deg2.0		;slew up 2.0 deg
	call	DoVdc			;read solar voltage

	return

;----------------------------------------

Cc2.0					;move Cc 2.0 deg and test solar voltage

	movsc	Cc,Deg2.0		;slew Cc 2.0 deg
	call	DoVdc			;read solar voltage

	return

;----------------------------------------

Cw2.0					;move Cw 2.0 deg and test solar voltage

	movsc	Cw,Deg2.0		;slew Cw 2.0 deg
	call	DoVdc			;read solar voltage

	return

;----------------------------------------

SkyScan					;scan the sky looking for the morning sun

	movlf	Adc20V,TarVdc		;set 20 Vdc as solar voltage target
	movlf	7,Slice			;init slice count
	movsc	Cc,Deg15		;slew to azimuth + 15 deg

TSss
	call	Up2.0			;move up 2 deg from horizon
	call	Up2.0			;move up another 2 deg to start search & test at 4 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Up2.0			;test 6 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Up2.0			;test 8 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Up2.0			;test 10 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Up2.0			;test 12 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Up2.0			;test 14 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Cw2.0			;move cw 2 deg for next slice
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Dn2.0			;test 12 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Dn2.0			;test 10 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Dn2.0			;test 8 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Dn2.0			;test 6 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Dn2.0			;test 4 deg
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	call	Cw2.0			;slew 2 deg cw
	skpnc				;nc = SunVdc < target voltage			
	goto	Okss

	decfsz	Slice,f			;dec slice count and skip if zero
	goto	TSss			;test another slice

	movsc	Cc,Deg15		;
	call	GoAlt0			;move back to orignal position

	retlw	0			;return with no sun found flag

Okss
	retlw	1			;return with sun found flag

;----------------------------------------
; Hand controller
;----------------------------------------

HandJob

	movfw	DnIPort			;read hand controller switches
	andlw	SwAnd			;isolate all switch bits, 1 = off / open
	sublw	SwAnd			;test if any swithes on, 0 = on / grounded
	skpz				;skip if no switches are on
	goto	ckidn			;switch/s are on so find out which one
	retlw	0

ckidn
	btfsc	DnIPort,DnI		;test if Down requested
	goto	ckiup			;no so go check if up request

	movlf	Dn,MDir			;yes so set direction
	goto	FinHJ			;go to common HJ stuff

ckiup
	btfsc	UpIPort,UpI		;test if Up requested
	goto	ckicw			;no so go check if cw request

	movlf	Up,MDir			;yes so set direction
	goto	FinHJ			;goto common HJ stuff

ckicw
	btfsc	CwIPort,CwI		;check if Cw requested
	goto	ckicc			;no so go check if cc request

	movlf	Cw,MDir			;yes so set direction
	goto	FinHJ			;goto common HJ stuff

ckicc
	btfsc	CcIPort,CcI		;test if Cc requested
	retlw	0			;no so just exit

	movlf	Cc,MDir			;yes so set direction

FinHJ					;common HJ stuff
	btfss	FsIPort,FsI		;test if jumper in, set = out
	goto	BigMove			;yes so force all movements to be big

	movlf	Adc1.5V,TarVdc		;set solar target voltage = 1.5 Vdc (Isc test)
	call	DoVdc			;get solar voltage and test
	skpc				;skip if solar >= target
	goto	SmallMove		;no, so small step during Isc test

	movlf	Adc14V,TarVdc		;set solar target voltage = 14 Vdc
	call	DoVdc			;get solar voltage and test
	skpnc				;skip if solar < target
	goto	SmallMove		;no so small step when on sun

BigMove
	setdeg	Deg90,MovEnc		;set big off sun movement size
	bsf	Flags,HJob		;flag this movement is a HJob request
	goto	FinHJ2			;go to common SC HJ movement starter

SmallMove
	setdeg	Deg0.05,MovEnc		;set small on sun movement size

FinHJ2
	call	MoveSc			;do the selected movement
	call	SetTHb			;set new next track adjust delay

	retlw	1			;exit with handJob did something flag set

;----------------------------------------

TSwOn					;test if any switch is on

	movfw	CcIPort			;read switches
	andlw	0x0f			;isol switch bits
	sublw	0x0f			;nzero = any switch on

	return

;----------------------------------------

WSwOff					;wait for all switches to be off

	call	Dly250ms		;debounce switch off
	movfw	CcIPort			;read switch port
	andlw	SwAnd			;isol switch bits
	sublw	SwAnd			;all switches off = 1s?
	skpz				;skip if all switches off
	goto	WSwOff			;no so wait some more

	call	Dly250ms		;debounce switch off
	movfw	CcIPort			;read switch port
	andlw	SwAnd			;isol switch bits
	sublw	SwAnd			;all switches off = 1s?
	skpz				;skip if all switches off
	goto	WSwOff			;no so wait some more

	return

;----------------------------------------
; Adc procedures
;----------------------------------------

DoVdc

	bsf	ADCON0,GO		;start A/D conversion

waitadc
	btfsc	ADCON0,GO		;Wait for "GO" to be reset by adc complete
	goto	waitadc			;no - so go to wait for adc complete

	movff	ADRESH,SunVdc		;load adc msb [10:8] into SunVdc
	movfw	TarVdc			;load solar target voltage to w
	subwf	SunVdc,w		;sub SunVdc - W(TarVdc), c = SunVdc >= TarVdc, nc = SunVdc < TarVdc

	return				;with result in carry

;----------------------------------------

InitVdc					;initialize the Adc to the solar input

	bsf	STATUS,RP0		;select bank 1
	movlf	b'01000000',ADCON1	;left justified data,vref = AVdd/AVss,system clock / 2
	bcf	STATUS,RP0		;select bank 0
	movlf	b'01001001',ADCON0	;Fosc/16,channel 0,done,adc on

	return

;----------------------------------------
; Initialization procedures
;----------------------------------------

SetTodPS

	movlf	HbPSec,TodPS		;set up tod prescaler	

	return

;----------------------------------------

SetTHb

	movlf	TrkTmr,THb		;set up track delay prescaler
	bcf	Flags,THbZ		;reset THb zero flag

	return

;----------------------------------------

SetWUpM

	movlf	low(DayMin),WUpM	;
	movlf	high(DayMin),WUpM+1	;set sleep down counter to max (1,440) minutes
	bcf	Flags,WUpZ		;reset wake up minutes zero flag

	return

;----------------------------------------

SetUpIo					;setup the I/O ports

	banksel	PORTA
	clrf	PORTA			;set initial port A state

	banksel	OSCCON			;setup proper bank
	movlf	0x72,OSCCON		;select intrc 8 Mhz

	banksel	TRISA
	movlf	DirA,TRISA		;initialize port A data direction register

	banksel	ANSEL
	movlf	AnalA,ANSEL		;select analog input channels

	call	SetHJ			;setup initial port b state & set bank 0
	banksel	PORTA

	return

;----------------------------------------

EnaInt					;enable interrupts

	call	SetTodPS		;set up Tod prescaler
	call	SetTHb			;set up track delay prescaler
	call	SetWUpM			;setup sleep timer

	banksel	TMR1L
	movlf	t1low,TMR1L		;
	banksel	TMR1H
	movlf	t1high,TMR1H		;set initial values for the T1 250ms heart beat

	banksel	T1CON
	movlf	0x31,T1CON		;set up T1 timer for interrupts

	banksel	PIR1
	bcf	PIR1,TMR1IF		;clear any pending T1 interrupt flags

	banksel	PIE1
	bsf	PIE1,TMR1IE		;enable T1 interrupts

	banksel	INTCON
	bsf	INTCON,PEIE		;enable timer interrupts
	bsf	INTCON,GIE		;enable general interrupts

	banksel	PORTB			;back to bank 0

	return

;----------------------------------------

ClearRam				;clear ram to zero

	movlf	ram0,FSR		;set pointer to start of ram

nxtclr					;clear bank 0 ram from 0x20 thru 0x7f
	clrf	INDF			;clear @ pointer
	incf	FSR,f			;inc pointer
	btfss	FSR,7			;test if cleared last ram
	goto	nxtclr			;no - so go clear more ram

	return

;--------------------------------
; Setup TOD, days in month lookup table
;--------------------------------

SetUpTOD

	movlw	31+1		;setup days in month array
	movwf	dmth		;load days+1 in Jan
	movlw	28+1
	movwf	dmth+1		;load days+1 in Feb (2003 is not mod 4 = 0 so it is not a leap year)
	movlw	31+1
	movwf	dmth+2		;load days+1 in Mar
	movlw	30+1
	movwf	dmth+3		;load days+1 in Apr
	movlw	31+1
	movwf	dmth+4		;load days+1 in May
	movlw	30+1
	movwf	dmth+5		;load days+1 in Jun
	movlw	31+1
	movwf	dmth+6		;load days+1 in Jul
	movlw	31+1
	movwf	dmth+7		;load days+1 in Aug
	movlw	30+1
	movwf	dmth+8		;load days+1 in Sep
	movlw	31+1
	movwf	dmth+9		;load days+1 in Oct
	movlw	30+1
	movwf	dmth+10		;load days+1 in Nov
	movlw	31+1
	movwf	dmth+11		;load days+1 in Dec

	return

;-----------------------------------------------------------------------
;####### Start of code (Main Program). Code above are procedures #######
;-----------------------------------------------------------------------

Main					;start of code. Power on jumps to here

	call	SetUpIo			;setup I/O ports & clock
	call	Dly1sec			;
	call	Dly1sec			;wait 2 second for things to settle down
	call	SetUpIo			;setup I/O ports & clock again just to be sure we got it right the first time
	call	ClearRam		;clear ram
	call	SetUpTOD		;set up TOD month index
	call	InitVdc			;initialize the Adc solar input
	call	EnaInt			;enable interrupts

;----------------------------------------
; Align SunCube to facing equator & horizon
;----------------------------------------


CkAlign

	btfsc	FsIPort,FsI		;test if we are aligned
	goto	SEnc			;yes so zero & store encoders

	call	HandJob			;allow hand controller to move & align SunCube
	goto	CkAlign

;----------------------------------------
; Store Alt and Azi zero
;----------------------------------------

SEnc

	setdeg	0,AltEnc
	setdeg	0,AziEnc		;set encoders to zero, assumes facing equator & horizon
	call	Dly250ms
	call	Dly250ms		;delay to debounce jumper removal

;----------------------------------------
; Get which hemisphere, Up switch = North, Down switch = South
;----------------------------------------

GetHemi

	btfsc	DnIPort,DnI		;test if Down requested
	goto	cknh			;no so go check if up request

	bcf	Flags,Hemi		;Southern hemishpere selected		
	movsc	Dn,Deg2.5
	movsc	Up,Deg2.5		;move sc Down and the Up to indicate Southern hemisphere selected
	goto	finhemi			;wait for switch off

cknh
	btfsc	UpIPort,UpI		;test if Up requested
	goto	GetHemi			;no so start over again

	bsf	Flags,Hemi		;Northern hemisphere selected
	movsc	Up,Deg2.5
	movsc	Dn,Deg2.5		;move sc Up and then Down to indicate Northern hemisphere selected

finhemi

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	call	SetCom			;setup port b for comms mode
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	movsc	Up,Deg45		;move sc up to avoid end of day stow
	call	WSwOff			;wait for all switches to be turned off
	call	SetTHb			;start the track update timer

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	bsf	Flags,DoDump		;turn on dianostic data dumps 

	call	SetCom			;setup port b for comms mode
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

;----------------------------------------
; Finally we get to track the sun
;----------------------------------------

TrackSun				;nudge the motors to track max solar voltage

	bcf	Flags,Doze		;reset we are dozing flag to double downcount sleep timer

	btfsc	FsIPort,FsI		;skip if jumper installed (align mode)
	goto	ckhj			;no, so check for time to adjust track

	call	Dly250ms		;debounce jumper
	btfss	FsIPort,FsI		;skip if jumper not installed (track mode)
	goto	CkAlign			;goto align mode	

ckhj
	call	HandJob			;check for and do any hand controller input

	btfss	Flags,THbZ		;check if time to adjust sky point
	goto	TrackSun		;no so wait some more

	bcf	Flags,THbZ		;reset THbZ flag

	btfss	Flags,DoDump		;test if they want a data dump
	goto	nodump			;no so skip it

	call	SetCom			;setup port b for comms mode
	dlylms	1			;let port settle down
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode
	dlylms	1			;let port settle down

nodump
;	call	Recv8n			;receive inward comms character into rcvchr
;	skpnc				;skip if valid character received
;	goto	taltmin			;and do what we are asked to do
;
;	movwf	tempw			;temp save w
;	movlw	'7'+1			;load table max+1
;	subwf	tempw,w			;sub tempw - '7'
;	skpnc				;skip if tempw < '7'
;	goto	taltmin			;no so check min altitude
;
;	movfw	tempw			;reload original value
;	movlw	'0'			;load first jump table command
;	subwf	tempw,w			;sub tempw - '0' to make jump index 0 relative
;	skpc				;skip if tempw >= '0'
;	goto	taltmin			;no so check min altitude
;
;	movwf	temp			;temp save w (jump table index)
;	clrc				;clear carry
;	rlf	temp,w			;rotate left to do index*2 to cover extra exit jump instruction
;	addwf	PCL,f			;add in resultant jump index to PCL and on the next fetch we are there
;
;	call	GetDate			;0
;	goto	taltmin			;
;
;	call	SendDate		;1
;	goto	taltmin			;
;
;	call	GetTime			;2
;	goto	taltmin			;
;
;	call	SendTime		;3
;	goto	taltmin			;
;
;	call	GoAzi			;4
;	goto	taltmin			;
;
;	call	GoAlt			;5
;	goto	taltmin			;
;
;	call	SendSC			;6
;	goto	taltmin			;
;
;	call	TogDump			;7
;	goto	taltmin			;
;
taltmin
	call	TMinAlt			;test for altitude < 0, z = yes
	skpnz				;skip if not min alt
	goto	EndofDay		;yes so do end of day

	call	AAltSp			;calc new alt sky point
	call	MAltSp			;move there

	call	AAziSp			;calc new azi sky point
	call	MAziSp			;move there


;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	call	SetCom			;setup port b for comms mode
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	goto	TrackSun

;----------------------------------------
; End of day processing
;----------------------------------------

EndofDay				;move to overnight stow


;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	call	SetCom			;setup port b for comms mode
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	bsf	Flags,Doze		;set we are dozing flag to stop double sleep time downcount

	movsc	Up,Deg5.0		;move up above min altitude
	call	GoAlt0			;drive back to zero / vertical
	movsc	Dn,Deg7.5		;drive 7.5 deg down to stop crap falling on the lens overnight

	copyenc	AziEnc,SvEnc	 	;save current azi encoder value
	setdeg	0,AziSky		;set facing the equator as new sky point
	call	MAziSp			;move to new facing the equator skypoint

	setdeg	Deg360,AA0		;load max azi sky point+1
	copyenc	SvEnc,Tmp0		;set up to sub west encoder from it
	call	Sub24			;AA=Deg360-west sunset azi, which is morning sunrise azi
	copyenc	AA0,AziSky	 	;set up to slew to opposite of where we started 
	call	MAziSp			;slew to sunrise east azimuth


;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

	call	SetCom			;setup port b for comms mode
	call	DoTAT			;get sky point adjust values
	call	SendSC			;dump the data down the com line
	dlylms	1			;wait for last char to be sent
	call	SetHJ			;setup port b for hand controller mode

;>>>>>>>>>>> DEBUG CODE <<<<<<<<<<

wmorning				;with our work day done, its time to sleep & maybe to dream
	btfsc	Flags,WUpZ		;test if wake up delay is zero
	goto	morning			;nope, so wake up and get to work

	call	HandJob			;is it wake up time
	andlw	0x01			;test if any switched touched
	skpnz				;yup so time to get up and go to work
	goto	wmorning		;wait for morning wakeup call	

morning
	call	SetWUpM			;set wake up minutes to max & clear WUpZ flag
	bcf	Flags,Doze		;clear we are dozing flag

	movsc	Up,Deg15		;move up above min altitude
	call	GoAlt0			;drive back to zero / vertical

	call	SetTHb			;start the THb track timer going
	goto	TrackSun		;go to work to earn some money

;----------------------------------------
; 35 deg Track Adjust Table (TAT)
;----------------------------------------

	org	0x0800			;put TAT at start of second 2 kb code page
					;
TAT					;Track Adjust Table (TAT)
;
; each 2 byte entry in the TAT represents the sun track adjust required
; for that 5 x 5 deg portion of sun track path for 15 seconds of the sun's passage
;
; bits 13:6 hold a max 63 encoder pulses (0.167 deg / 15 seconds) for Altitude tracking adjustment
; bits 7:8 hold a max 255 encodes pulses (0.667 deg / 15 seconds) for Azimuth tracking adjustment
;
; the TAT is indexed by forming an 11 bit index value by resolving the Alt & Azi encoders into 5 deg indexes:
;
; 1) bits 4:5 being the Alt encoder index
; 2) bits 10:6 being the Azi encoder index
;
; to form an 11 bit index which is then added to the TAT base location to access the track adjust encoder values
; a track adjust value of zero (0x000) indicates the real sun track can never enter that portion of the sky and
; that the SunCube's sky point (according to the Alt/Azi encoder registers) is in error
;
;Azi	Alt >>	00	05	10	15	20	25	30	35	40	45	50	55	60	65	70	75	80	85
az0	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x023B,	0x0241,	0x0246,	0x024F,	0x0259,	0x0260,	0x0272,	0x028A,	0x02AA,	0x02DA,	0x0000,	0x0000,	0
	org	$+13																		
az5	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x063B,	0x0640,	0x0646,	0x064E,	0x0658,	0x0663,	0x0670,	0x0687,	0x06A6,	0x06D7,	0x0000,	0x0000,	0
	org	$+13																		
az10	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0A39,	0x0A40,	0x0A45,	0x0A4C,	0x0A54,	0x0A61,	0x0A6F,	0x0A7E,	0x0AA6,	0x0ADA,	0x0000,	0x0000,	0
	org	$+13																		
az15	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0D39,	0x0D40,	0x0D45,	0x0D4C,	0x0D54,	0x0D61,	0x0D6F,	0x0D7E,	0x0DA6,	0x0DDA,	0x0000,	0x0000,	0
	org	$+13																		
az20	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x1135,	0x1137,	0x113C,	0x1143,	0x114C,	0x1153,	0x115E,	0x116E,	0x117F,	0x119C,	0x11C7,	0x0000,	0x0000,	0
	org	$+13																		
az25	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x1433,	0x1437,	0x143C,	0x1441,	0x1448,	0x1451,	0x145B,	0x1468,	0x1480,	0x149C,	0x14C2,	0x0000,	0x0000,	0
	org	$+13																		
az30	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x1831,	0x1835,	0x1839,	0x183F,	0x1846,	0x184D,	0x1857,	0x1862,	0x1877,	0x1898,	0x18BC,	0x0000,	0x0000,	0
	org	$+13																		
az35	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x1B2D,	0x1B30,	0x1B33,	0x1B37,	0x1B3F,	0x1B44,	0x1B49,	0x1B54,	0x1B62,	0x1B73,	0x1B8A,	0x1BAA,	0x0000,	0x0000,	0
	org	$+13																		
az40	dw	0x0000,	0x0000,	0x0000,	0x1E29,	0x1E2A,	0x1E2E,	0x1E32,	0x1E36,	0x1E3A,	0x1E40,	0x1E47,	0x1E4F,	0x1E5A,	0x1E6C,	0x1E80,	0x1E95,	0x0000,	0x0000,	0
	org	$+13																		
az45	dw	0x0000,	0x0000,	0x0000,	0x2027,	0x2029,	0x202C,	0x2031,	0x2034,	0x2039,	0x203D,	0x2043,	0x204A,	0x2053,	0x2062,	0x207A,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az50	dw	0x0000,	0x0000,	0x2324,	0x2326,	0x2329,	0x232B,	0x232F,	0x2332,	0x2335,	0x233B,	0x2341,	0x2345,	0x234F,	0x235D,	0x236E,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az55	dw	0x0000,	0x2421,	0x2523,	0x2526,	0x2528,	0x2529,	0x252D,	0x2530,	0x2532,	0x2536,	0x253B,	0x2542,	0x254B,	0x2556,	0x2563,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az60	dw	0x281E,	0x2520,	0x2722,	0x2724,	0x2726,	0x2728,	0x272B,	0x272E,	0x2730,	0x2733,	0x2736,	0x273C,	0x2744,	0x274A,	0x2753,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az65	dw	0x2B2B,	0x2727,	0x2822,	0x2823,	0x2824,	0x2826,	0x2928,	0x292B,	0x292E,	0x2930,	0x2932,	0x2938,	0x293E,	0x2945,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az70	dw	0x2C1E,	0x2820,	0x2921,	0x2A22,	0x2A23,	0x2A25,	0x2A27,	0x2A28,	0x2A2A,	0x2A2C,	0x2A2E,	0x2A32,	0x2A37,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az75	dw	0x2D1E,	0x2B1F,	0x2B21,	0x2B21,	0x2B22,	0x2B23,	0x2B24,	0x2B26,	0x2B27,	0x2B28,	0x2B2A,	0x2B2C,	0x2B2E,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az80	dw	0x2D1E,	0x2A1F,	0x2B20,	0x2B20,	0x2B21,	0x2B21,	0x2B22,	0x2B22,	0x2B23,	0x2B24,	0x2B25,	0x2B26,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az85	dw	0x2E1E,	0x2B1F,	0x2B1F,	0x2C1F,	0x2C1F,	0x2C1F,	0x2C20,	0x2C20,	0x2C20,	0x2C20,	0x2C21,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az90	dw	0x2D1E,	0x2B1E,	0x2B1E,	0x2C1E,	0x2C1E,	0x2C1D,	0x2C1D,	0x2C1D,	0x2C1D,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az95	dw	0x2D1F,	0x291E,	0x2B1E,	0x2B1D,	0x2B1D,	0x2B1C,	0x2B1B,	0x2B1B,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az100	dw	0x2D1F,	0x2A1E,	0x2A1D,	0x2B1C,	0x2B1C,	0x2B1A,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az105	dw	0x271F,	0x281E,	0x291D,	0x2A1C,	0x2A1B,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az110	dw	0x2A1F,	0x271E,	0x281C,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az115	dw	0x281F,	0x261E,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az120	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az125	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az130	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az135	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az140	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az145	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az150	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az155	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az160	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az165	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az170	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az175	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0

;----------------------------------------
; program end
;----------------------------------------

PeVer	dt	Version
PeCopy	dt	CopyRight

	end

;---------------------------------

Ck37khz	macro

	bsf	STATUS, RP0	;switch to bank 1
	bcf	PCON, OSCF	;change clock to 37khz
	bcf	STATUS, RP0	;switch back to bank 0

	endm

;--------------------------------

Ck4mhz	macro

	bsf	STATUS, RP0	;switch to bank 1
	bsf	PCON, OSCF	;change clock to 4mhz
	bcf	STATUS, RP0	;switch back to bank 0

	endm

;--------------------------------

DoBlink				;blink the led the number of times in w

	movwf	bkcnt		;save blink count

blinkagn
	call	LedOn		;on
	movlw	50
	call	Delaywms	;wait 50ms

	call	LedOff		;off
	movlw	50
	call	Delaywms	;wait 50ms

	decfsz	bkcnt, f	;dec blink count, is it zero?
	goto	blinkagn	;no - so blink them again

	return			;yes - so exit

