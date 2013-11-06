
;***********************************************************************
;                          MotorTester.ASM                             ;
;                                                                      ;
;                    SunCube Motor Test Firmware                       ;
;                                                                      ;
;    This program & the system design of the SunCube are copyright     ;
;                            Greg Watson                               ;
;                        2005 2006 2007 2008                           ;
;                                                                      ;
;                        All rights reserved                           ;
;***********************************************************************

;-----------------------------------------------------------------------
; Set up for CPU type & power on configuration
;-----------------------------------------------------------------------

	LIST P=PIC16f88,R=DEC,f=INHX32

	#include p16f88.inc

;-- Program Configuration Register 1 --

	__CONFIG    _CONFIG1,_CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_IO

;-- Program Configuration Register 2 --

	__CONFIG    _CONFIG2,_IESO_OFF & _FCMEN_OFF

;-----------------------------------------------------------------------
; Program creation date and version
;-----------------------------------------------------------------------

#define 	Version			"SunCube(tm) Motor tester Firmware Version 20081114,"
#define 	CopyRight 		"Copyright(C) Greg Watson. All rights reserved"

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
RPM	equ	6000			;motor rpm
RPS	equ	RPM/60			;revs per second
PPS	equ	PPR*RPS			;pulses per second
MtrSec	equ	3			;seconds per motor drive test
MtrEnc	equ	MtrSec*PPS		;encoder pulses needed to achieve motor drive time

;looking down, from above yoke with electronics box to left

Cw	equ	1			;moving Cw/left, so dec enc position
Cc	equ	2			;moving Cc/right, so inc enc position

;looking at yoke with electronics box in centre, SunCube pointing to the right

Up	equ	3			;moving	Up, so inc enc position
Dn	equ	4			;moving Down, so dec enc position

;-----------------------------------------------------------------------
; Flag0 bit equates
;-----------------------------------------------------------------------

THbZ	equ	0			;track timer zero flag
MRun	equ	1			;any motor running flag
Slow	equ	2			;motor too slow
Fast	equ	3			;motor too fast

;-----------------------------------------------------------------------
; Timer 1 equates
;-----------------------------------------------------------------------

tius	equ	4			;4 us per T1 count
ticks	equ	65536			;16 bits
maxtime	equ	tius*ticks		;max time from 0x0000 to 0x0000 (262,144 us)
tickval	equ	(maxtime-250000)/tius 	;value to generate T1 ints every 250ms
ticklos	equ	1			;timer ticks lost before we write the new value
t1low	equ	low(tickval+ticklos)	;preset for TMR1L
t1high	equ	high(tickval+ticklos)	;preset for TMR1H

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	Red	0			;Red led, low active
#define	RedPort	PORTA

#define	Grn	1			;Green led, low active
#define GrnPort	PORTA

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

#define	CcO	7			;rotate Cc output
#define CcOPort	PORTA

;                 76543210
#define AnalA	b'00000000'		;1=analog input
#define	DirA	b'00100000'		;0=output,1=input
#define IntA	b'00011111'		;initial port A data

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

#define	DnO	5			;rotate DOWN output
#define	DnOPort	PORTB

#define	AlI	6			;encoder pulses from the Altitude motor
#define AlIPort	PORTB

#define	AzI	7			;encoder pulses from the Azimuth motor
#define	AzIPort	PORTB

;                 76543210
#define DirBHj	b'11001111'		;0=output,1=input
#define	DirBCom	b'11000010'		;0=output,1=input
#define	IntBHj	b'00001111'		;initial port B data for hand controller
 
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
; timer loop counters
;--------------------------------

dlyxms	res	1			;W x 1ms delay loop counter
dlyms	res	1			;delay 1ms loop counter
dlymin	res	1			;minute delay

;--------------------------------
; Math variables
;--------------------------------

BB	res	3			;24 bit math input

;--------------------------------
; Pointing variables
;--------------------------------

AltI	res	1			;Altitude TAT index value
AziI	res	1			;Azimuth TAT index value
AziSky	res	3			;azimuth sky point
AltSky	res	3			;altitude sky point
AltEnc	res	3			;altitude encoder position 0 - 139,999
AziEnc	res	3			;azimuth encoder position 0 - 139,999
MoveSz	res	3			;desired encoder movement (0 - 139,999 pulses)
WUpEnc	res	3			;wake up encoder
EdgEnc	res	3			;saved encoder position for edge detection
LstMove	res	3			;saved last move size

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
ANSz	res	1			;adjusted nudge size minus over run
SvDir	res	1			;saved original direction
LstDir	res	1			;saved last direction

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
Flag0	res	1			;boolean flag byte
Flag1	res	1			;boolean flag byte
SFSR	res	1			;saved FSR
EeAdr	res	1			;EE address
HJs	res	1			;small HJ counter
NCnt	res	1			;number of "On Sun" nudge cycles

;leave NCnt as last variable

;--------------------------------
; Interrupt handler variables
;--------------------------------

	org	ramint+16-10		;start of bank insensitive ram
saveW	res	1			;save W
saveST	res	1			;save STATUS
saveFSR	res	1			;save FSR
savePCL	res	1			;save PCLATH
tempi	res	1			;used in int handler
AltC	res	1			;Azimuth track correction
AziC	res	1			;Altitude track correction
AA	res	3			;24 bit math input
B0Avil	equ	saveW-NCnt-1		;amount of ram left in bank 0

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------

nudgesc	macro	dir			;nudge sc in dir direction
	movlf	dir,MDir		;set direction
	call	Nudge			;move sc
	endm

;----------------------------------------

call0	macro	proc			;call a procedure in bank 1 from bank 0
	bcf	PCLATH,3		;select program bank 0
	call	proc			;call procedure there
	bsf	PCLATH,3		;select program bank 1
	endm

;----------------------------------------

call1	macro	proc			;call a procedure in bank 1 from bank 0
	bsf	PCLATH,3		;select program bank 1
	call	proc			;call procedure there
	bcf	PCLATH,3		;select program bank 0
	endm

;----------------------------------------

SndL	macro	lit			;send literal

	movlw	lit			;load lit to send
	call1	Send8n			;send it
	movlw	','			;load deliminiter
	call1	Send8n			;send it as well
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
	movlf	(lit/2)-1,dlyms		;set up delay lit in w
	call	Dlyus			;now do the delay
	endm

;----------------------------------------

dlylms	macro	lit			;delay for lit ms
	movlw	lit			;set up delay lit in w
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
	movlf	low((deg)/256),enc+1
	movlf	low((deg)/65536),enc+2
	endm

;--------------------------------

movsc	macro	dir,deg
	setdeg	deg,MoveSz		;set movement size
	movlf	dir,MDir		;set movement direction
	call	MoveSc			;make it happen
	endm

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
;     Updating Azimuth & Altitude encoders & MoveSz drive length from motor encoder pulses
;     Turning the motor off when MoveSz goes zero and resetting MRun flag
; DecEnc, IncEnc & DecWUpD are called, so we will use another stack position.
;   This means we must limit the main code excecution to no more than 6 nested
;   calls or we will underflow / wrap the stack and lose control
;-----------------------------------------------------------------------

	org	0x0004			;interrupt entry point <<<<<<<<<<<<<<<<<

	movwf	saveW			;save w
	swapf	STATUS,w		;load status into w but in reversed lsb & msb order
	movwf	saveST			;save status flags
	clrf	STATUS			;clear status and select register bank 0
	movff	PCLATH,savePCL		;save PCLATH (rb0,1,2,3)(we may have been in program bank 1)
	clrf	PCLATH			;clear it to program bank 0

;-- Handle encorder change / port B change interrupt --

	movfw	PORTB			;read state of encoder pulses

	btfss	INTCON,RBIE		;is the encoder interrupt enabled
	goto	intfin			;no so get out of here
	btfss	INTCON,RBIF		;is it an encoder interrupt?
	goto	intfin			;no so get out of here

	andwf	EncSel,w		;isol encoder bit to test
	movwf	tempi			;save it for a moment
	movfw	EncLst			;load last state of encoder pulses
	andwf	EncSel,w		;isol encoder bit to test
	subwf	tempi,w			;test if the proper encoder pulse changed state
	skpnz				;yes it is a encoder change from the motor being driven
	goto	errpbc			;no so get out of here

	movfw	MoveSz			;load lsb
	iorwf	MoveSz+1,w		;or in lsb+1
	iorwf	MoveSz+2,w		;or in lsb+2 & test if MoveSz is zero
	skpnz				;is movement finished?
	goto	mfin			;no so go to dec move count

	call	DecEnc			;dec enc pulses to move
	goto	encfin			;no, so update encoder

mfin
	bcf	Flag0,MRun		;yes so flag move completed
	call	MtrOff			;turn all motor drives off

encfin
	movff	PORTB,EncLst		;save current encoder pulse state

errpbc
	bcf	INTCON,RBIF		;clear port B change flag

;-- end specific interrupt handler code --

intfin
	movff	savePCL,PCLATH		;restore PCLATH
	swapf	saveST,w		;load saved status flags
	movwf	STATUS			;restore status flags
	swapf	saveW,f			;swap nibbles to prepare for next nibble swap into w
	swapf	saveW,w			;restore w without effecting status flags
	retfie				;go back to where we came from with interrupts enabled	

;----------------------------------------
; Delay timer procedures
;----------------------------------------

Dlyus					;entry for dlylus macro
	nop				;
	decfsz	dlyms,f			;dec ms count & test for zero
	goto	Dlyus			;no - so do it again
	nop				;
	return				;ius exit

;----------------------------------------

Dlywms					;delay for w * ms

	movwf	dlyxms			;save ms loop count

doxms
	movlf	(2000-8)/8,dlyms	;load delay 1ms constant

d1ms
	nop				;1 op, 0.5 us
	goto	$+1			;2 ops, 1 us
	goto	$+1			;2 ops, 1 us
	decfsz	dlyms,f			;dec ms count & test for zero
	goto	d1ms			;no - so do it again

	goto	$+1			;2 ops, 1 us
	decfsz	dlyxms,f		;dec ms count & test for zero
	goto	doxms			;no - so do it again
	return				;yes - so exit

;---------------------------------------

Dly1sec

	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	dlylms	250			;delay for 250ms
	return

;----------------------------------------
; Shaft encoder procedures
;----------------------------------------

DecEnc					;dec encoder count

	movlw	1			;seed to test for underflow (nc) on subtract
	subwf	MoveSz,f		;dec lsb
	skpnc				;test for nc / underflow
	return				;none so exit

	subwf	MoveSz+1,f		;dec lsb+1
	skpnc				;test for nc / underflow
	return				;none so exit

	decf	MoveSz+2,f		;simple dec of lsb+2 will do here
	return

;----------------------------------------

MoveSc					;move to new sky point

	bcf	INTCON,GIE		;disable ints
	movff	PORTA,temp		;load state of port A
	bsf	temp,En2		;
	bsf	temp,En3		;
	bsf	temp,En4		;turn on encoder power bits
	movff	temp,PORTA		;write results back to port A
	dlylms	5			;wait for encoders to power up & stabilize

	movlw	Up
	subwf	MDir,w			;check if moving up
	skpz
	goto	ckdn			;nope,so check if moving down

	movlf	AltSel,EncSel		;use alt encoder
	bsf	UpOPort,UpO		;turn on Up drive
	goto	wmtroff

ckdn
	movlw	Dn
	subwf	MDir,w			;check if moving down
	skpz
	goto	ckcc			;nope,so check if moving ccw

	movlf	AltSel,EncSel		;use alt encoder
	bsf	DnOPort,DnO		;turn on Down drive
	goto	wmtroff

ckcc
	movlw	Cc
	subwf	MDir,w			;check if moving ccw
	skpz
	goto	ckcw			;nope,so check if moving cw

	movlf	AziSel,EncSel		;use azi encoder
	bsf	CcOPort,CcO		;turn on Cc drive
	goto	wmtroff

ckcw
	movlw	Cw
	subwf	MDir,w			;check if moving cw
	skpz
	return				;we should never get here

	movlf	AziSel,EncSel		;use azi encoder
	bsf	CwOPort,CwO		;turn on Cw drive

wmtroff
	dlylus	50			;delay 20 us for drive lines to stabilize
	movff	PORTB,EncLst		;save current encoder states
	bcf	INTCON,RBIF		;clear port b change flag
	bsf	INTCON,RBIE		;enable encoder pulse interrupts
	bsf	Flag0,MRun		;flag we have a motor running
	bsf	INTCON,GIE		;enable ints
	dlylms	5			;delay 5ms for stability
	return

;----------------------------------------

MtrOff

	bcf	UpOPort,UpO		;
	dlylus	50
	bcf	DnOPort,DnO		;
	dlylus	50
	bcf	CwOPort,CwO		;
	dlylus	50
	bcf	CcOPort,CcO		;turn off all motors
	dlylus	50
	return

;----------------------------------------
; Hand controller
;----------------------------------------

HandJob

	movfw	DnIPort			;read hand controller switches
	andlw	SwAnd			;isolate all switch bits, 1 = off / open
	sublw	SwAnd			;test if any swithes on, 0 = on / grounded
	skpz				;skip if no switches are on
	goto	ckidn			;switch/s are on so find out which one
	clrz				;no switches on so exit z clear
	return

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
	clrz
	return				;no so just exit

	movlf	Cc,MDir			;yes so set direction

FinHJ					;common HJ stuff
	setdeg	MtrEnc,MoveSz		;motor drive length for desired testing seconds
	call	MoveSc			;do the selected movement
	setz 
	return				;moved sc so exit with zero set

;----------------------------------------

WSwOff					;wait for all switches to be off

	dlylms	250			;debounce switch off
	movfw	CcIPort			;read switch port
	andlw	SwAnd			;isol switch bits
	sublw	SwAnd			;all switches off = 1s?
	skpz				;skip if all switches off
	goto	WSwOff			;no so wait some more

	dlylms	250			;debounce switch off
	movfw	CcIPort			;read switch port
	andlw	SwAnd			;isol switch bits
	sublw	SwAnd			;all switches off = 1s?
	skpz				;skip if all switches off
	goto	WSwOff			;no so wait some more
	return

;----------------------------------------

MSlow
	bcf	RedPort,Red		;turn on the Red led
	dlylms	250
	bsf	RedPort,Red		;turn off the Red led
	dlylms	250
	bcf	RedPort,Red		;turn on the Red led
	dlylms	250
	bsf	RedPort,Red		;turn off the Red led
	dlylms	250
	return

;----------------------------------------

MFast
	bcf	RedPort,Red		;turn on the Red led
	dlylms	125
	bsf	RedPort,Red		;turn off the Red led
	dlylms	125
	bcf	RedPort,Red		;turn on the Red led
	dlylms	125
	bsf	RedPort,Red		;turn off the Red led
	dlylms	125
	bcf	RedPort,Red		;turn on the Red led
	dlylms	125
	bsf	RedPort,Red		;turn off the Red led
	dlylms	125
	bcf	RedPort,Red		;turn on the Red led
	dlylms	125
	bsf	RedPort,Red		;turn off the Red led
	dlylms	125
	return

;----------------------------------------
; Initialization procedures
;----------------------------------------

WDToff					;set up watch dog timer

	movlw	0x16			;set WDT to 2.097 sec timeout & turn it off

finwdt
	bsf	STATUS,RP1		;select bank 2
	movwf	WDTCON			;write value to WDTCON (rb2)
	bcf	STATUS,RP1		;back to bank 0
	return

;----------------------------------------

SetUpIo					;setup the I/O ports

	movlf	IntA,PORTA		;set initial port A state
	bsf	STATUS,RP0		;select bank 1
	movlf	0x72,OSCCON		;select intrc 8 Mhz (rb1)
	movlf	DirA,TRISA		;initialize port A data direction register (rb1)
	movlf	AnalA,ANSEL		;select analog input channels (rb1)
	bcf	STATUS,RP0		;select bank 0

	movlf	IntBHj,PORTB		;set initial port B state
	bsf	STATUS,RP0		;select bank 1
	movlf	DirBHj,TRISB		;initialize port B data direction register (rb1)
	movlf	0x07,OPTION_REG		;enable global weak pullups, T0 clk to cpu & PSA to T0 w/ 256 prescaler (rb1,3)
	bcf	STATUS,RP0		;select bank 0
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

;-----------------------------------------------------------------------
;####### Start of code (Main Program). #######
;-----------------------------------------------------------------------

Main					;start of code. Power on & WDT jumps to here

	call	SetUpIo			;setup I/O ports & clock
	call	ClearRam		;clear ram
	call	WDToff			;turn off the watch dog timer

	bcf	GrnPort,Grn		;turn on Green led
	call	Dly1sec
	bsf	GrnPort,Grn		;turn off Green led

	call	MSlow			;show slow blink rate
	call	MSlow			;
	call	MFast			;show fast blink rate
	call	MFast			;

nxtck
	btfsc	Flag0,Slow
	call	MSlow			;show we had a slow motor
	btfsc	Flag0,Fast
	call	MFast			;show we had a fast motor

	call	HandJob			;allow hand controller to move test motor
	skpz				;if zero then we have a running motor
	goto	nxtck			;no so wait for something to do

swon
	bcf	Flag0,Slow		;
	bcf	Flag0,Fast		;clear all motor speed flag bits
	bcf	RedPort,Red		;turn on the Red led to show we have started
	dlylus	50
	bsf	GrnPort,Grn		;turn off the Green led to show we have started

	call	Dly1sec			;
	call	Dly1sec			;
	dlylms	250			;delay for 2.25 seconds

	btfss	Flag0,MRun		;test if motor still running
	goto	fastm			;no so handle motor too quick	

	call	Dly1sec
	dlylms	250			;
	dlylms	250			;delay for a further 1.5 sec

	btfsc	Flag0,MRun		;test if motor still running
	goto	slowm			;yes so handle motor too slow

	bsf	RedPort,Red		;turn off Red led
	dlylus	50
	bcf	GrnPort,Grn		;turn on Green led
	goto	nxtck

fastm
	bsf	Flag0,Fast		;flag the motor is too fast
	goto	mstop

slowm
	bsf	Flag0,Slow		;flag the motor is too slow

mstop
;	call	MtrOff			;turn off all motors
;	bcf	Flag0,MRun		;turn off motor running flag

;	bcf	INTCON,RBIE		;disable encoder pulse interrupts

;	movff	PORTA,temp		;load state of port A 
;	bcf	temp,En2		;
;	bcf	temp,En3		;
;	bcf	temp,En4		;turn off 3 encoder power bits
;	movff	temp,PORTA		;write result back to port A

;	dlylms	5			;wait for encoders to turn off

	goto	nxtck

;----------------------------------------
; End Program code
;----------------------------------------
 	
	end