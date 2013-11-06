
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

#define 	Version			"SunCube(tm) Tracker Firmware Version 20080824,"
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

;KSz	equ	Deg0.03			;kreep sizew
NSz	equ	Deg0.05			;size of nudge steps
MNCnt	equ	Deg2.0/Deg0.05		;no more than 2 degs of "On Sun" nudge cycles as we are then outside the SPA sky point window
NResSz	equ	NSz*MNCnt		;size of lost sun movement back to start

BrkMs	equ	8			;ms of applied reverse voltage to brake motor to a stop

MinAlt	equ	Deg7.5			;altitude when hit when facing west that we go to sleep

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
; Timer 1 equates
;-----------------------------------------------------------------------

tius	equ	4			;4 us per count
ticks	equ	65536			;16 bits
maxtime	equ	tius*ticks		;max time from 0x0000 to 0x0000 (262,144 us)
intcks	equ	8			;delay time in us between T1 overflow and T1 lsb reset
ticker	equ	250000-intcks 		;desired time between t1 interrupts in us
tickval	equ	(maxtime-ticker)/tius 	;value to generate T1 ints every 250ms
t1low	equ	low(tickval)		;preset for TMR1L
t1high	equ	high(tickval)		;preset for TMR1H

;-----------------------------------------------------------------------
; T1 timer driven 250 ms heartbeat constants
;-----------------------------------------------------------------------

HbPSec	equ	4			;heart beats per second
TrkTmr	equ	15*HbPSec		;15 sec per track adjust
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

#define	En2	2			;Motor emcoder power
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

#define	UpI	1			;up switch
#define	UpIPort	PORTB

#define	CcI	2			;cc switch
#define	CcIPort	PORTB

#define CwI	3			;cw switch
#define CwIPort	PORTB

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
#define DirB	b'11001111'		;0=output,1=input
#define	IntB	b'00000000'		;initial port B data
#define	SwAnd	b'00001111'		;input switch layout

;-----------------------------------------------------------------------
; EE Data memory allocations
;-----------------------------------------------------------------------

	org	EeData0			;set start for EE data memory
E0	res	32			;32 bytes of test data storage
EeValid	de	0			;EE data memory valid,1 = valid,0 = empty
EeAlt	de	0xaa,0x55,0xaa		;saved alt encoder
EeAzi	de	0x55,0xaa,0x55		;saved azi encoder
EeHemi	de	0			;saved hemisphere
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

TEMPB2	res	1
TEMPB1	res	1
TEMPB0	res	1

#define	_C	STATUS,0
#define	_Z	STATUS,2

;--------------------------------
; System variables
;--------------------------------

MDir	res	1			;motor direction register
MRun	res	1			;any motor running flag
HJob	res	1			;flag for Hand Job big motor movement request
BrkOn	res	1			;motor break on flag
SunVdc	res	1			;last value of solar Vdc
SFSR	res	1			;saved FSR
AlyOrun	res	1			;altitute encoder overrun
AziOrun	res	1			;azimuth encoder overrun
AltI	res	1			;Azimuth TAT index value
AziI	res	1			;Altitude TAT index value
AltEnc	res	3			;altitude encoder position 0 - 139,999
AziEnc	res	3			;azimuth encoder position 0 - 139,999
MovEnc	res	3			;desired encoder movement (0 - 139,999 pulses)
GoEast	res	3			;end of day East drive
NHemi	res	1			;hemisphere, North = 1,South = 0
EeAdr	res	1			;EE address
Slice	res	1			;sky scan slice cont
VdcTar	res	1			;solar Vdc target
CwSrch	res	1			;flag to do do Cw search
WUpHb	res	1			;Sleep Heart beat down counter
WUpMd	res	2			;Wake up minutes delay down counter
WUpMZ	res	1			;Wake up minutes zero flag
Doze	res	1			;flag to indicate are are dozing as we wait for the sun to rise
NCnt	res	1			;number of "On Sun" nudge cycles
Hb	res	2			;250ms 16 bit track delay down counter
HbZ	res	1			;Hb went zero flag

;leave Hbz as last variable

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
AARGB2	res	1
AARGB1	res	1
AARGB0	res	1			;40 bit encoder & adjusted value
B0Avil	equ	savewi-HbZ-1		;amount of ram left in bank 0

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------

dlylms	macro	dlyl			;delay for lit ms
	movlw	dlyl			;set up delay lit in w
	call	Dlywms			;now do the delay
	endm

;--------------------------------

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
	call	MoveIt			;make it happen
	endm

;--------------------------------

movtat	macro	dir
	movwf	MovEnc
	clrf	MovEnc+1
	clrf	MovEnc+2
	movlf	dir,MDir		;set movement direction
	call	MoveIt			;make it happen
	endm
;--------------------------------

dosq	macro	deg			;four position scan

	movsc	Up,deg			;move to position 1
	movsc	Cc,deg
	call	DoVdc			;get solar intensity
	skpnc				;c = Sun >= Target
	retlw	1			;nc = Sun < Target

	movsc	Cw,deg*2		;move to position 2
	call	DoVdc
	skpnc				;no,so check another sky point
	retlw	2			;yes so return

	movsc	Dn,deg*2		;move to position 1
	call	DoVdc
	skpnc				;no,so check another sky point
	retlw	3			;yes so return

	movsc	Cc,deg*2		;move to position 4
	call	DoVdc
	skpnc				;no,so check another sky point
	retlw	4			;yes so return

	movsc	Cw,deg
	movsc	Up,deg			;back to home
	retlw	0
	endm

;-----------------------------------------------------------------------
; >>>>>>>>>>>>>>> Power on entry point <<<<<<<<<<<<<<<
;-----------------------------------------------------------------------

	org	0x0000			;power on reset entry point <<<<<<<<<<<<<<<
	goto	Main			;go to start of main code

;-----------------------------------------------------------------------
; Interrupt handler
;-----------------------------------------------------------------------

	org	0x0004			;interrupt entry point <<<<<<<<<<<<<<<<<
	movwf	savewi			;save w
	swapf	STATUS,w		;load status into w but in reversed lsb & msb order
	movwf	savest			;save status flags
	clrf	STATUS			;clear status and select register bank 0
	movff	FSR,saveFSR		;save FSR

;-- Specific interrupt handler code follows --

	btfss	INTCON,RBIE		;is the encoder interrupt enabled
	goto	tmr1int			;no so it is a timer interrupt
	btfsc	INTCON,RBIF		;is it an encoder interrupt? 4us to get here
	goto	dorbif			;yes so handle it

;-- Handle T1 timer interrupt & related down counters --

tmr1int
	bcf	PIR1,TMR1IF		;clear T1 interrupt flag
	movlf	t1high,TMR1H		;reset start value
	movlf	t1low,TMR1L		;

;-- Handle track delay down counter --

	movfw	Hb			;load lsb
	iorwf	Hb+1,w			;or in msb
	skpz				;skip if zero
	goto	decHb

	movlf	low(TrkTmr),Hb		;reset num of HBs per track update
	movlf	high(TrkTmr),Hb+1 	;
	bsf	HbZ,0			;set HbZ flag
	goto	doWUp

decHb
	movf	Hb,f			;is track delay Hb lsb zero
	skpnz				;no so skip
	goto	ckHb1			;yes so check msb

	decf	Hb,f			;no so dec it
	goto	doWUp			;handle wake up down counter

ckHb1
	movf	Hb+1,f			;lsb = 0, so is msb = 0?
	skpnz				;no, so dec them both
	goto	doWUp			;yes so reset it

	decf	Hb,f			;dec Hb lsb to make it non zero
	decf	Hb+1,f			;dec Hb msb for borrow

;-- Handle wake up down counter --

doWUp					;handle sleep delay
	decfsz	WUpHb,f			;dec wake up heart beat down counter
	goto	intfin			;not zero so finish up interrupt

	movlf	HbPSec*60,WUpHb		;reset wake up heart beat to minute counter
	call	DecWupD			;dec wake up delay by 1 minute
	btfss	Doze,0			;skip double downcount if we are dozing
	call	DecWupD			;dec wake up delay by 1 minutes				
	goto	intfin

;-- Handle encoder pulse interrupt --

dorbif
	movfw	MovEnc			;load lsb
	iorwf	MovEnc+1,w		;or in lsb+1
	iorwf	MovEnc+2,w		;or in lsb+2 & test if movenc is zero
	skpz				;is movement finished?
	goto	decenc1			;no so go to dec move count

	btfsc	BrkOn,0			;are we breaking
	goto	ckifup			;yes so leave motor drive state alone, just count the encoder pulse
	movlf	0,MRun			;flag all motors stopped
	movlf	IntA,PORTA		;turn off azimuth motor but leave encoders powered on for now
	clrf	PORTB			;turn off altitude motor
	goto	ckifup			;movement finished but motor still moving, so update encoder position

decenc1
	movlf	MovEnc,FSR
	call	DecEnc			;dec enc pulses to move

ckifup
	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckifdn			;nope, so check if moving down

	movlf	AltEnc,FSR
	call	IncEnc			;inc alt encoder position
	goto	encfin

ckifdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckifcc			;nope,so check if moving cc

	movlf	AltEnc,FSR
	call	DecEnc			;dec alt encoder position
	goto	encfin

ckifcc
	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckifcw			;nope, so check if moving cw

	movlf	AziEnc,FSR
	btfss	NHemi,0			;test if Northern hemishpere
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

	movlf	AziEnc,FSR
	btfss	NHemi,0			;test if Northern hemishpere
	goto	DoDec			;dec Azi encoder for Cw in southern hemi
	goto	DoInc			;inc Azi encoder for Cw in northern hemi

encfin
	btfss	HJob,0			;is this a HJob movement
	goto	adjenc			;no so just delay past the leading edge of the encoder oulse

	movfw	PORTB			;read state of switches
	andlw	SwAnd			;isol out switch bits
	sublw	SwAnd			;test if they are all 1s/ off
	skpz				;skip if no switches are on
	goto	adjenc			;yes so let movement continue

	bcf	HJob,0			;no switches on so turn off HJob flag
	setdeg	Deg0.05,MovEnc		;turn long movement into short movement

adjenc
	movlf	400/3,tempi		;set for 2oo us delay at 8mhz clock rate

encx
	decfsz	tempi,f			;do delay to move past edge of encoder pulse
	goto	encx

	movfw	PORTB			;clear B change (encoder pulse edge change happened)
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
;       24x16 Bit Unsigned Fixed Point Multiply 24x16 -> 40
;       Input:  24 bit unsigned fixed point multiplicand in AARGB0
;               16 bit unsigned fixed point multiplier in BARGB0
;       Output: 40 bit unsigned fixed point product in AARGB0
;-----------------------------------------------------------------------

DoTAT					;index the TAT to get the Alt & Azi track adjust values
	movff	AltEnc,AARGB0
	movff	AltEnc+1,AARGB1
	movff	AltEnc+2,AARGB2 	;load current Altitude encoder to multiply

	call	DoMult34		;do the multiply to get the 5 deg index
	movff	AARGB2,AltI		;save altitude index

	movff	AziEnc,AARGB0
	movff	AziEnc+1,AARGB1
	movff	AziEnc+2,AARGB2 	;load current Azimuth encoder to multiply

	call	DoMult34		;do the multiply
	movff	AARGB2,AziI		;save azimuth index

	movff	AziI,AARGB0
	clrf	AARGB1
	clrf	AARGB2			;load Azimuth TAT index to multiply by 32
	call	DoMult32		;do the multiply to move the Azi index into 10:8

	movfw	AltI			;load Altitude TAT index
	addwf	AARGB0,f		;add in Altitude TAT index to Azimuth TAT and store
	bsf	AARGB1,3		;full TAT index now in AARGB0/B1

	banksel EEADRH			;Select Bank of EEADRH
	movff	AARGB0,EEADR 		;lsb of program address to read
	movff 	AARGB1,EEADRH		;msb of program address to read
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

	call	StoTAT

	return

;----------------------------------------

DoMult2
	clrc
	rlf	AARGB0,f
	rlf	AARGB1,f
	rlf	AARGB2,f

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
	clrc
	movff	AARGB0,TEMPB0
	rlf	TEMPB0,f

	movff	AARGB1,TEMPB1
	rlf	TEMPB1,f

	movff	AARGB2,TEMPB2
	rlf	TEMPB2,f		;mult by 2 and save

	call	DoMult2			;x2
	call	DoMult2			;x4
	call	DoMult2			;x8
	call	DoMult2			;x16
	call	DoMult2			;x32

	movfw	TEMPB0
	addwf 	AARGB0,f

	movfw	TEMPB1
	btfsc 	_C
	incfsz 	TEMPB1,W
	addwf 	AARGB1,f
	
	movfw	TEMPB2
	btfsc 	_C
	incfsz 	TEMPB2,W
	addwf 	AARGB2,f		;add X2 + X32 value to get X34
	return

;-----------------------------------------------------------------------
; Time procedures
;-----------------------------------------------------------------------

DecWupD					;dec 16 bit Wake up delay
	movf	WUpMd,f			;is sleep delay lsb zero
	skpnz				;no so skip
	goto	ckWb1			;yes so check msb

	decf	WUpMd,f			;no so dec it
	goto	ckWUpDZ			;check if downcount finished

ckWb1
	movf	WUpMd+1,f		;lsb = 0, so is msb = 0?
	skpnz				;no, so dec them both
	goto	ckWUpDZ			;yes so test if finished

	decf	WUpMd,f			;dec sleep delay lsb to make it non zero
	decf	WUpMd+1,f		;dec sleep delay msb for borrow

ckWUpDZ
	movfw	WUpMd			;load lsb
	iorwf	WUpMd+1,w		;or in msb
	skpnz				;skip if not zero
	bsf	WUpMZ,0			;set wake up minutes zero flag
	return

;----------------------------------------

WaitHb
	call	TSwOn			;test if any switches on?
	skpz				;skip if no
	return				;yes so return

	btfss	HbZ, 0			;check if time to adjust sky point
	goto	WaitHb			;not yet, so wait some more

;--------------------------------

SetHb					;reset Heart Beat timer
	movlf	low(TrkTmr),Hb		;set delay timer
	movlf	high(TrkTmr),Hb+1 	;
	bcf	HbZ,0			;reset Hb flag
	return

;--------------------------------

SetWUpMd				;set wake up minutes delay
	movlf	low(DayMin),WUpMd	;
	movlf	high(DayMin),WUpMd+1	;set sleep timer to max (1,440) minutes
	bcf	WUpMZ,0			;reset wake up minutes zero flag
	return

;--------------------------------

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

;--------------------------------

Dly5ms
	movlw	5			;delay for 5ms
	goto	Dlywms

;--------------------------------

Dly10ms
	movlw	10			;delay for 10 ms
	goto	Dlywms

;--------------------------------

Dly25ms
	movlw	25			;delay for 25 ms
	goto	Dlywms

;--------------------------------

Dly100ms				;delay for 100 ms
	movlw	100
	goto	Dlywms

;--------------------------------

Dly150ms				;delay for 150ms
	movlw	150
	goto	Dlywms

;--------------------------------

Dly250ms
	movlw	250			;delay for 250ms

;--------------------------------

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

;--------------------------------

Dly1sec
	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms
	call	Dly250ms		;delay for 250ms
	return

;-----------------------------------------------------------------------
; EEprom procedures
;-----------------------------------------------------------------------

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

;--------------------------------

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

;--------------------------------

ResEe					;restore from Ee if valid
	movlf	low(EeValid),EeAdr 	;load address of Ee valid flag
	call	EeRead			;load value
	skpnz				;skip if valid
	return				;return if not

	movlf	low(EeAlt),EeAdr
	call	EeRead
	movwf	AltEnc+2
	movlf	low(EeAlt+1),EeAdr
	call	EeRead
	movwf	AltEnc+1
	movlf	low(EeAlt+2),EeAdr
	call	EeRead
	movwf	AltEnc			;load alt encoder position from Ee and restore

	movlf	low(EeAzi),EeAdr
	call	EeRead
	movwf	AziEnc+2
	movlf	low(EeAzi+1),EeAdr
	call	EeRead
	movwf	AziEnc+1
	movlf	low(EeAzi+2),EeAdr
	call	EeRead
	movwf	AziEnc			;load azi encoder position from Ee and restore

	movlf	low(EeHemi),EeAdr
	call	EeRead
	movwf	NHemi			;restore hemisphere
	retlw	0xff			;return with flag that Ee data is valid and has been loaded

;--------------------------------

StoEnc					;store alt & azi encoders in Ee
	movlf	low(EeAlt),EeAdr
	movfw	AltEnc+2
	call	EeWrite
	movlf	low(EeAlt+1),EeAdr
	movfw	AltEnc+1
	call	EeWrite
	movlf	low(EeAlt+2),EeAdr
	movfw	AltEnc
	call	EeWrite			;store alt encoder value in Ee

	movlf	low(EeAzi),EeAdr
	movfw	AziEnc+2
	call	EeWrite
	movlf	low(EeAzi+1),EeAdr
	movfw	AziEnc+1
	call	EeWrite
	movlf	low(EeAzi+2),EeAdr
	movfw	AziEnc
	call	EeWrite			;store azi encoder value in Ee
	return

;--------------------------------

StoTAT					;store TAT data
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

;-------

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
	movfw	AltEnc+0
	call	EeWrite			;store it

	return

;--------------------------------

StoHemi					;store hemisphere
	movlf	low(EeHemi+1),EeAdr
	movfw	NHemi
	call	EeWrite
	return

;-----------------------------------------------------------------------
; Shaft encoder procedures
;-----------------------------------------------------------------------

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

;--------------------------------

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

;-----------------------------------------------------------------------
; Motor drive & management procedures
;-----------------------------------------------------------------------

MoveIt					;motor controller
	bcf	INTCON,GIE		;disable all interrupts
	movfw	PORTA			;load state of port A
	iorlw	EncOn			;set encoder power bits to on
	movwf	PORTA			;write results back to port A
	call	Dly5ms			;wait for encoder filter cap to charge
	movfw	PORTB			;read port B to latch new encode on state
	bcf	INTCON,RBIF		;clear port b change flag
	bsf	INTCON,RBIE		;enable encoder pulse interrupts
	bsf	INTCON,GIE		;reenable all interrupts

	movlf	1,MRun			;flag we have a motor running
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

;--------------------------------

DoDn
	movlw	DnOData
	movwf	DnOPort			;turn on Down drive

WDnFin
	btfsc	MRun,0			;test if motor still running
	goto	WDnFin			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	BrkOn,0			;flag we are breaking
	movlw	UpOData
	movwf	UpOPort			;turn on reverse Up drive as a brake
	goto	DoBrk			;goto wait for breaking to finish

;--------------------------------

DoUp
	movlw	UpOData
	movwf	UpOPort			;turn on Up drive

WUpFin
	btfsc	MRun,0			;test if motor still running
	goto	WUpFin			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	BrkOn,0			;flag we are breaking
	movlw	DnOData
	movwf	DnOPort			;turn on reverse Dn drive as a break
	goto	DoBrk			;goto wait for breaking to finish

;--------------------------------

DoCc
	movlw	CcOData
	movwf	CcOPort			;turn on Cc drive

WCcFin
	btfsc	MRun,0			;test if motor still running
	goto	WCcFin			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	BrkOn,0			;flag we are breaking
	movlw	CwOData
	movwf	CwOPort			;turn on reverse Cw drive as a break
	goto	DoBrk			;goto wait for breaking to finish

;--------------------------------

DoCw
	movlw	CwOData
	movwf	CwOPort			;turn on Cw drive

WCwFin
	btfsc	MRun,0			;test if motor still running
	goto	WCwFin			;yup so go test for stopped again

	call	Dly10us
	call	Dly10us			;wait 20us before turning on reverse drive

	bsf	BrkOn,0			;flag we are breaking
	movlw	CcOData
	movwf	CcOPort			;turn on reverse Cc drive as a break

DoBrk
	dlylms	7			;delay BrkMs for reverse drive to almost stop motor
	movlf	IntA,PORTA		;turn off azimuth motor but leave encoders powered on for now
	clrf	PORTB			;turn off altitude motor
	bcf	BrkOn,0			;turn off we are breaking flag
	call	Dly250ms		;delay another 250 ms to be sure we are stopped	

	bcf	INTCON,RBIE		;disable encoder pulse interrupts

	movfw	PORTA			;load state of port A 
	andlw	EncOff			;turn off encoder power bits
	movwf	PORTA			;write result back to port A
	call	Dly5ms			;wait for encoder filter cap to discharge

	return

;----------------------------------------------------------
; Tracking procedures
;----------------------------------------------------------

GoAlt0					;drive to altitude zero
	movff	AltEnc,MovEnc
	movff	AltEnc+1,MovEnc+1
	movff	AltEnc+2,MovEnc+2 	;set up slew back to zero alt
	movlf	Dn,MDir			;set direction down
	goto	MoveIt			;slew to 0 altitude
;--------------------------------

TWest					;test if facing west
	movf	AziEnc+2,f		;is azi msb 0?
	return				;nz = East (sunrise), z = West (sunset)

;--------------------------------

TAl90					;test if alt > 90
	movfw	AltEnc+1
	sublw	high(Deg90)		;c = <= 90,nc = >90
	return				;return

;--------------------------------

TAl0					;test if alt < 0
	movf	AltEnc+2,f		;nz = < 0, z = >= 0
	return				;

;--------------------------------

TMinAlt					;return nc if alt <= minimum alt
	bcf	STATUS,C		;clear carry to assume <= min alt
	movf	AltEnc+2,f		;test alt 23:8
	skpz				;skip if not zero (alt < zero)
	return				;msb is < zero so exit with nc

	movlw	high(MinAlt)		;load min altitude high byte
	subwf	AltEnc+1,w		;is it < min alt
	return				;c = alt >= min alt, nc = < min alt

;--------------------------------

DrillIt
	call	NudgeCw
	call	NudgeCc
	call	NudgeDn
	call	NudgeUp
	call	SetHb
	return

;-------------------------------

KreepCc
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	return				;switch active so exit

	movfw	AziC			;load TAT track adjust
	skpnz				;skip if non zero
	return				;zero so just return

	movtat	Cc			;move Cc according to the stored TAT correction
;	movsc	Cc,KSz			;Creep SC sky point Cc
	return

;--------------------------------

KreepCw
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	return				;switch active so exit

	movfw	AziC			;load TAT track adjust
	skpnz				;skip if non zero
	return				;zero so just return

	movtat	Cw			;move Cw according to the stored TAT correction
;	movsc	Cw,KSz			;Creep SC sky point Cw
	return

;--------------------------------

KreepUp
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	return				;switch active so exit

	movfw	AltC			;load TAT track adjust
	skpnz				;skip if non zero
	return				;zero so just return

	movtat	Up			;move Up according to the stored TAT correction
;	movsc	Up,KSz			;Creep SC sky point Up
	return

;--------------------------------

KreepDn
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	return				;switch active so exit

	movfw	AltC			;load TAT track adjust
	skpnz				;skip if non zero
	return				;zero so just return

	movtat	Dn			;move Dn according to the stored TAT correction
;	movsc	Dn,KSz			;Creep SC sky point Dn
	return

;-------------------------------

NudgeCc
	movlf	MNCnt+1,NCnt		;set max nudge count

NCc
	decfsz	NCnt,f			;dec max Nudge count
	goto	DNCc			;skip if another nudge is ok
	movsc	Cw,NResSz		;back up to original position
	retlw	0			;no so exit

DNCc
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	retlw	0			;switch active so exit

	call	DoVdc
	movff	SunVdc,VdcTar
	movsc	Cc,NSz			;nudge SC sky point
	call	DoVdc			;get solar intensity
	skpnc				;c = New < Old
	goto	NCc			;found higher sun, so do it again

	movsc	Cw,NSz*2		;found edge of peak so move back a bit
	retlw	1			;good "On Sun" update

;--------------------------------

NudgeCw
	movlf	MNCnt+1,NCnt		;set max nudge count

NCw
	decfsz	NCnt,f			;dec max Nudge count
	goto	DNCw			;skip if another nudge is ok
	movsc	Cc,NResSz		;back up to original position
	retlw	0			;no so exit

DNCw
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	retlw	0			;switch active so exit

	call	DoVdc
	movff	SunVdc,VdcTar
	movsc	Cw,NSz			;nudge SC sky point
	call	DoVdc			;get solar intensity
	skpnc				;c = New < Old
	goto	NCw			;found higher sun, so do it again

	movsc	Cc,NSz*2		;found edge of peak so move back a bit
	retlw	1

;--------------------------------

NudgeUp
	movlf	MNCnt+1,NCnt		;set max nudge count

NUp
	decfsz	NCnt,f			;dec max Nudge count
	goto	DNUp			;skip if another nudge is ok
	movsc	Dn,NResSz		;back up to original position
	retlw	0			;no so exit

DNUp
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	retlw	0			;switch active so exit

	call	DoVdc
	movff	SunVdc,VdcTar
	movsc	Up,NSz			;nudge SC sky point
	call	DoVdc			;get solar intensity
	skpnc				;nc = New < Old
	goto	NUp			;found higher sun, so do it again

	movsc	Dn,NSz*2		;found edge of peak so move back a bit
	retlw	1

;--------------------------------

NudgeDn
	movlf	MNCnt+1,NCnt		;set max nudge count

NDn
	decfsz	NCnt,f			;dec max Nudge count
	goto	DNDn			;skip if another nudge is ok
	movsc	Up,NResSz		;back up to original position
	retlw	0			;no so exit

DNDn
	call	TSwOn			;test if hand controller active
	skpz				;skip if no switches active
	retlw	0			;switch active so exit

	call	DoVdc
	movff	SunVdc,VdcTar
	movsc	Dn,NSz			;nudge SC sky point
	call	DoVdc			;get solar intensity
	skpnc				;nc = New < Old
	goto	NDn			;found higher sun, so do it again

	movsc	Up,NSz*2		;found edge of peak so move back a bit
	retlw	1

;--------------------------------	

TrackNE
	movlf	7,crcnt			;set creep counter

Cne
	call	DoTAT			;get TAT track adjust value
	call	KreepCw			;do micro track adjust
	call	KreepUp			;do micro track adjust
	call	WaitHb			;wait for Hb & reset HB
	decfsz	crcnt,f			;dec creep counter
	goto	Cne			;do it again if temp not zero

	movlf	Adc18V,VdcTar		;set min On Sun adjust voltage
	call	DoVdc			;get sc voltage
	skpc				;skip if >= to what we want
	goto	fintne			;no so exit

	call	NudgeCw
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeCc			;no so try the other way

	call	NudgeUp
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeDn			;no so try the other way

fintne
	return

;--------------------------------

TrackNW
	movlf	7,crcnt			;set creep counter

Cnw
	call	DoTAT			;get TAT track adjust value
	call	KreepCw			;do micro track adjust
	call	KreepDn			;do micro track adjust
	call	WaitHb			;wait for Hb & reset HB
	decfsz	crcnt,f			;dec creep counter
	goto	Cnw			;do it again if temp not zero

	movlf	Adc18V,VdcTar		;set min On Sun adjust voltage
	call	DoVdc			;get sc voltage
	skpc				;skip if >= to what we want
	goto	fintnw			;no so exit

	call	NudgeCw
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeCc			;no so try the other way

	call	NudgeDn
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeUp			;no so try the other way

fintnw
	return

;--------------------------------

TrackSE
	movlf	7,crcnt			;set creep counter

Cse
	call	DoTAT			;get TAT track adjust value
	call	KreepCc			;do micro track adjust
	call	KreepUp			;do micro track adjust
	call	WaitHb			;wait for Hb & reset HB
	decfsz	crcnt,f			;dec creep counter
	goto	Cse			;do it again if temp not zero

	movlf	Adc18V,VdcTar		;set min On Sun adjust voltage
	call	DoVdc			;get sc voltage
	skpc				;skip if >= to what we want
	goto	fintse			;no so exit

	call	NudgeCc
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeCw			;no so try the other way

	call	NudgeUp
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeDn			;no so try the other way

fintse
	return

;--------------------------------

TrackSW
	movlf	7,crcnt			;set creep counter

Csw
	call	DoTAT			;get TAT track adjust value
	call	KreepCc			;do micro track adjust
	call	KreepDn			;do micro track adjust
	call	WaitHb			;wait for Hb & reset HB
	decfsz	crcnt,f			;dec creep counter
	goto	Csw			;do it again if temp not zero

	movlf	Adc18V,VdcTar		;set min On Sun adjust voltage
	call	DoVdc			;get sc voltage
	skpc				;skip if >= to what we want
	goto	fintsw			;no so exit

	call	NudgeCc
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeCw			;no so try the other way

	call	NudgeDn
	iorlw	0x01			;test if we found hot spot
	skpnz				;skip if we got a good "On Sun" update
	call	NudgeUp			;no so try the other way

fintsw
	return

;--------------------------------

Up2.0					;move Up 2.0 deg and test solar voltage
	movsc	Up,Deg2.0		;slew up 2.0 deg
	goto	DoVdc			;read solar voltage

;--------------------------------

Dn2.0					;move Up 2.0 deg and test solar voltage
	movsc	Dn,Deg2.0		;slew up 2.0 deg
	goto	DoVdc			;read solar voltage

;--------------------------------

Cc2.0					;move Cc 2.0 deg and test solar voltage
	movsc	Cc,Deg2.0		;slew Cc 2.0 deg
	goto	DoVdc			;read solar voltage

;--------------------------------

Cw2.0					;move Cw 2.0 deg and test solar voltage
	movsc	Cw,Deg2.0		;slew Cw 2.0 deg
	goto	DoVdc			;read solar voltage

;--------------------------------

SkyScan					;scan the sky looking for the morning sun
	movlf	Adc20V,VdcTar		;set 20 Vdc as solar voltage target
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

;-----------------------------------------------------------------------
; Hand controller
;-----------------------------------------------------------------------

HandJob
	movfw	DnIPort			;read hand controller switches
	andlw	SwAnd			;isolate all switch bits, 1 = off / open
	sublw	SwAnd			;test if any swithes on
	skpz				;skip if no switches are on
	goto	ckidn			;switch/s are on so find out which one
	retlw	0

ckidn
	btfsc	DnIPort,DnI		;test if Down requested
	goto	ckiup			;no so go check if up request

	movlf	Dn,MDir			;yes so set direction
	goto	FinHJ			;goto common HJ stuff

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
	movlf	Adc1.5V,VdcTar		;set solar target voltage = 1.5 Vdc (Isc test)
	call	DoVdc			;get solar voltage and test
	skpc				;skip if solar >= target
	goto	SmallMove		;no, so small step during Isc test

	movlf	Adc14V,VdcTar		;set solar target voltage = 14 Vdc
	call	DoVdc			;get solar voltage and test
	skpnc				;skip if solar < target
	goto	SmallMove		;no so small step when on sun

	setdeg	Deg90,MovEnc		;set big off sun movement size
	bsf	HJob,0			;flag this movement is a HJob request
	goto	FinHJ2			;go to common SC HJ movement starter

SmallMove
	setdeg	Deg0.05,MovEnc		;set small on sun movement size

FinHJ2
	call	MoveIt			;do the selected movement
	call	SetHb			;set new next track adjust delay
	retlw	1			;exit with handJob did something flag set

;--------------------------------

TSwOn					;test if any switch is on
	movfw	CcIPort			;read switches
	andlw	0x0f			;isol switch bits
	sublw	0x0f			;nzero = any switch on
	return

;--------------------------------

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

;-----------------------------------------------------------------------
; Adc procedures
;-----------------------------------------------------------------------

DoVdc
	bsf	ADCON0,GO		;start A/D conversion

waitadc
	btfsc	ADCON0,GO		;Wait for "GO" to be reset by adc complete
	goto	waitadc			;no - so go to wait for adc complete

	movff	ADRESH,SunVdc		;load adc msb [10:8] into SunVdc
	movfw	VdcTar			;load solar target voltage to w
	subwf	SunVdc,w		;sub SunVdc - W(VdcTar), c = SunVdc >= VdcTar, nc = SunVdc < VdcTar
	return				;with result in carry

;--------------------------------

InitVdc					;initialize the Adc to the solar input
	bsf	STATUS,RP0		;select bank 1
	movlf	b'01000000',ADCON1	;left justified data,vref = AVdd/AVss,system clock / 2
	bcf	STATUS,RP0		;select bank 0
	movlf	b'01001001',ADCON0	;Fosc/16,channel 0,done,adc on
	return

;-----------------------------------------------------------------------
; Initialization procedures
;-----------------------------------------------------------------------

SetupIo					;setup the I/O ports
	clrf	PORTA			;set all port A outputs to zero

	movlw	IntB			;load initial port B output constants
	movwf	PORTB			;set initial port B output bits

	bsf	STATUS,RP0		;setup bank 1 registers

	movlw	0x72			;select intrc 8 Mhz
	movwf	OSCCON			;make it so

	movlw	DirA			;load port A direction constant
	movwf	TRISA			;initialize port A data direction register

	movlw	DirB			;load port B direction constant
	movwf	TRISB			;initialize port B data direction register

	bcf	OPTION_REG,7		;enable global weak pullups
	movlw	AnalA
	movwf	ANSEL			;select analog input channels

	bcf	STATUS,RP0		;back to bank 0

	return

;--------------------------------

EnaInt					;enable interrupts
	movlf	t1low,TMR1L		;
	movlf	t1high,TMR1H		;set initial values for the T1 250ms heart beat
	call	SetHb			;setup track timer
	call	SetWUpMd		;setup sleep timer
	movlf	0x31,T1CON		;set up T1 timer for interrupts
	clrf	PIR1			;clear any pending T1 interrupt flags
	banksel	PIE1
	movlf	0x01,PIE1		;enable T1 interrupts
	banksel	PORTB
	bsf	INTCON,PEIE		;enable timer interrupts
	bsf	INTCON,GIE		;enable general interrupts

	return

;--------------------------------

ClearRam				;clear ram to zero
	movlf	ram0,FSR		;set pointer to start of ram

nxtclr					;clear bank 0 ram from 0x20 thru 0x7f
	clrf	INDF			;clear @ pointer
	incf	FSR,f			;inc pointer
	btfss	FSR,7			;test if cleared last ram
	goto	nxtclr			;no - so go clear more ram

	return

;-----------------------------------------------------------------------
; Main Program
;-----------------------------------------------------------------------

Main					;start of code
	call	SetupIo			;setup I/O ports & clock
	call	Dly1sec			;
	call	Dly1sec			;wait 2 second for things to settle down
	call	SetupIo			;setup I/O ports & clock again just ot be sure we got it right the first time
	call	ClearRam		;clear ram
	call	InitVdc			;initialize the Adc solar input
	call	EnaInt			;enable interrupts
	call	ResEe			;retore from Ee if valid

;--------------------------------
; Align SunCube to facing equator & horizon
;--------------------------------

CkAlign
	btfsc	FsIPort,FsI		;test if we are aligned
	goto	SEnc			;yes so zero & store encoders

	call	HandJob			;allow hand controller to move & align SunCube
	goto	CkAlign

;--------------------------------
; Store Alt and Azi zero
;--------------------------------

SEnc
	setdeg	0,AltEnc
	setdeg	0,AziEnc		;set encoders to zero, assumes facing equator & horizon
	call	StoEnc			;store encoders
	call	Dly250ms
	call	Dly250ms		;delay to debounce jumper removal
;#################### debug code ############
;magn
;	movsc	Cc,Deg0.05
;	call	StoTAT
;	goto	$
;############################################
;--------------------------------
; Get which hemisphere, Up switch = North, Down switch = South
;--------------------------------

GetHemi
	btfsc	DnIPort,DnI		;test if Down requested
	goto	cknh			;no so go check if up request

	bcf	NHemi,0			;Southern hemishpere selected		
	movsc	Dn,Deg2.5
	movsc	Up,Deg2.5		;move sc Down and the Up to indicate Southern hemisphere selected
	goto	finhemi			;wait for switch off

cknh
	btfsc	UpIPort,UpI		;test if Up requested
	goto	GetHemi			;no so start over again

	bsf	NHemi,0			;Northern hemisphere selected
	movsc	Up,Deg2.5
	movsc	Dn,Deg2.5		;move sc Up and then Down to indicate Northern hemisphere selected

finhemi
	call	StoHemi			;store hemisphere
	movsc	Up,Deg45		;move sc up to avoid end of day stow
	call	WSwOff			;wait for all switches to be turned off

;--------------------------------
; Get sun search quadrant
;--------------------------------
;
;GetQuad				;get search quadrant
;	btfsc	CwIPort,CwI		;test if Cw search requested
;	goto	ckCcI
;
;	bsf	CwSrch,0		;set Cw search request
;	movsc	Cw,Deg2.5
;	goto	finquad	
;
;ckCcI	
;	btfsc	CcIPort,CcI		;test if Cc requested
;	goto	ckUpi
;
;	bcf	CwSrch,0		;clear Cw search request
;	movsc	Cc,Deg2.5
;
;ckUpi
;	btfsc	UpIPort,UpI		;test if Up requested
;	goto	GetQuad
;
;	movsc	Up,Deg10		;move up to show Sun search now manual
;	call	SetHb			;start track timer

	goto	TrackSun		;go here to allow hand movement and sun tracking

;finquad
;	call	WSwOff			;wait for all switches to be turned off
;
;-----------------------------------------------------------------
; Do a sky scan to find the sun
;-----------------------------------------------------------------
;
;FindSun
;	movlf	Adc14V,VdcTar		;set 14 Vdc as solar voltage target
;	call	Up5.0
;	call	SkyScan			;scan sky and stop on first solar output >= target Vdc
;	andlw	0x01			;test w 0:1
;	skpz				;skip if sun found flag set
;	goto	Drill			;yup so drill down
;
;	call	GoAlt0			;drive down to alt 0
;
;	btfsc	CwSrch,0		;test if we just did a cc search
;	goto	Fincw			;no so adjust for a cw search
;
;ccres
;	movff	AziEnc,MovEnc
;	movff	AziEnc+1,MovEnc+1
;	movff	AziEnc+2,MovEnc+2	;setup to slew back to start
;	movlf	Cw,MDir
;	call	MoveIt			;back to azi zero
;	goto	FindSun			;try sky scan again
;
;Fincw
;	movsc	Cc,Deg120
;	movsc	Cc,Deg30		;move sc to west quadrant before restore
;	goto	ccres
;
;-----------------------------------------------------------------
; Use smaller and smaller search squares to get the max solar voltage
;-----------------------------------------------------------------
;
;Drill
;	call	DrillIt
;	movlw	Adc24V
;	subwf	SunVdc,w
;	skpc
;
;	goto	Drill
;
;-----------------------------------------------------------------------
; Finally we get to track the sun
;-----------------------------------------------------------------------

TrackSun				;nudge the motors to track max solar voltage
	bcf	Doze, 0			;reset we are dozing flag

	btfsc	FsIPort,FsI		;skip if jumper installed (align mode)
	goto	CkWest			;no, so check for end of day

	call	Dly250ms		;debounce jumper
	btfss	FsIPort,FsI		;skip if jumper not installed (track mode)
	goto	CkAlign			;goto align mode	

CkWest
	call	TWest			;test which way we are facing
	skpnz				;skip if facing east
	goto	ckEOD			;facing west so check for EOD

	call	SetWUpMd		;facing east so reset west sector timer
	goto	NotEOD			;goto handle normal tracking

ckEOD
	call	TWest			;test if facing west as we can only trigger end of day if facing west
	skpz				;skip if facing west
	goto	NotEOD			;skip end of day test

	call	TMinAlt			;test if track altitude < minimum altitude
	skpc				;skip if not < 7.5 deg
	goto	EndofDay		;less than 0 deg so time for a rest

NotEOD
	call	HandJob			;check for hand controller input
	btfss	HbZ, 0			;check if time to adjust sky point
	goto	TrackSun		;no so wait some more

	bcf	HbZ,0			;reset HbZ flag
	btfss	NHemi,0			;test which hemisphere, set = north
	goto	DoSHemi			;clear so handle southern hemisphere

DoNHemi
	call	TWest			;z = facing west
	skpz				;skip if west
	goto	TNE			;handle NE track

	call	TrackNW			;do NW tracking
	goto	TrackSun		;do it again

TNE
	call	TrackNE			;do NE tracking
	goto	TrackSun		;do it again

DoSHemi
	call	TWest			;z = facing west
	skpz				;skip if west
	goto	TSE			;handle SE track

	call	TrackSW			;do SW tracking 
	goto	TrackSun

TSE
	call	TrackSE			;do SE tracking
	goto	TrackSun

;-------------------------------------------------------------------
; End of day processing
;-------------------------------------------------------------------

EndofDay				;move to overnight stow
	bsf	Doze,0			;set we are dozing flag to stop double time downcount

	movff	AziEnc,GoEast
	movff	AziEnc+1,GoEast+1
	movff	AziEnc+2,GoEast+2 	;save current azi encoder value

	movsc	Up,Deg15
	call	GoAlt0
	movsc	Dn,Deg7.5		;drive 7.5 deg down to stop crap falling on the lens overnight

	btfsc	NHemi,0			;test which hemisphere
	goto	HomeN			;go to handle north

	movlw	Cw			;we are south, so set dawn direction as Cw 
	goto	GoHome			;go to make it happen

HomeN
	movlw	Cc			;we are north, so set dawn direction as Cc

GoHome
	movwf	MDir			;save selected motor direction
	movff	GoEast,MovEnc
	movff	GoEast+1,MovEnc+1
	movff	GoEast+2,MovEnc+2 	;set to slew to opposite of where we started 
	call	MoveIt			;slew to face equator

	movff	GoEast,MovEnc
	movff	GoEast+1,MovEnc+1
	movff	GoEast+2,MovEnc+2 	;set to slew to opposite of where we started 
	call	MoveIt			;slew to sunrise azimuth

wmorning				;with our work day done, its time to sleep & maybe to dream
	btfsc	WUpMZ,0			;test if wake up delay is zero
	goto	morning			;nope, so wake up and get to work

	call	HandJob			;is it wake up time
	andlw	0x01			;test if any switched touched
	skpnz				;yup so time to get up and go to work
	goto	wmorning		;wait for morning wakeup call	

morning
	bcf	WUpMZ,0			;clear wake up flag
	movsc	Up,Deg15		;return to vertical

	call	SkyScan			;initiate sky scan
	andlw	0x01			;test if we found the sun flag 1 = found
	skpz				;skip if we didn't
	goto	TrackSun		;go to work to earn some money

	movlf	5,WUpMd
	movlf	0,WUpMd+1		;set wake up timer to 5 minutes
	bcf	WUpMZ,0			;clear timer finished flag
	goto	wmorning		;goto wait for another sky scan

;-----------------------------------------------------------------------
; Track Adjust Table (TAT) for Adelaide (-34.9S, 138.89W)
;-----------------------------------------------------------------------

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
az0	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x021C,	0x001F,	0x0121,	0x0124,	0x0129,	0x012D,	0x0137,	0x0143,	0x0152,	0x0270,	0x0000,	0x0000,	0
	org	$+13																		
az5	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x011C,	0x031D,	0x0221,	0x0224,	0x0127,	0x022D,	0x0237,	0x0143,	0x0152,	0x0370,	0x0000,	0x0000,	0
	org	$+13																		
az10	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x051B,	0x041D,	0x0521,	0x0423,	0x0528,	0x032D,	0x0437,	0x0443,	0x0152,	0x0370,	0x0000,	0x0000,	0
	org	$+13																		
az15	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0618,	0x051A,	0x071D,	0x061E,	0x0622,	0x0625,	0x072D,	0x0630,	0x053B,	0x074E,	0x075B,	0x0000,	0x0000,	0
	org	$+13																		
az20	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x1118,	0x0819,	0x071C,	0x081F,	0x0721,	0x0825,	0x092B,	0x082E,	0x0837,	0x094E,	0x075B,	0x0000,	0x0000,	0
	org	$+13																		
az25	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0816,	0x0919,	0x0A1C,	0x091E,	0x0921,	0x0924,	0x0A29,	0x0C30,	0x0A36,	0x0A47,	0x0854,	0x0000,	0x0000,	0
	org	$+13																		
az30	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0A15,	0x0B17,	0x0B19,	0x0A1B,	0x0B1E,	0x0B20,	0x0B24,	0x0926,	0x0930,	0x0A36,	0x0D47,	0x0C4F,	0x0000,	0x0000,	0
	org	$+13																		
az35	dw	0x0000,	0x0000,	0x0000,	0x0000,	0x0E15,	0x0B18,	0x0C19,	0x0D1A,	0x0D1D,	0x0C1F,	0x0C24,	0x0C26,	0x0C2C,	0x0C36,	0x0E4E,	0x0B4B,	0x0000,	0x0000,	0
	org	$+13																		
az40	dw	0x0000,	0x0000,	0x0000,	0x0D12,	0x0D13,	0x0E14,	0x0D17,	0x0E19,	0x0D1A,	0x0E1D,	0x0C1F,	0x0D23,	0x0B2A,	0x0E36,	0x0D3A,	0x0C41,	0x0000,	0x0000,	0
	org	$+13																		
az45	dw	0x0000,	0x0000,	0x0711,	0x0E12,	0x0E13,	0x1015,	0x1017,	0x0E18,	0x0F1B,	0x0F1D,	0x111F,	0x1523,	0x0F27,	0x0C2E,	0x0E38,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az50	dw	0x0000,	0x0D0D,	0x1010,	0x0F11,	0x0F12,	0x1013,	0x1016,	0x1017,	0x0E18,	0x0F1C,	0x0F1D,	0x0B1F,	0x1024,	0x0F2E,	0x1234,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az55	dw	0x100F,	0x100F,	0x1010,	0x1110,	0x1011,	0x1114,	0x1216,	0x1015,	0x1217,	0x111A,	0x111C,	0x111C,	0x1421,	0x0B20,	0x1734,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az60	dw	0x100F,	0x100F,	0x1010,	0x1110,	0x1211,	0x1112,	0x1014,	0x1215,	0x1216,	0x1319,	0x0F18,	0x111A,	0x1321,	0x1325,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az65	dw	0x120E,	0x110E,	0x1410,	0x1110,	0x1111,	0x1312,	0x1315,	0x1214,	0x1314,	0x1316,	0x1217,	0x1119,	0x141E,	0x1023,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az70	dw	0x110E,	0x120E,	0x120F,	0x1210,	0x1310,	0x1311,	0x1312,	0x1313,	0x1113,	0x1514,	0x1516,	0x1216,	0x131A,	0x1320,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az75	dw	0x120E,	0x120E,	0x140E,	0x120F,	0x130F,	0x1310,	0x1410,	0x1511,	0x1313,	0x1611,	0x1413,	0x1214,	0x1316,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az80	dw	0x120D,	0x120E,	0x140E,	0x120E,	0x120D,	0x150E,	0x1410,	0x140F,	0x1511,	0x100E,	0x1311,	0x1613,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az85	dw	0x120E,	0x120E,	0x140E,	0x130E,	0x140E,	0x140F,	0x130E,	0x130F,	0x140F,	0x150F,	0x130F,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az90	dw	0x130D,	0x130E,	0x120D,	0x140E,	0x130D,	0x140D,	0x150E,	0x140D,	0x150D,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az95	dw	0x110D,	0x140E,	0x140D,	0x140D,	0x140D,	0x140C,	0x140C,	0x140C,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az100	dw	0x160E,	0x130D,	0x130D,	0x140D,	0x150D,	0x140C,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az105	dw	0x130D,	0x130D,	0x140C,	0x120C,	0x150D,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az110	dw	0x110D,	0x120D,	0x110C,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
	org	$+13																		
az115	dw	0x130D,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0x0000,	0
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

;-----------------------------------------------------------------------
; program end
;-----------------------------------------------------------------------

PeVer	dt	Version
PeCopy	dt	CopyRight

	end
