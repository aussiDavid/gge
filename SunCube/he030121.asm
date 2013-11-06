;***********************************************************************
;                            HERMES.ASM                                ;
;                                                                      ;
;      This pogram & the system design of Hermes is copyright          ;
;                                                                      ;
;                        Hermes Systems P/L                            ;
;                              and                                     ;
;                          Greg Watson                                 ;
;                           2002, 2003                                 ;
;                                                                      ;
;                      All rights reserved                             ;
;***********************************************************************

;-----------------------------------------------------------------------
; Set up for CPU type & power on configuration
;-----------------------------------------------------------------------

	LIST P=16C770, R=DEC, f=INHX32

	#include p16c770.inc

	__CONFIG _CP_OFF & _BODEN_OFF & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT

;-----------------------------------------------------------------------
; Meter operational parameters
;-----------------------------------------------------------------------

;  	rev /	 wh	pulses	   wh     Accuracy
;        kwh            / tick   / tick      +- %
;-------------------------------------------------
;	 67.5  14.81	  5	   74	    -0.1%
;	187.5	5.33	  3	   16	     0.0%
;       250.0   4.0       4        16        0.0%
;       266.6   3.75      4        15        0.0%
;       400.0   2.5       6        15        0.0%
;       800.0   1.25     12        15        0.0%

calcon	equ	4	;initial disk revs for min / max calibration

;-----------------------------------------------------------------------
; Constants
;-----------------------------------------------------------------------

tamper	equ	7		;15:1 tamper during interval
pwroff	equ	6		;14:1 power lost during interval
pwron	equ	5		;13:1 power restored during interval

				;12:13 = tick count from disc rotation
				;max = 8,911 ticks per 30 minutes

cday	equ	06		;current day
cmonth	equ	03		;current month
chi	equ	20		;current year high byte
clo	equ	03		;current year low byte

ram0	equ	0x20		;start of bank 0 ram
ramint	equ	0X80		;end of bank insensitive ram + 1

cpdcon	equ	4		;characters to send between disk edge checks
dptcon	equ	4		;number of disk checks needed to trigger a valid black flag
pptcon	equ	6		;black band pulses per interval tick, set for 400 rev / kwh meter
wptcon	equ	15		;wh per interval tick, set for 400 rev / kwh meter
mpicon	equ	30		;minutes per interval
spvcon	equ	15		;seconds per VPMs, 0 = disable
dctcon	equ	(400000/3052)	;4ms disc edge check time (really 5ms with Adc delay)
dctmsk	equ	0xc0		;TMR1l don't care bit mask
ms1con	equ	(100000/3052)	;1ms delay value
cwcon	equ	15		;number of seconds for current watt hour buffer

vpmflg	equ	7		;do VPM flag
ivlflg	equ	6		;new interval flag
ledflg	equ	5		;visual led blink on black flag enable bit
ecoflg	equ	4		;echo back set / clear comm command results
oqflg	equ	3		;optical quality monitor flag
setflg	equ	2		;allow set / clear commands

mbytes	equ	4		;meter number xx xx xx xx in packed bcd
kwbytes	equ	4		;meter kwh xx xx x.x xx in packed bcd
epbsz	equ	6		;max size of E^2 multiple read / write buffer

jtbls	equ	0x20		;first command " " for jump table

WeCmd	equ	b'10100000'	;E^2 write command
ReCmd	equ	b'10100001'	;E^2 read command
EpRetry	equ	255		;number of write command bad ack retries

cr	equ	0x0d		;carriage return
lf	equ	0x0a		;line feed
enq	equ	'?'		;initial wake up command
wak	equ	' '		;wake up character

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	Led	0		;visual led bit (test mode)
#define	LedPort	PORTA		;visual led port

#define	Opa	1		;Ir opto input bit (Analogue)
#define OpaPort	PORTA		;Ir opto input port

#define	Ir1	2		;Ir led bit, current level 1
#define	Ir1Port	PORTA		;Ir led port

#define	Ir2	3		;Ir led bit, current level 2
#define	Ir2Port	PORTA		;Ir led port

#define	Td	3		;Ir AS1284 transmit data line
#define	TdPort	PORTA		;Ir AS1284 transmit data port

#define	A4	4		;A4 bit (OC driver)
#define	A4Port	PORTA		;A4 port

#define A5	5		;A5 bit (unused / input only)
#define	A5Port	PORTA		;A5 port

#define	Op1	6		;Ir opto load resistor level 1
#define	Op1Port	PORTA		;Ir opto port

#define	Epp	7		;E^2 power bit
#define	EppPort	PORTA		;E^2 power bit port

;                 76543210
#define AnalA	b'00000010'	;1=analog input

#define	DirA	b'00110010'	;0=output, 1=input
#define IntA	b'00000101'	;initial port A data

;-----------------------------------------------------------------------
; Port B defines
;-----------------------------------------------------------------------

#define	ERd	0		;Enable the opto pullup resistor
#define	ERdPort	PORTB		;ERd bit port

#define	Rd	1		;Ir AS1284 comms receive data line bit - uses internal pullup
#define RdPort	PORTB		;Ir AS1284 comms receive data port

#define	Epc	2		;E^2 clock bit
#define	EpcPort	PORTB		;E^2 clock port

#define Opt	3		;Ir opto input bit (ttl level)
#define OptPort	PORTB		;Ir opto input port

#define	Epd	4		;E^2 data bit - uses internal pullup
#define	EpdPort	PORTB		;E^2 data port

#define	Flg	5		;Flag bit, test pulse output
#define	FlgPort	PORTB		;Flag bit port

#define	T1o	6		;T1 Osc output bit
#define	T1oPort	PORTB		;T1 Osc outout port

#define	T1i	7		;T1 Osc input bit
#define	T1iPort	PORTB		;T1 Osc input port

;                 76543210
#define DirB	b'11001010'	;0=output, 1=input
#define	IntB	b'11011110'	;initial port B data

#define	PbPu	b'00010000'	;weak pullups for port B

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------


relall	macro	addr, lgn	;read E^2 from literal address and literal length

	movlw	high addr	;load high E^2 address
	movwf	epadr		;store it
	movlw	low addr	;load low E^2 address
	movwf	epadr+1		;store it

	movlw	lgn		;load bytes to read
	movwf	eplgn		;store it

	call	RdEp		;do read of eprwb to E^2

	endm

;---------------------------------

welall	macro	addr, lgn	;write E^2 from literal address and literal length

	movlw	high addr	;load high E^2 address
	movwf	epadr		;store it
	movlw	low addr	;load low E^2 address
	movwf	epadr+1		;store it

	movlw	lgn		;load bytes to write
	movwf	eplgn		;store it

	call	WrEp		;do write of eprwb to E^2

	endm

;--------------------------------

movff	macro	regs, regd	;move register regs to resd via w

	movfw	regs		;load source register
	movwf	regd		;save in destination register

	endm

;--------------------------------

movlf	macro	lit, reg	;load literal into register via w

	movlw	lit		;load literal into w
	movwf	reg		;store w into reg

	endm

;--------------------------------

SetEpW	macro

	bsf	STATUS, RP0	;select bank 1
	bcf	TRISB, Epd	;set E^2 data bit to output
	bcf	STATUS, RP0	;select bank 0

	endm

;--------------------------------

SetEpR	macro

	bsf	STATUS, RP0	;select bank 1
	bsf	TRISB, Epd	;set E^2 data bit to input
	bcf	STATUS, RP0	;select bank 0

	endm

;--------------------------------

SelMsg 	macro msgbeg, msgend

	movlw	high (msgbeg)
	movwf	pgadr		;load pgadr ms byte with address of first location

	movlw	low (msgbeg)
	movwf	pgadr+1		;load pgadr ls byte with address of first location

	movlw	low (msgend-msgbeg)
	movwf	pglen		;load number of packed byte pairs in string

	endm

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

;-----------------------------------------------------------------------
; E^2 storage area (262,144 bits / 32,768 bytes for 24LC256)
; Arranged as 1 x 128 byte system data block, then 340 x 96 (48 x 16 bit intervals / 1 day) byte blocks
;-----------------------------------------------------------------------

	org	0	;set to 1st page
			;
b0	res	0	;addrsss of this block

epmnum	res	4	;meter serial number

epikwh	res	4	;meter installed kwh
epmkwh	res	4	;meter total khw
epckwh	res	4	;user current kwh

epppt	res	1	;ppt for meter
epwpt	res	1	;wpt for meter
epmpi	res	1	;minutes per interval
epspv	res	1	;seconds per VPM
epflg	res	1	;flags

epoadr	res	2	;address of oldest interval
epnadr	res	2	;address of newest interval (next = epnadr + 1)
epnivl	res	2	;number of valid intervals

eptod	res	6	;current tod
epotod	res	6	;oldest interval time (hhmm) and date (ddmmyyyy)
epntod	res	6	;newest interval time (hhmm) and date (ddmmyyyy)

epmtod	res	6	;manufacture time (hhmm) and date (ddmmyyyy)
epitod	res	6	;install time (hhmm) and date (ddmmyyyy)

epatod	res	6	;last normal access time (hhmm) and date (ddmmyyyy)

;------------------------

	org	b0+64	;set to next block
			;
b1	res	0	;address of this block

eputod	res	6	;last usercode & password access time (hhmm) and date (ddmmyyyy)
epstod	res	6	;last usercode / password set time

epptod	res	6	;last peak time (hhmm) and date (ddmmyyyy)
eppwh	res	2	;last peak in wh

epttod	res	6	;last tamper time (hhmm) and date (ddmmyyyy)

epltod	res	6	;last power loss time (hhmm) and date (ddmmyyyy)
eprtod	res	6	;last power restore time (hhmm) and date (ddmmyyyy)

epbhm	res	3	;battery hours since manuf (in bcd)
epbhi	res	3	;battery hours since installation (in bcd)

ephuc	res	8	;vpm usercode (hermesys)
ephpw	res	8	;vpm password (fieldtst)

;------------------------

	org	b1+64	;set to next block
			;
b2	res	0	;address of this block

epokwh	res	kwbytes	;meter kwh at start of first interval
epnkwh	res	kwbytes	;meter kwh at end of last interval

;------------------------

	org	b2+64	;set to next block
			;
b3	res	0	;address of this block

eprln	res	1	;number in log
eprlp	res	2	;last used address
eprlog	res	60	;last 10 power restored events
eprtop	res	0	;last address of log

;------------------------

	org	b3+64	;set to next block
			;
b4	res	0	;address of this block

epaln	res	1	;number in log
epalp	res	2	;last used address
epalog	res	60	;last 10 user access events
epatop	res	0	;last address of log

;------------------------

	org	b4+64	;set to next block
			;
b5	res	0	;address of this block

epuln	res	1	;number in log
epulp	res	2	;last used address
epulog	res	60	;last 10 usercode login events
eputop	res	0	;last address of log

;------------------------

	org	b5+64	;set to next block
			;
b6	res	0	;address of this block

epsln	res	1	;number in log
epslp	res	2	;last used address
epslog	res	60	;last 10 change usercode / password events
epstop	res	0	;last address of log
		
;------------------------

	org	b6+64	;set to next block
			;
b7	res	0	;address of this block

eplln	res	1	;number in log
epllp	res	2	;last used address
epllog	res	60	;last 10 power lost events
epltop	res	0	;last address of log

;------------------------

	org	b7+64	;set to next block
			;
b8	res	0	;address of this block

eptln	res	1	;number in log
eptlp	res	2	;last used address
eptlog	res	60	;last 10 tamper events
epttop	res	0	;last address of log

;------------------------

	org	b8+64	;set to next block
			;
b9	res	0	;address of this block

epilog	res	0	;address of first interval data block

epitop	equ	32768-2	;address of last interval in log

maxivl	equ	(32768-epilog)/2

;-----------------------------------------------------------------------
; Variable ram storage area
;-----------------------------------------------------------------------

	org	ram0	;variables in ram bank 0

;------------------------
; Meter related variables
;------------------------

ppt	res	1	;revs / tick
pptcnt	res	1	;ppt downcounter

wpt	res	1	;wh / tick

cw	res	cwcon	;per second wh buffer for cwcon seconds
cwptr	res	1	;pointer to last cw buffer entry
cwpse	res	1	;pulses per second counter

ctod	res	2	;current real time pulse TOD
ltod	res	2	;last real time pulse TOD

;------------------------
; Interval variables
;------------------------

mpi	res	1	;minutes per interval
mpicnt	res	1	;minutes left in this interval
itck	res	3	;current interval tick count

;------------------------
; Comm variables
;------------------------

baud	res	1	;baud delay loop counter
bitcnt	res	1	;bits to send counter
rcvchr	res	1	;receive character bit rotate buffer
xmtchr	res	1	;send character bit rotate buffer
bcdchr	res	1	;used to pack 2 received ascii into bcd
xmtcnt	res	1	;count of send bytes, used to fire up the Adc during long sends

;------------------------
; Eeprom variables
;------------------------

eplgn	res	1	;number of bytes to read from / write to the eeprom
epbuf	res	1	;E^2 read / write bit rotation buffer
epadr	res	2	;E^2 16 bit address
eprty	res	1	;E^2 num of no ack retries counter
eprwb	res	epbsz	;E^2 multi byte read & write buffer

;------------------------
; Delay loop counters
;------------------------

todt	res	1	;tod target for ms delay procedures
dlyxms	res	1	;x 1ms delay loop counter
bkcnt	res	1	;visual led blink counter

;------------------------
; Various system variables
;------------------------

tempbcd	res	1	;used by SendBcd
temp	res	1	;used by BtoBcd, MarkIt
temp1	res	1	;used by BtoBcd
tempw	res	1	;use for temp w storage

tempnl	res	1
tempnh	res	1	;number of valid intervals

tempal	res	1
tempah	res	1	;interval address to read

flgs	res	1	;boolean flag byte

;------------------------
; Black flag & other opto processing variables
;------------------------

max	res	1	;max level from adc
min	res	1	;min level from adc

dpt	res	1	;black flag depth
dptcnt	res	1	;black flag depth down counter

blvl	res	1	;black schmidt trigger level
wlvl	res	1	;white schmidt trigger level

iron	res	1	;latest Iron value

dct	res	1	;disk edge check timer value
dctnxt	res	1	;next disk edge check time

;------------------------
; Various TOD & time variables
;------------------------

day	res	1
month	res	1
yearhi	res	1
yearlo	res	1

hour	res	1
minute	res	1
second	res	1

dmth	res	12		;days+1 in the month array for this year

spv	res	1		;seconds between VPMs
spvcnt	res	1		;downcounter in seconds to next VPM

ramtop	res	0

ravail	equ	ramint-ramtop

;-----------------------------------------------------------------------
; Variables in bank insensitive ram
;-----------------------------------------------------------------------

	org	ramint-0	;place bank insensitive variable at top of ram

;------------------------
; Temp variables
;------------------------

;dlycnt	res	1		;bank insensitive delay counter

;------------------------
; Program memory read variables
;------------------------

;pglen	res	1		;length of string stored in program memory
;pgadr	res	2		;16 bit program memory read address
;pgd	res	2		;16 bit program memory data

;-----------------------------------------------------------------------
; Power on handler
;-----------------------------------------------------------------------

	org	0x0000		;power on reset entry point <<<<<<<<<<<<<<<

	goto	Main		;go to start of main code
	nop			;field upgrade 1
	nop			;field upgrade 2
	nop			;field upgrade 3

;-----------------------------------------------------------------------
; Interrupt handlers
;-----------------------------------------------------------------------

	org	0x0004		;interrupt entry point <<<<<<<<<<<<<<<<<

	nop			;no ints yet
	nop			;field upgrade 1
	nop			;field upgrade 2
	nop			;field upgrade 3

;-----------------------------------------------------------------------
; Jump Table for VPM Command Set (Max commands = 96, must be in one 256 byte page)
;-----------------------------------------------------------------------

DoInput				;do the jump to the VPM command in w

	andlw	0x7f		;zap bit 8 if present to stop jump outside table
	movwf	tempw		;temp save result
	movlw	jtbls		;load first jump table command (" " / 0x20)
	subwf	tempw, w	;subtract first command to make command jump index 0 relative
	skpc			;test if command >= than first command, carry = ok
	return			;no - so return

	addwf	PCL, F		;add in resultant jump index to PCL and on the next fetch we are there

	return    		;space
	return    		;!
	return    		;"
	return    		;#
	return    		;$
	return    		;%
	return    		;&
	return    		;'
	return    		;(
	return    		;)
	return    		;*
	return    		;+
	return    		;,
	return    		;-
	return    		;.
	return    		;/

	goto	GetMtr		;0
	goto	SendMtr		;1
	goto	GetPpt		;2
	goto	SendPpt		;3
	goto	GetKWH		;4
	goto	SendKWH		;5
	goto	GetTime		;6
	goto	SendTime	;7
	goto	GetDate		;8
	goto	SendDate	;9
	goto	GetKWHc		;:
	goto	SendKWHc	;;
	goto	GetDct 		;<
	goto	SendDct		;=
	goto	GetLed		;>
	goto	SendLed		;?

	goto	SendRID		;@
	goto	GetIStart	;A
	goto	GetIEnd		;B
	goto	SendWID		;C
	goto	GetSunday	;D
	goto	GetTOUP		;E
	goto	GetTOUT		;F
	goto	SendTOUP	;G
	goto	SendTOUT	;H
	goto	SendTOUKWH	;I
	goto	SendTI		;J
	goto	SendNON		;K
	goto	GetLogin	;L
	goto	SendBHM		;M
	goto	SendBHI		;N
	goto	SendBS 		;O

	goto	GetPass		;P
	return    		;Q
	return    		;R
	return    		;S
	return    		;T
	goto	GetUser		;U
	goto	GetEco 		;V
	goto	SendEco		;W
	goto	DoCal		;X
	return    		;Y
	return    		;Z
	return    		;[
	return    		;\
	return    		;]
	return    		;^
	return    		;_

	return    		;`
	goto	GetSpv		;a
	goto	SendSpv		;b
	goto	GetInt		;c
	goto	SendInt		;d
	goto	GetLvl		;e
	goto	SendLvl		;f
	goto	GetDpt		;g
	goto	SendDpt		;h
	goto	GetKWHi		;i
	goto	SendKWHi	;j
	goto	GetOQ		;k
	goto	ClrIvl 		;l
	goto	SendRev		;m
	goto	SendAdc		;n
	goto	Send15		;o

	goto	SendP		;p
	goto	ClrP  		;q
	goto	SendTpr		;r
	goto	ClrTpr 		;s
	goto	SendPL 		;t
	goto	ClrPL  		;u
	goto	SendPR		;v
	goto	ClrPR		;w
	goto	SendHS 		;x
	goto	SendMT 		;y
	goto	SendIT		;z
	goto	SendAT 		;{
	goto	SendLT 		;|
	goto	SendPT 		;}
	goto	Main   		;~
	return    		;del

;-----------------------------------------------------------------------
; Time Procedures
;-----------------------------------------------------------------------

CkTod				;update TOD if needed

	bcf	TMR1H, 7	;clear TMR1H 7:1

	movf	spv, f		;load spv
	skpnz			;test if zero
	goto	dosec		;yes so skip vpm output stuff

	decfsz	spvcnt,f	;dec seconds to next VPM & test if zero
	goto	dosec		;no - so goto do second processing

	bsf	flgs, vpmflg	;yes - so set do vpm flag true
	movfw	spv		;load seconds per Vpms
	movwf	spvcnt		;store seconds to next vpm

dosec
	incf	second, f	;inc second counter
	movlw	60		;load max second + 1 (0 - 59)
	subwf	second, w	;sub and put result in W
	skpz			;skip next op if second = 60
	return			;no - so go back to where we were

	clrf	second		;yes - so clear second

	decfsz	mpicnt, f	;dec minutes in interval & test if zero
	goto	domin		;no - so goto do minute processing

	bsf	flgs, ivlflg	;yes - so set do new ivl flag true
	movfw	mpi		;load minutes per interval
	movwf	mpicnt		;store minutes until next interval

domin
	call	SaveTOD		;save TOD to E^2

	incf	minute, f	;now inc minute count
	movlw	60		;load max minute + 1 (0 - 59)
	subwf	minute, w		;sub and put result in w
	skpz			;skip next op if minute = 60
	return			;no - so go back to where we came from

	clrf	minute		;yes - so clear minute

	incf	hour, f		;now inc hour count
	movlw	24		;load max hour + 1 (0 - 23)
	subwf	hour, w		;sub and put result in w
	skpz			;skip next op if hour = 24
	return			;no - so go back to where we came from

	clrf	hour		;yes - so clear hour

	incf	day, f		;now inc day count
	movfw	month		;load month (1 - 12)
	addlw	dmth-1		;add days in month array base address
	movwf	FSR		;store result in indirect addressing register
	movfw	INDF		;load days + 1 in month into w
	subwf	day, w		;sub and put result in w
	skpz			;skip next op if day = 1 + max in month
	return			;no - so go back to where we came from

	clrf	day		;yes - so clear day
	incf	day, f		;inc start day to 1

	incf	month, f	;now inc month count
	movlw	13		;load max month + 1 (1 - 12)
	subwf	month, w	;sub and put result in w
	skpz			;skip next op if month = 13
	return			;no - so go back to where we came from

	clrf	month		;yes - so clear month
	incf	month, f	;inc month to start from 1

	incf	yearlo, f	;inc year low
	movlw	100		;load max year low + 1 (0 - 99)
	subwf	yearlo, w	;sub and put result in w
	skpz			;skip next op if yearlo = 100
	goto	doleap		;no - so go do leap year adjust

	clrf	yearlo		;yes - so clear yearlo
	incf	yearhi, f	;inc to next century (like this code will EVER be executed!) 

doleap
	movlw	29+1		;assume it is a leap year (yearlo mod 4 = 0)
	btfss	yearlo, 0	;is bit 0 zero?
	movlw	28+1		;no - so it is not a leap year
	btfss	yearlo, 1	;is bit 1 zero
	movlw	28+1		;no - so it is not a leap year
	movwf	dmth+1		;store days in Feb for this year

	return

;--------------------------------

DoPTOD				;record current pulse TOD

	movfw	ctod		;load last tod msb
	movwf	ltod		;save it
	movfw	ctod+1		;load last tod LSB
	movwf	ltod+1		;save it

	movfw	TMR1H		;load real time TOD hi
	movwf	ctod		;save it
	movfw	TMR1L		;load real time TOD low
	movwf	ctod+1		;save it

	return

;--------------------------------

LoadTOD				;load eprwb with time and date

	movfw	hour
	movwf	eprwb		;load hh
	movfw	minute
	movwf	eprwb+1		;load mm

	movfw	day
	movwf	eprwb+2		;load dd
	movfw	month
	movwf	eprwb+3		;load mm
	movfw	yearhi
	movwf	eprwb+4		;load yyhi
	movfw	yearlo
	movwf	eprwb+5		;load yylo

	return

;--------------------------------

SaveTOD				;save TOD to E^2

	call	LoadTOD
	welall	eptod, 6	;store tod in E^2

	return

;--------------------------------

SaveEp				;save operational parameters to E^2

	call	SaveTOD		;save current time & date

	movfw	mpi
	movwf	eprwb		;save mpi
	welall	epmpi, 1

	movfw	ppt
	movwf	eprwb		;save ppt
	welall	epppt, 1

	movfw	wpt
	movwf	eprwb		;save wpt
	welall	epwpt, 1

	movfw	spv
	movwf	eprwb		;save spv
	welall	epspv, 1

	movfw	flgs
	movwf	eprwb		;save flags
	welall	epflg, 1

	return

;--------------------------------

RestEp				;restore parameters from E^2

	relall	eptod, 6	;load last TOD from E^2

	movfw	eprwb
	movwf	hour
	movfw	eprwb+1
	movwf	minute		;load time from E^2

	movfw	eprwb+2
	movwf	day
	movfw	eprwb+3
	movwf	month
	movfw	eprwb+4
	movwf	yearhi
	movfw	eprwb+5
	movwf	yearlo		;restore TOD from E^2

	relall	epmpi, 1
	movfw	eprwb
	movwf	mpi		;restore mpi
	movwf	mpicnt

	relall	epppt, 1
	movfw	eprwb
	movwf	ppt		;restore ppt
	movwf	pptcnt

	relall	epwpt, 1
	movfw	eprwb
	movwf	wpt		;restore wpt

	relall	epspv, 1
	movfw	eprwb
	movwf	spv		;restore spv
	movwf	spvcnt

	relall	epflg, 1
	movfw	eprwb
	movwf	flgs		;restore flags

	bcf	flgs, oqflg
	bcf	flgs, vpmflg
	bcf	flgs, ivlflg	;reset these flags

	bsf	flgs, setflg	;allow set & clear commands to work

	return

;-----------------------------------------------------------------------
; Interval procedures
;-----------------------------------------------------------------------

ClrIvl				;clear interval associated variables

	movfw	ppt		;store pulses / tick
	movwf	pptcnt		;initialize downcounter

	movfw	mpi		;store minutes per interval
	movwf	mpicnt		;initialize downcounter

	clrf	itck
	clrf	itck+1
	clrf	itck+2		;clear current interval tick count

	movlw	high (epilog-2)
	movwf	eprwb
	movlw	low (epilog-2)
	movwf	eprwb+1		;load address -2 of newest interval

	welall	epnadr, 2	;set E^2 address of newest interval


	movlw	high epilog
	movwf	eprwb
	movlw	low epilog
	movwf	eprwb+1		;load address of oldest interval

	welall	epoadr, 2	;set E^2 address of oldest interval

	clrf	eprwb		;clear msb
	clrf	eprwb+1		;clear lsb

	welall	epnivl, 2	;clear number of intervals

	call	LoadTOD
	welall	epotod, 6	;store current TOD as oldest time stamp
	welall	epntod, 6	;store current TOD as newest time stamp

	relall	epmkwh, kwbytes	;load meter total KWH
	welall	epokwh, kwbytes	;save as oldest interval start KWH
	welall	epnkwh, kwbytes	;save as newest interval end KWH

	btfsc	flgs, ecoflg	;skip if no echo
	call	SendNON		;send number of intervals, oldest & newest addresses

	return

;--------------------------------

CnvTck				;convert 12 34 56 to 23 45

	movlw	0x0f
	andwf	itck, f		;leave as x2
	swapf	itck, f		;leave as 2x

	swapf	itck+1, w	;leave as 43
	movwf	temp		;save as 43
	movwf	temp1		;save as 43

	movlw	0xf0
	andwf	itck+2, f	;leave as 5x
	swapf	itck+2, f	;leave as x5

	movlw	0xf0
	andwf	temp, f		;leave as 4x

	movlw	0x0f
	andwf	temp1, f	;leave as x3

	movfw	temp		;load 4x
	iorwf	itck+2, w	;orin x5
	movwf	itck+1		;move to itck+1

	movfw	temp1		;load x3
	iorwf	itck, f		;orin 2x

	return

;--------------------------------

DoIvl				;do interval stuff

	bcf	flgs, ivlflg	;clear do interval flag

	relall	epnadr, 2	;load last interval address

	incf	eprwb+1, f	;inc lsb
	skpnz			;test if overflow
	incf	eprwb, f	;inc msb

	incf	eprwb+1, f	;inc lsb
	skpnz			;test if overflow
	incf	eprwb, f	;inc msb

	welall	epnadr, 2	;store last interval address + 2

	movfw	eprwb		;load msb
	movwf	epadr		;save msb
	movfw	eprwb+1		;load lsb
	movwf	epadr+1		;save lsb

	movlw	2
	movwf	eplgn		;set write length to 2 bytes

	call	CnvTck		;convert 6 digit bcd tick to 4 bcd digits

	movfw	itck
	movwf	eprwb		;load ms byte to write first
	movfw	itck+1
	movwf	eprwb+1		;load ls byte to write last

	call	WrEp		;write the 16 bit interval data to the E^2

	clrf	itck
	clrf	itck+1
	clrf	itck+2		;clear ticks per interval & interval status flags

	relall	epnivl, 2	;load number of inuse intervals

	incf	eprwb+1, f	;inc lsb
	skpnz			;test if overflow
	incf	eprwb, f	;inc msb

	welall	epnivl, 2	;store number of inuse intervals + 1

	relall	epmkwh, kwbytes	;load meter total KWH
	welall	epnkwh, kwbytes	;save as newest interval end KWH

	call	LoadTOD		;load TOD
	welall	epntod, 6	;store hhmmddmmyyyy for newest interval

	return

;--------------------------------

DoPpt				;advance tick counter and inc interval count if required

	decfsz	pptcnt, f	;dec pulses per tick
	return			;return if not zero

	movfw	ppt		;load ppt
	movwf	pptcnt		;reset pptcnt

	call	IncTck		;inc WH for this interval
	call	IncMKWH		;inc total KWH
	call	IncCKWH		;inc current KWH

	return

;--------------------------------

IncTck				;inc wh in this intervals tick

	movfw	itck+2		;load digits 5 & 6 of interval WH
	call	BcdtoB		;convert into binary
	addwf	wpt, w		;add in wh / tick
	movwf	tempw		;temp save
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	t34		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	itck+2		;store back
	return

t34
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	itck+2		;store it back

	movfw	itck+1		;load digits 3 & 4 of interval WH
	call	BcdtoB		;convert into binary
	movwf	tempw		;temp save
	incf	tempw, f	;inc in carry
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	t12		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	itck+1		;store back
	return

t12
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	itck+1		;store it back

	movfw	itck		;load digits 1 & 2 of interval WH
	call	BcdtoB		;convert into binary
	movwf	tempw		;temp save
	incf	tempw, f	;inc in carry
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	tfin		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	itck		;store back
	return

tfin
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	itck		;store it back

	return

;--------------------------------

IncPwr				;common 8 bcd digit wpt add procedure

	movfw	eprwb+3		;load digits 7 & 8 of total KWH
	call	BcdtoB		;convert into binary
	addwf	wpt, w		;add in wh / tick
	movwf	tempw		;temp save
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	c34		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	eprwb+3		;store back
	return

c34
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	eprwb+3		;store it back

	movfw	eprwb+2		;load digits 5 & 6 of total KWH
	call	BcdtoB		;convert into binary
	movwf	tempw		;temp save
	incf	tempw, f	;inc in carry
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	c56		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	eprwb+2		;store back
	return

c56
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	eprwb+2		;store it back

	movfw	eprwb+1		;load digits 3 & 4 of total KWH
	call	BcdtoB		;convert into binary
	movwf	tempw		;temp save
	incf	tempw, f	;inc in carry
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	c78		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	eprwb+1		;store back
	return

c78
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	eprwb+1		;store it back

	movfw	eprwb		;load digits 1 & 2 of total KWH
	call	BcdtoB		;convert into binary
	movwf	tempw		;temp save
	incf	tempw, f	;inc in carry
	movlw	100
	subwf	tempw, w	;test result
	skpnc			;skip if <= 99
	goto	cfin		;no - so goto inc next pair

	movfw	tempw		;load temp result
	call	BtoBcd		;convert to packed Bcd
	movwf	eprwb		;store back
	return

cfin
	movlw	100		;load 100
	subwf	tempw, w	;subtract 100 from result
	call	BtoBcd		;convert into packed Bcd
	movwf	eprwb		;store it back

	return

;--------------------------------

IncMKWH				;inc meters KWH by wpt

	relall	epmkwh, kwbytes	;read data from E^2
	call	IncPwr		;add wpt to current KWH
	welall	epmkwh, kwbytes	;write data to E^2

	return

;--------------------------------

IncCKWH				;inc current KWH by wpt

	relall	epckwh, kwbytes	;read data from E^2
	call	IncPwr		;add wpt to total KWH
	welall	epckwh, kwbytes	;write data to E^2

	return

;-----------------------------------------------------------------------
; Delay procedures
;-----------------------------------------------------------------------

Delay1ms			;delay for 1 ms

	movlw	ms1con		;load 1ms delay constant

delayms
	addwf	TMR1L, w	;add it to current TOD
	movwf	todt		;setup TOD future target

dodms
	movfw	TMR1L		;read real time clock
	subwf	todt, w		;test tod = target
	skpz
	goto	dodms		;no - so go do it again

	return			;yes - so exit

;--------------------------------

Delay100ms			;delay for 100 ms

	movlw	100		;load w with loop count for 100ms delay

;--------------------------------

Delaywms			;delay for w * ms

	movwf	dlyxms		;save ms loop count

doxms
	call	Delay1ms	;delay for 1 ms
	decfsz	dlyxms, f	;dec ms count & test for zero
	goto	doxms		;no - so do it again

	return			;yes - so exit

;-----------------------------------------------------------------------
; E^2 rom procedures
;-----------------------------------------------------------------------

Wr8ep				;write the 8 bits in w to the E^2

	SetEpW			;set E^2 data bit to output

	movwf	epbuf		;store byte to write in w into bit rotation buffer

	movlw	8
	movwf	bitcnt		;save bits to send

wr8agn
	bsf	EpdPort, Epd	;set data line high
	rlf	epbuf, F	;rotate left through carry (msb first output)
	skpc			;skip if carry set
	bcf	EpdPort, Epd	;carry not set so reset data line

	nop
	nop			;delay 4us for data setup time

	bsf	EpcPort, Epc	;set clock high

	nop
	nop			;delay 4us for min clock high time

	bcf	EpcPort, Epc	;set clock low
	decfsz	bitcnt, f	;dec bits to send counter
	goto	wr8agn		;not zero so more bits to send

	return

;--------------------------------

Rd8ep				;read 8 bits from the E^2 into w

	SetEpR			;set E^2 data bit to input with internal pullup

	movlw	8
	movwf	bitcnt		;save bits to send

rd8agn

	nop
	nop			;delay 5us for data setup time

	bsf	EpcPort, Epc	;set clock high

	nop
	nop			;delay 5us for min clock high time

	setc			;set carry
	btfss	EpdPort, Epd	;test E^2 data high
	clrc			;no - so clear carry
	rlf	epbuf, F	;rotate left from carry

	bcf	EpcPort, Epc	;set clock low

	decfsz	bitcnt, f	;dec bits to send counter
	goto	rd8agn		;not zero so more bits to send

	movfw	epbuf		;load received byte into w

	return

;--------------------------------

DlyEpW				;delay until the E^2 write has completed

	call	CkEpW		;check status of E^2
	skpnc			;skip if idle (carry = 0)
	goto	DlyEpW		;carry set - so E^2 still busy with write

	call	EpOff		;turn E^2 off after write finished

	return

;--------------------------------

CkEpW				;check to see if we can turn off the power to the E^2

	clrc			;clear carry (assume E^2 powered off)

	btfss	EppPort, Epp	;check if E^2 powered on
	return			;no - so return

	call	EpStart		;send buss start to signal command byte on the way

	movlw	WeCmd		;load write command
	call	Wr8ep		;send write command to the E^2
	call	Rack		;read ack from E^2
	call	EpStop		;set I^2 buss idle

	return			;return with carry = E^2 busy, nc = E^2 idle

;--------------------------------

IncEpAdr			;inc E^2's 16 bit address

	incf	epadr+1, f	;inc lsb of address
	skpnz			;if result <> 0, skip next op
	incf	epadr, f	;inc msb

	return

;--------------------------------

EpOn				;turn E^2 on and setup clock & data lines to idle state

	bsf	EpcPort, Epc	;set clock bit high
	bsf	EpdPort, Epd	;set data bit high

	SetEpW			;Set E^2 data line to output

	nop			;delay for 2us (including the next instruction time)

	bsf	EppPort, Epp	;turn E^2 on
	nop
	nop			;delay for 3us (really 5us with return time)

	return

;--------------------------------

EpOff				;turn E^2 off

	SetEpR			;set E^2 data line to input

;	bcf	EppPort, Epp	;turn E^2 off

	return

;--------------------------------

EpStart				;send start condition

	bsf	EpcPort, Epc	;set clock high
	bsf	EpdPort, Epd	;set data high

	SetEpW			;set E^2 data bit to output

	nop
	nop			;delay 5us for start setup time

	bcf	EpdPort, Epd	;set data low

	nop
	nop			;delay 5us for start hold time

	bcf	EpcPort, Epc	;set clock low

	return

;--------------------------------

EpStop				;send stop condition

	bcf	EpdPort, Epd	;set data low

	SetEpW			;set E^2 data bit to output

	nop
	nop			;delay 5us for stop setup time

	bsf	EpcPort, Epc	;set clock high

	nop
	nop

	bsf	EpdPort, Epd	;set data high

	nop
	nop			;delay 5us for stop hold / buss idle time

	return

;--------------------------------

Wack				;write ack to the E^2

	bcf	EpdPort, Epd	;pre set data line low

	SetEpW			;set E^2 data bit to output

	nop
	nop			;delay 4us for data setup time

	bsf	EpcPort, Epc	;set clock high

	nop
	nop			;delay 4us for min clock high time

	bcf	EpcPort, Epc	;set clock low

	return

;--------------------------------

Rack				;read ack from the E^2, no carry = ack

	SetEpR			;set E^2 data bit to input

	nop
	nop			;delay 5us for data setup time

	bsf	EpcPort, Epc	;set clock high

	nop
	nop			;delay 5us for min clock high time

	setc			;set carry
	btfss	EpdPort, Epd	;test data line from E^2
	clrc			;data line low so clear carry

	bcf	EpcPort, Epc	;set clock low

	return

;--------------------------------

WrEp				;write byte/s to the E^2, data = epbufw, length = eplgn, dest = epadr

	movlw	EpRetry
	movwf	eprty		;load E^2 no ack retry counter

	btfss	EppPort, Epp	;test if E^2 already powered on
	call	EpOn		;no - so turn E^2 on

wragn
	call	EpStart		;send buss start to signal command byte next

	movlw	WeCmd		;load E^2 write command
	call	Wr8ep		;send command to the E^2
	call	Rack		;read ack from E^2
	skpc			;skip if carry set (no ack received)
	goto dowadr		;ack received, op ok - so send adr

	decfsz	eprty, F	;bad ack, so dec retry counter
	call	EpStop		;set buss idle state
	goto	wragn		;try the write again

	setc			;retry failed
	return			;return with carry set

dowadr
	movfw	epadr		;load msb of address
	call	Wr8ep		;send high byte of address to E^2
	call	Rack		;read ack from E^2
	skpnc			;skip if ack received
	return			;op failed - no ack, return with carry set

	movfw	epadr+1		;load lsb of address
	call	Wr8ep		;send low byte of address to E^2
	call	Rack		;read ack from E^2
	skpnc			;skip if ack received
	return			;op failed - no ack, return with carry set

	movlw	eprwb		;load ep read write buffer address
	movwf	FSR		;load E^2 write pointer

nxtepw
	movfw	INDF		;load data byte to write
	call	Wr8ep		;send data in epbufw to E^2
	call	Rack		;read ack from E^2
	incf	FSR, f		;inc byte write pointer

	decfsz	eplgn, f	;dec bytes to send
	goto	nxtepw

	call	EpStop		;send buss stop condition & initiate the write
	clrc			;clear carry to indicate op ok

	return

;--------------------------------

RdEp				;read bytes/s from the E^2 into epbufr, length = eplgn, source = epadr

	movlw	EpRetry		;load max no ack command retry
	movwf	eprty		;save E^2 no ack retry counter

	btfss	EppPort, Epp	;test if E^2 already powered on
	call	EpOn		;no - so turn E^2 on

rdagn
	call	EpStart		;send buss start to signal command byte next

	movlw	WeCmd		;load E^2 write command
	call	Wr8ep		;send command to the E^2
	call	Rack		;read ack from E^2
	skpc			;skip if carry set (no ack received)
	goto doradr		;ack received, op ok - so send adr

	decfsz	eprty, F	;bad ack, so dec retry counter
	call	EpStop		;set buss idle state
	goto	rdagn		;try the write again

	setc			;retry failed
	return			;return with carry set

doradr
	movfw	epadr		;load msb of E^2 address
	call	Wr8ep		;send msb of E^2 address to E^2
	call	Rack		;read ack from E^2
	skpnc			;skip if ack received
	return			;op failed - no ack, return with carry set

	movfw	epadr+1		;load lsb of E^2 address
	call	Wr8ep		;send low byte of address to E^2
	call	Rack		;read ack from E^2
	skpnc			;skip if ack received
	return			;op failed - no ack, return with carry set

	call	EpStart		;send buss start to signal command byte next

	movlw	ReCmd		;load E^2 read command
	call	Wr8ep		;send read command to the E^2
	call	Rack		;read ack from E^2

	movlw	eprwb		;load address of E^2 read buffer
	movwf	FSR		;set pointer to it
	goto	readep		;skip sending the ack pre first byte

nxtepr
	call	Wack		;write the ack to the E^2 to get the next byte

readep
	call	Rd8ep		;read byte from the E^2 into W
	movwf	INDF		;store byte read from E^2
	incf	FSR, f

	decfsz	eplgn, f	;dec bytes to read
	goto	nxtepr		;equal so inc to next address

	call	EpStop		;send buss stop condition

	return

;-----------------------------------------------------------------------
; General comms procedures
;-----------------------------------------------------------------------

Delaybaud			;delay for 9600 baud rate (104 us)

	movlw	(104-14)/3	;load delay for 9600 baud
	movwf	baud		;store it in baud loop counter

dob
	decfsz	baud, f		;dec loop counter & test for zero
	goto	dob		;no - so do it again

	return			;yes - exit

;---------------------------------

Delayhbaud			;delay for 1/2 9600 baud rate (72 us)

	movlw	(72-26)/3	;load delay for 1/2 9600 baud time
	movwf	baud		;store it in baud loop counter

dohalfb
	decfsz	baud, f		;dec loop counter & test for zero
	goto	dohalfb		;no - so do it again

	return			;yes - exit

;--------------------------------

Send8n				;sent byte in w as 8N RS232 (low = 1)

	movwf	xmtchr		;save byte to be sent
;
;	movlw	cpdcon		;load constant in case we need it later
;	movf	xmtcnt, f	;test if send char count = zero
;	skpnz			;no - so skip initialize
;	movwf	xmtcnt		;initialize xmtchr to 4
;
;	decf	xmtcnt, f
;	skpnz			;test if send char count = 0 (4 char @ 9600 = 4ms)
;	call	CkWork		;yes - so do check for other work to do before sending next character
;	
	movlw	8
	movwf	bitcnt		;init shift count

	bsf	TdPort, Td	;set Td high / spacing / 0 for start bit
	nop
	nop
	call	Delaybaud
	nop
	nop

next8n
	rrf	xmtchr, f	;rotate right lsb into carry
	skpc			;skip if carry set
	goto	dozero8n	;no - so send 0
	nop			;1us timing delay
	bcf	TdPort, Td	;yes - so put 1 on TD line
	goto	dobaud8n	;goto baud delay

dozero8n
	bsf	TdPort, Td	;put 0 on TD line
	nop
	nop			;2us delay to make high = low time

dobaud8n
	call	Delaybaud	;delay for 1 baud time

	decfsz	bitcnt, f	;test if more bits to send
	goto	next8n		;yes - so do it again

	bcf	TdPort, Td	;no - so set td low / marking / 1 for stop bit
	call	Delaybaud	;delay for 1 baud time

	return

;---------------------------------

Recv8n				;receive 8N byte from inverted RS232 input via opto (low = start / 0) in w

	movlw	(1000/6)
	movwf	temp		;set up long stop char timer
	clrc			;clear carry to flag invalid

looksb
	decf	temp, f		;dec long stop timer
	skpnz			;skip if not timed out (= 0)
	return

	btfsc	RdPort, Rd	;test for start bit transition (1 to 0)
	goto	looksb		;data line marking (1), wait for spacing (0)

	nop
	nop
	nop
	nop
	nop
	nop
	nop			;wait 10us to make sure line is stable

	btfsc	RdPort, Rd	;test for start bit transition (1 to 0)
	goto	looksb		;data line marking (1), wait for spacing (0)

	call	Delayhbaud	;delay for 1/2 baud time

	btfsc	RdPort, Rd	;test for start bit transition (1 to 0)
	goto	looksb		;data line marking (1), wait for spacing (0)

	movlw	8
	movwf	bitcnt		;set bit counter to receive 8 bits
	clrf	rcvchr		;clear last comm received character
	clrc			;clear carry

r8na
	rrf	rcvchr, f	;rotate partial received comm char right one bit
	call	Delaybaud	;yes - so delay full baud to get into middle of next bit
	btfss	RdPort, Rd	;test status of Rd
	bsf	rcvchr, 7	;set msb of comm ch
	decfsz	bitcnt, f	;test if more bits to receive
	goto	r8na		;yes - so do it

	comf	rcvchr, F	;complement received character

	movlw	(1000/6)
	movwf	temp		;load long space timeout
	clrc			;clear valid character flag

wstop
	decf	temp, f		;dec 1ms downcounter
	skpnz			;skip if not yet zero
	return			;waited too long for marking - so return

	btfss	RdPort, Rd	;test rd = marking / high / 1
	goto	wstop		;no - so wait for it to happen

	nop
	nop
	nop
	nop
	nop
	nop
	nop			;wait 10us to make sure line is stable

	btfss	RdPort, Rd	;test rd = marking / high / 1
	goto	wstop		;no - so wait for it to happen

	movfw	rcvchr		;load w with received character
	setc			;set carry to flag valid character received

	return

;--------------------------------

CkComms				;check for and read inward comms character

	bsf	ERdPort, ERd	;enable opto load resistor

nxc
	call	Recv8n		;receive inward comms character into rcvchr
	skpc			;skip if valid character received
	goto	excom		;no - so exit

	sublw	' '		;test if we received a wake up space character
	skpnz			;skip if something else
	goto	nxc		;goto receive the next wake up character

	movfw	rcvchr
	sublw	enq		;load enq char
	skpnz			;was enq received
	goto	recnxt		;yes - so get next byte

	movlw	(1000/5)
	movwf	temp		;initialize timeout downcounter

w0
	decfsz	temp, f		;dec 1ms timeout
	return			;waited too long - so return

	btfsc	RdPort, Rd
	goto	w0		;wait for low / 0 / spacing

	nop
	nop
	nop
	nop
	nop
	nop
	nop			;wait 10us to make sure line is stable

	btfsc	RdPort, Rd
	goto	w0		;wait for low / 0 / spacing

	movlw	(1000/5)
	movwf	temp		;initialize timeout downcounter

w1
	decfsz	temp, f		;dec 1ms timeout
	return			;waited too long - so return

	btfss	RdPort, Rd
	goto	w1		;wait for high / 1 / marking

	nop
	nop
	nop
	nop
	nop
	nop
	nop			;wait 10us to make sure line is stable

	btfss	RdPort, Rd
	goto	w1		;wait for high / 1 / marking

	goto	nxc		;goto nxc to resync to new start bit

recnxt
	call	Recv8n		;get VPM command byte
	call	DoInput		;and do what we are asked to do
	bcf	ERdPort, ERd	;disable opto load resistor to save power

	call	LoadTOD		;load TOD
	welall	epatod, 6	;store last access time

	call	DoAdc		;do Adc cycle as we just took up it's time slot

	return

excom
	bcf	ERdPort, ERd	;disable opto load resistor to save power

	return

;----------------------------------------------------------
; Comms conversion procedures
;----------------------------------------------------------

CovHex				;convert 3:4 into Hex Ascii

	andlw	0x0f		;isolate ls hexade
	iorlw	0x30		;assume it is <=9
	movwf	temp		;save result
	sublw	0x39		;test if > 9
	skpnc			;yes - so make it A-F
	goto	finhex		;no - so goto return with Ascii in w

	movlw	('A'-'9')-1	;load adjustment (Decimal to Alpha adjustment factor)
	addwf	temp, f		;make adjustment to alpha (A-F)

finhex
	movfw	temp		;load converted hex character
	return

;--------------------------------

SendHex				;send binary in w as 2 hex numbers

	movwf	tempw		;save binary
	swapf	tempw, w	;swap hexades to convert 7:4
	call	CovHex		;convert w 3:4 into Hex & leave in w
	call	Send8n		;send it

	movfw	tempw		;load original again
	call	CovHex		;convert 3:4
	call	Send8n		;sendit

	return

;--------------------------------

SendBin				;convert binary in w into 2 packed bcd nibbles & send to comms

	call	BtoBcd		;convert to 2 packed bcds in w
	call	SendBcd		;send it

	return

;--------------------------------

GetBin				;get 2 bytes, convert into bcd and convert into binary

	call	GetBcd		;get 2 bytes, convert into packed bcd in w
	call	BcdtoB		;convert packed bcd in w into binary and leave in w

	return

;--------------------------------

SendBcd				;send two packed bcd digits in w

	movwf	tempw		;save in temp w

	swapf	tempw, w	;load msb of revs and swap hexades to send left first
	call	SendRight	;send it
	movfw	tempw		;reload to send right hexade
	call	SendRight	;send it

	return

;--------------------------------

GetBcd				;receive two ascii and pack their ls hexade into 1 char

	call	Recv8n		;receive 1st ascii in w
	andlw	0x0f		;isolate 3:4
	movwf	bcdchr		;store it away
	swapf	bcdchr, F	;swap hexades

	call	Recv8n		;receive 2nd ascii in w
	andlw	0x0f		;isolate 3:4
	iorwf	bcdchr, W	;or in first bcd and return with result in w

	return

;--------------------------------

SendDec				;send two packed BCD digits in w with a decimal point between

	movwf	tempw		;save w

	swapf	tempw, w	;load msb of revs and swap hexades to send left first
	call	SendRight	;send it

	movlw	'.'		;load '.'
	call	Send8n		;send decimal point

	movfw	tempw		;reload to send right hexade
	call	SendRight	;send it

	return

;--------------------------------

GetDec				;receive three ascii x.x and pack their ls hexade into 1 char

	call	Recv8n		;receive 1st ascii in w
	andlw	0x0f		;isolate 3:4
	movwf	bcdchr		;store it away
	swapf	bcdchr, F	;swap hexades

	call	Recv8n		;get decimal point

	call	Recv8n		;receive 2nd ascii in w
	andlw	0x0f		;isolate 3:4
	iorwf	bcdchr, W	;or in first bcd and return with result in w

	return

;--------------------------------

BtoBcd				;convert binary in w to bcd (max = 99) and return in w

	clrf	temp		;clear temp msb
	movwf	temp1		;store binary

sub10
	movlw	10
	subwf   temp1, w	;sub 10 from binary in w
	btfss   STATUS, C	;test if w > 10
	goto    over		;no - so finish up conversion
	movwf	temp1		;yes - so store new binary - 10
	incf    temp, f		;inc msb count
	goto    sub10		;goto do another -10 cycle

over
	swapf	temp, w		;move lshexade to mshexade and leave in w
	addwf	temp1, w	;put final result in w as two hexades

	return

;--------------------------------

BcdtoB				;convert packed bcd in w (max = 99) into binary

	movwf	temp1		;store bcd
	movwf	temp		;store bcd

	swapf	temp1, w	;swap hexades to make +10 loop counter
	andlw	0x0f		;zap out old ls hexade
	skpnz			;skip if ms <> 0 (conversion needed)
	goto	ebcdtob		;no - so just reload original

	movwf	temp1		;store back with only +10 loop counter bits

	movfw	temp		;load temp
	andlw	0x0f		;zero bits 7:4
	movwf	temp		;store bits 3:4 (ls hexade) to form add base

add10
	movlw	10		;load 10
	addwf	temp, f		;add it to base
	decfsz	temp1, f	;dec +10 loop counter
	goto	add10		;goto do it again

ebcdtob
	movfw	temp		;load binary result into w

	return

;----------------------------------------------------------
; Comms sending procedures
;----------------------------------------------------------

SendFd				;send delimiter

	movlw	','
	call	Send8n		;send ','

	return

;--------------------------------

SendRID				;send raw interval data

	call	SendMtr		;send meter serial number to identify the data

	call	SendFd		;','

	relall	epotod, 6	;read oldest time stamp

	movfw	eprwb
	call	SendBin		;send hh
	movfw	eprwb+1
	call	SendBin		;send mm
	movfw	eprwb+2
	call	SendBin		;send dd
	movfw	eprwb+3
	call	SendBin		;send mm
	movfw	eprwb+4
	call	SendBin		;send yy
	movfw	eprwb+5
	call	SendBin		;send yy
	call	SendFd		;send ','

	relall	epntod, 6	;read newest time stamp

	movfw	eprwb
	call	SendBin		;send hh
	movfw	eprwb+1
	call	SendBin		;send mm
	movfw	eprwb+2
	call	SendBin		;send dd
	movfw	eprwb+3
	call	SendBin		;send mm
	movfw	eprwb+4
	call	SendBin		;send yy
	movfw	eprwb+5
	call	SendBin		;send yy

	call	SendFd		;send ','

	relall	epokwh, kwbytes	;load KWH at start of first interval
	call	DoKWH		;send KWD data

	call	SendFd		;','

	relall	epnkwh, kwbytes	;load KWH at end of last interval
	call	DoKWH		;send KWH data

	call	SendFd		;','

	relall	epnivl, 2	;load # of intervals

	movfw	eprwb
	movwf	tempnh		;save in ram
	call	SendBin		;send # of intervals msb

	movfw	eprwb+1
	movwf	tempnl		;save in ram
	call	SendBin		;send # of intervals lsb

	call	SendFd		;send ','

	movfw	mpi		;load minutes per interval
	call	SendBin		;send minutes per interval

	call	SendFd		;send ','

	relall	epoadr, 2	;load oldest interval pointer from E^2

	movfw	eprwb
	movwf	epadr		;save interval address high

	movfw	eprwb+1
	movwf	epadr+1		;save interval address low

nxid
	movfw	tempnl
	addwf	tempnh, w	;test for zero intervals
	skpnz			;skip if <> zero
	return			;yes - so return

	movlw	2
	movwf	eplgn		;set E^2 read length = 2

	call	RdEp		;read interval data from E^2

	movfw	eprwb
	call	SendBcd		;send msb of interval data as 2 BCDs

	movfw	eprwb+1
	call	SendBcd		;send lsb of interval data as 2 BCDs

	movlw	'0'
	call	Send8n		;send zero to fill out 3 bytes of WH info

	call	SendFd

	decf	tempnl, f	;dec lsb of interval count
	movlw	0xff		;load underflow test
	subwf	tempnl, w	;test if it was zero and is now 0xff
	skpnz			;no - so skip dec of msb of interval count
	decf	tempnh, f

	incf	epadr+1, f	;inc lsb of interval pointer
	skpnz			;test if overflow
	incf	epadr, f	;yes - so inc msb of interval pointer

	incf	epadr+1, f	;inc lsb of interval pointer
	skpnz			;test if overflow
	incf	epadr, f	;yes - so inc msb of interval pointer

	goto	nxid		;go to check if we need to send another interval

	return

;--------------------------------

SendVPM				;send Virtual Power Meter data stream

	bcf	flgs, vpmflg	;clear do vpm flag

	call	SendKWH		;send total KWH
	call	SendWH15	;send WH in last 15 seconds

	return

;--------------------------------

SendWID				;send selected interval data in WH format

	return

;--------------------------------

SendTOUP			;send KWH in TOU price bands

	return

;--------------------------------

SendTOUT			;send KWH in TOU time bands

	return

;--------------------------------

SendTOUKWH			;send total KWH for selected period

	return

;--------------------------------

SendWH15			;send WH used in last 15 seconds

	return

;--------------------------------

SendTI				;send total intervals

	return

;--------------------------------

SendTmp				;send state of tamper flag

	return

;--------------------------------

SendBHM				;send battery hours since manufacture

	return

;--------------------------------

SendBHI				;send battery hours since installation

	return

;--------------------------------

SendBS				;send battery state

	return

;--------------------------------

SendMT				;send manufacturing time & data

	return

;--------------------------------

SendIT				;send installation time & date

	return

;--------------------------------

SendAT				;send last access time

	return

;--------------------------------

SendLT				;send last login time & date

	return

;--------------------------------

SendPT				;send last password / usercode change time & date

	return

;--------------------------------

SendRev				;send last disc rev time

	return

;--------------------------------

Send15				;send power used in last 15 seconds

	return

;--------------------------------

SendP				;send peak power used & time / date stamp

	return

;--------------------------------

SendTpr				;send last tamper time & date

	return

;--------------------------------

SendPL				;send last power loss time & date

	return

;--------------------------------

SendPR				;send last power restored time & date

	return

;--------------------------------

SendHS				;send Hermes unique serial number

	return

;--------------------------------

SendNON				;send number of in use intervals, oldest & newest interval address, current WH tick

	relall	epnivl, 2	;read data from E^2
	movfw	eprwb		;load digit 1,2
	call	SendHex		;send it
	movfw	eprwb+1		;load digit 3,4
	call	SendHex		;send it

	relall	epoadr, 2	;read data from E^2
	movfw	eprwb		;load digit 1,2
	call	SendHex		;send it
	movfw	eprwb+1		;load digit 3,4
	call	SendHex		;send it

	relall	epnadr, 2	;read data from E^2
	movfw	eprwb		;load digit 1,2
	call	SendHex		;send it
	movfw	eprwb+1		;load digit 3,4
	call	SendHex		;send it
	
	movfw	itck
	call	SendBcd
	movfw	itck+1
	call	SendBcd
	movfw	itck+2
	call	SendBcd		;send current value of itck in HW

	return

;--------------------------------

SendKWHc			;send KWH used since total KWH set

	relall	epckwh, kwbytes	;read data from E^2

	call	DoKWH		;send KWH data

	return

;--------------------------------

SendKWHi			;send KWH @ installation

	relall	epikwh, kwbytes	;read data from E^2

	call	DoKWH		;send KWH data

	return

;--------------------------------

SendKWH				;send current KWH

	relall	epmkwh, kwbytes	;read data from E^2

DoKWH
	movfw	eprwb		;load digit 1,2
	call	SendBcd		;send it
	movfw	eprwb+1		;load digit 3,4
	call	SendBcd		;send it
	movfw	eprwb+2		;load digit 5,6
	call	SendDec		;send it with decimal in the middle
	movfw	eprwb+3		;load digit 7,8
	call	SendBcd		;send it

	return

;--------------------------------

SendPpt				;Send pulses per tick & wh per tick

	movfw	ppt		;load pulses per tick
	call	SendBin		;send it

	movfw	wpt		;load wh per tick
	call	SendBin		;send it

	return

;--------------------------------

SendMtr				;send meter number stored as packed bcd in the bytes of mnum

	relall	epmnum, kwbytes	;read data from E^2

	movfw	eprwb		;load digit 1,2
	call	SendBcd		;send it
	movfw	eprwb+1		;load digit 3,4
	call	SendBcd		;send it
	movfw	eprwb+2		;load digit 5,6
	call	SendBcd		;send it
	movfw	eprwb+3		;load digit 7,8
	call	SendBcd		;send it

	return

;--------------------------------

SendDate			;send the date as "dd/mm/yyyy "

	movfw	day		;load day
	call	SendBin		;send binary in w as 2 numeric bcds to comms
	movfw	month		;load month
	call	SendBin		;send binary in w as 2 numeric bcds to comms
	movfw	yearhi		;load year high
	call	SendBin		;send binary in w as 2 numeric bcds to comms
	movfw	yearlo		;load year low
	call	SendBin		;send binary in w as 2 numeric bcds to comms

	return

;--------------------------------

SendTime			;send the time as "hh:mm:ss "

	movfw	hour		;load hour
	call	SendBin		;send binary in w as 2 numeric bcds to comms
	movfw	minute		;load minute
	call	SendBin		;send binary in w as 2 numeric bcds to comms
	movfw	second		;load second
	call	SendBin		;send binary in w as 2 numeric bcds to comms

	return

;--------------------------------

SendDct				;send time between disk edge checks (in 30.5us ticks)

	movfw	dct		;load dct
	call	SendHex		;send it

	return

;--------------------------------

SendAdc				;send adc parameters

	movfw	iron		;load Iron
	call	SendHex		;send as hex

	movfw	max		;load max
	call	SendHex		;send as hex

	movfw	min		;load min
	call	SendHex		;send as hex

	movfw	blvl		;load black schmidt trigger level
	call	SendHex		;send as hex

	movfw	wlvl		;load white schmidt trigger level
	call	SendHex		;send as hex

	movfw	dptcnt		;send current black depth
	call	SendHex		;send as hex

	return

;--------------------------------

SendDpt				;send black flag depth

	movfw	dpt		;load black flag depth
	call	SendBin		;send binary as 2 Bcds

	return

;--------------------------------

SendSpv				;send seconds per VPMs

	movfw	spv		;load seconds between VPMs
	call	SendBin		;send binary as 2 Bcds

	return

;--------------------------------

SendInt				;send minutes per interval

	movfw	mpi		;load minutes in interval
	call	SendBin		;send binary as 2 Bcds

	return

;--------------------------------

SendLvl				;send black flag trigger level

	movfw	blvl		;load current black schmidt trigger level
	call	SendHex		;send binary as 2 Bcds

	movfw	wlvl		;load current white schmidt trigger level
	call	SendHex

	return

;--------------------------------

SendLed				;send the state of the visual led

	movlw	'1'		;send "1" for On
	btfss	flgs, ledflg	;test visual led flag
	movlw	'O'		;send "0" for Off

	call	Send8n		;Send flag state

	return

;--------------------------------

SendEco				;send the state of the echo flag

	movlw	'1'		;send "1" for On
	btfss	flgs, ecoflg	;test echo flag
	movlw	'O'		;send "0" for Off

	call	Send8n		;Send flag state

	return

;--------------------------------

;SendRom				;send rom text string to comms
;
;	call	ReadPgm		;get next 2 bytes of message into pgd & inc pgadr
;
;	rlf	pgd+1, w	;load carry with 7:1 of ls byte
;	rlf	pgd, w		;shift carry into 0:1 ms byte & leave in w
;	bcf	pgd+1, 7	;reset 7:1 of ls byte
;	call	Send8n		;send ms byte (in w) to comms
;
;	movfw	pgd+1		;load ls byte
;	call	Send8n		;send ls byte (in w) to comms
;
;	decfsz	pglen, f	;dec byte pairs to send & test for zero
;	goto	SendRom		;no - do it again
;
;	return			;yes - so exit

;---------------------------------

SendRight			;convert nibble in lsb of w into ascii and send it down the line

	andlw	0x0f		;zap w[7:4] to 0 (ms nibble)
	iorlw	0x30		;make it a ascii number by oring in 0x30
	call	Send8n		;send it down the line

	return

;------------------------------------------------------------------
; Comms receiving procedures
;------------------------------------------------------------------

GetPass				;get new password

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	LoadTOD
	welall	epstod, 6	;save new password set time

	return

;--------------------------------

GetUser				;get new usercode

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	LoadTOD
	welall	epstod, 6	;save new usercode set time

	return

;--------------------------------

GetLogin			;get usercode & password to allow set / clear

	call	LoadTOD
	welall	eputod, 6	;store last login TOD

	return

;--------------------------------

ClrP				;clear peak

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

ClrTpr				;clear tamper

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

ClrPL				;clear power loss

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

ClrPR				;clear power restored

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetIStart			;get interval data download start date

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetIEnd				;get interval data download end date

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetSunday			;get interval Sunday

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetTOUP				;get interval index for price band

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetTOUT				;get interval index for time band

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	return

;--------------------------------

GetDct				;get new dct

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes as binary
	movwf	dct		;store it

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendDct		;send new dct as verify

	return


;--------------------------------

GetOQ				;turn optical quality monitor on & off

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	Recv8n		;get next byte
	movwf	tempw		;save w
	sublw	'1'		;test = 1
	skpnz			;no - so skip enable
	bsf	flgs, oqflg	;enable optical quality monitoring

	movfw	tempw		;load received byte
	sublw	'0'		;test = 0
	skpnz			;no - so skip disbale
	bcf	flgs, oqflg	;disable optical quality monitoring

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendLed		;send led status as verify

	return

;--------------------------------

GetEco				;get new echo enable / disable flag

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	Recv8n		;get next byte
	movwf	tempw		;save w
	sublw	'1'		;test = 1
	skpnz			;no - so skip enable
	bsf	flgs, ecoflg	;enable visual led

	movfw	tempw		;load received byte
	sublw	'0'		;test = 0
	skpnz			;no - so skip disbale
	bcf	flgs, ecoflg	;disable visual led

	call	SaveEp		;save to E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendLed		;send led status as verify

	return

;--------------------------------

GetLed				;get black flag to visual led enable / disable byte

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	Recv8n		;get next byte
	movwf	tempw		;save w
	sublw	'1'		;test = 1
	skpnz			;no - so skip enable
	bsf	flgs, ledflg	;enable visual led

	movfw	tempw		;load received byte
	sublw	'0'		;test = 0
	skpnz			;no - so skip disbale
	bcf	flgs, ledflg	;disable visual led

	call	SaveEp		;save to E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendLed		;send led status as verify

	return

;--------------------------------

GetLvl				;get new black & white schmidt trigger levels

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes & convert to binary
	movwf	blvl		;store it away

	call	Recv8n		;get comma

	call	GetBin		;get 2 ascii byte & cnvert to binary
	movwf	wlvl		;store it away

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendLvl		;send new black and white levels as verify

	return

;--------------------------------

GetDpt				;get new black flag depth

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes and convert to binary
	movwf	dpt		;store it away

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendDpt		;send new depth as verify

	return

;--------------------------------

GetPpt				;get new pulses per tick and wh per tick

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes and convert to binary
	movwf	ppt		;store them away

	call	Recv8n		;get comma

	call	GetBin		;get 2 ascii bytes and convert to binary
	movwf	wpt		;store them away

	call	SaveEp		;save in E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendPpt		;send new ppt as verify

	return

;--------------------------------

GetSpv				;get new seconds per VPMs

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes and convert to binary
	movwf	spv		;store it away

	call	SaveEp		;save in E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendSpv		;send new vps as verify

	return

;--------------------------------

GetInt				;get new interval

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get 2 ascii bytes and convert to binary
	movwf	mpi		;store it

	call	SaveEp		;save in E^2
	call	ClrIvl		;clear interval parameters and memory

	btfss	flgs, ecoflg	;skip if echo flag off
	return

	call	SendFd		;','
	call	SendInt		;send new interval as verify

	return

;--------------------------------

GetMtr

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBcd		;receive 1st 2 bcd digits
	movwf	eprwb		;store them away

	call	GetBcd		;receive 2nd 2 bcd digits
	movwf	eprwb+1		;store them away

	call	GetBcd		;receive 3rd 2 bcd digits
	movwf	eprwb+2		;store them away

	call	GetBcd		;receive 4th 2 bcd digits
	movwf	eprwb+3		;store them away

	welall	epmnum, 4	;write to E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendMtr		;send new meter serial number as verify

	return

;--------------------------------

GetKWHc				;get new current KWH

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBcd		;receive digit 1,2
	movwf	eprwb		;store them away

	call	GetBcd		;receive digit 3,4
	movwf	eprwb+1		;store them away

	call	GetDec		;receive digit 5,6
	movwf	eprwb+2		;store them away

	clrf	eprwb+3		;clear last 2 digits

	welall	epckwh, kwbytes	;store in E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendKWHc	;send new current KWH as verify

	return

;--------------------------------

GetKWHi				;get installation KWH

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBcd		;receive digit 1,2
	movwf	eprwb		;store them away

	call	GetBcd		;receive digit 3,4
	movwf	eprwb+1		;store them away

	call	GetDec		;receive digit 5,6
	movwf	eprwb+2		;store them away

	clrf	eprwb+3		;clear last 2 digits

	welall	epikwh, kwbytes	;store in E^2

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendKWHi	;send new installation KWH as verify

	return

;--------------------------------

GetKWH

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBcd		;receive digit 1,2
	movwf	eprwb		;store them away

	call	GetBcd		;receive digit 3,4
	movwf	eprwb+1		;store them away

	call	GetDec		;receive digit 5,6
	movwf	eprwb+2		;store them away

	clrf	eprwb+3		;clear last 2 digits

	welall	epmkwh, kwbytes	;store in E^2

	movfw	ppt		;load pulses per tick
	movwf	pptcnt		;store to reset ppt to start

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendKWH		;send new meter KWH as verify

	return

;--------------------------------

GetTime				;get time

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get HH
	movwf	hour		;store in hour

	call	GetBin		;get MM
	movwf	minute		;store in minute

	call	GetBin		;get SS
	movwf	second		;store in second

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendTime	;send new time as verify

	call	SaveEp		;save TOD to E^2
	return

;--------------------------------

GetDate				;get date

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	GetBin		;get DD
	movwf	day		;store in day

	call	GetBin		;get MM
	movwf	month		;store in month

	call	GetBin		;get YY high
	movwf	yearhi		;store in year hi

	call	GetBin		;get YY low
	movwf	yearlo		;store in year lo

	btfsc	flgs, ecoflg	;skip if echo flag off
	call	SendDate	;send new date as verify

	call	SaveEp		;save TOD to E^2

	return

;--------------------------------

GetMTOD				;store TOD as manufacturing date

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	LoadTOD		;get TOD
	welall	epmtod,6	;store it in the E^2

	clrf	eprwb
	clrf	eprwb+1
	clrf	eprwb+2
	welall	epbhm, 3	;zero battery hours since manufacturing

	return

;--------------------------------

GetITOD				;store TOD as installation date

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	call	LoadTOD		;load TOD
	welall	epitod,6	;store it in the E^2

	clrf	eprwb
	clrf	eprwb+1
	clrf	eprwb+2
	welall	epbhi, 3	;zero battery hours since installation

	return

;-----------------------------------------------------------------------
; Opto procedures
;-----------------------------------------------------------------------

Op1On

	bsf	Op1Port, Op1	;turn on Opto load resistor 1

	return

;---------------------------------

Op1Off

	bcf	Op1Port, Op1	;turn off Opto load resistor 1

	return
;---------------------------------
;
;Op2On
;
;	bsf	Op2Port, Op2	;turn on Opto load resistor 2
;	return
;---------------------------------
;
;Op2Off
;
;	bcf	Op2Port, Op2	;turn off Opto load resistor 2
;	return
;
;-----------------------------------------------------------------------
; Led procedures
;-----------------------------------------------------------------------

DoPulse				;pulse flag bit (B5) for 104us

	bsf	FlgPort, Flg	;make flg bit high
	call	Delaybaud	;delay 104us to make the flg pulse seeable on a scope
	bcf	FlgPort, Flg	;make flg bit low
	call	Delaybaud	;delay another 104us
	return

;---------------------------------

LedOn

	bcf	LedPort, Led	;turn visual led on

	return

;---------------------------------

LedOff

	bsf	LedPort, Led	;turn visual led off

	return

;--------------------------------

Ir1On

	bcf	Ir1Port, Ir1	;turn IR led load resistor 1 on

	return

;---------------------------------

Ir1Off

	bsf	Ir1Port, Ir1	;turn IR led load resistor 1 off

	return

;--------------------------------
;
;Ir2On
;
;	bcf	Ir2Port, Ir2	;turn IR led load resistor 2 on
;
;	return
;
;---------------------------------
;
;Ir2Off
;
;	bsf	Ir2Port, Ir2	;turn IR led load resistor 2 off
;
;	return
;
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

;-----------------------------------------------------------------------
; Adc procedures
;-----------------------------------------------------------------------

DoCal				;force a recalibrate of Adc parameters

	btfss	flgs, setflg	;test if we can do this command
	return			;no

	clrf	max		;set max = 0

	movlw	0xff
	movwf	min		;set min to 0xff

	clrf	blvl
	clrf	wlvl		;set schmidt trigger levels to zero

	movlw	calcon+pptcon	;load calibration pulses until first tick
	movwf	pptcnt		;fudge big initial pulse count to allow self calibration

	btfsc	flgs, ecoflg	;skip if echo ok
	call	SendNON		;send Adc setup

	return

;--------------------------------

InitAdc				;initialize the Adc

	bsf	STATUS, RP0	;select bank 1
	movlw	b'00000000'	;left justified data, vref = AVdd/AVss
	movwf	ADCON1
	bcf	STATUS, RP0	;select bank 0

	return

;--------------------------------

DoAdc				;read Opto level

	call	Op1On		;turn on Opto load resistor 1
	call	Ir1On		;turn on IR led load resistor 1 to illuminate the disc edge

	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us
	call	Delaybaud	;delay 95us

	movlw	b'01001001'	;Fosc/8, channel 1, done, adc on
	movwf	ADCON0		;enable Adc to sample opto for last delay period

	call	Delaybaud	;delay 384us for the opto to fully respond to Ir pulse

	bsf	ADCON0, GO	;start A/D conversion

	call	Ir1Off		;turn off IR led load resistor 1 to save power
	call	Op1Off		;turn off Opto load resistor 1 to save power

waitadc
	btfsc	ADCON0, GO	;Wait for "GO" to be reset by adc complete
	goto	waitadc		;no - so go to wait for adc complete

	bcf	ADCON0, ADON	;turn ADC off to save power

	return			;exit

;--------------------------------

MinMax				;check if Ir ADC > max or < Min and save if so

	movfw	iron		;load w with current Iron value
	subwf	max, w		;sub max - iron (w)
	skpnc			;skip if new max
	goto	ckmin

	movfw	iron		;load new max
	movwf	max		;store new max
	goto	doblvl		;new max set so calc new schmidt trigger levels

ckmin
	movfw	min		;load w with current min
	subwf	iron, w		;sub iron - min (w)
	skpnc			;skip if new min
	return			;no - so return

	movfw	iron		;load new min
	movwf	min		;store new min

doblvl
	movfw	min		;load min
	subwf	max, w		;sub max - min
	movwf	temp		;store max - min in temp

	clrc			;clear carry
	rrf	temp, f		;divide by 2
	clrc			;clear carry
	rrf	temp, f		;divide by 2 again
	clrc			;clear carry
	rrf	temp, w		;divide by 2 again for a total divide by 8

	subwf	max, w		;sub (max-min)/8 from max
	movwf	blvl		;set up new black schmidt trigger level

dowlvl
	movfw	min		;load min
	subwf	max, w		;sub max - min
	movwf	temp		;store max - min in temp

	clrc
	rrf	temp, f		;divide by 2
	clrc			;clear carry
	rrf	temp, w		;divide by 2 again for a total max - min divide by 4

	addwf	min, w		;add (max-min)/4 to min
	movwf	wlvl		;set up new white schmidt trigger level

	return

;--------------------------------

CkDisc				;main disc edge reader. Update interval tick if black flag just passed

	call	DoAdc		;get 12 bit value of opto input

	movfw	ADRESH		;load Ir value to w
	movwf	iron		;store Ir on value

	call	MinMax		;do Min / Max check and adjust schmidt trigger levels if necessary

	movfw	blvl		;load black schmidt trigger level
	subwf	iron, w		;do iron - blklvl, c = >= blklvl
	skpc			;skip if >= blk trip
	goto	ckwlvl		;no - so goto check if in white level

	decf	dptcnt, w	;dec dptcnt to test if = 1
	skpnz			;skip if not
	decf	max, f		;slowly dec max while in black to stop spikes

	movf	dptcnt, f	;check if depth = z (already seen this black band and did Ppt)
	skpnz			;skip if not zero
	goto	adcexit		;return if zero

	decfsz	dptcnt, f	;dec black flag depth
	goto	adcexit		;return if not zero

	call	DoPTOD		;record time of this pulse
	call	DoPpt		;dec pulses per tick
	btfsc	flgs, ledflg	;check if visual led flag on
	call	LedOn		;yes - so turn on led

	goto	adcexit

ckwlvl
	movfw	iron		;load adc value
	subwf	wlvl, w		;do wlvl - iron, c = <= whtlvl
	skpc			;skip if <= wht trip
	goto	adcexit		;return if in no man's land

	decf	dpt, w		;load dpr-1
	subwf	dptcnt, w	;is depth count = dpt-1
	skpnz			;skip if not
	incf	min, f		;slowly increase min to stop spikes

	movfw	dpt		;load max depth
	subwf	dptcnt, w	;do depth - maxdepth
	skpz			;skip if equal (max depth)
	goto	incdpt

	call	LedOff		;turn visual led off & exit
	goto	adcexit

incdpt
	incf	dptcnt, f	;no - so inc depth

adcexit
	call	SetDct		;get next disk time

	btfss	flgs, oqflg	;test if optical quality output on
	return			;no - so just return

	movfw	iron		;load last disc edge value
	call	SendHex		;send it
	movlw	','
	call	Send8n		;','

	return

;--------------------------------

CkAdc				;check if Adc needs firing up

	movfw	TMR1L		;load timer 1 low byte
	andlw	dctmsk		;and out bits 2:3
	subwf	dctnxt, w	;is it time to do some work
	skpnz			;no - so return
	call	CkDisc		;inc current interval tick count if black flag found

	return

;--------------------------------

CkPfail				;check & log power failures (loss of 50 hz EM field)

	return

;--------------------------------

CkTamper			;check & log tampering (loss of disc edge reflectivity)

	return

;--------------------------------

SetDct				;set up value for next disk check time

	movfw	dct		;load disk time interval
	addwf	TMR1L, w	;add TMR1L to literal to calc new value
	andlw	dctmsk		;zap 2:3
	movwf	dctnxt		;store new timer target

	return

;-----------------------------------------------------------------------
; Read program memory & rom stored massages
;-----------------------------------------------------------------------
;
;ReadPgm				;load pgd from pgadr & inc pgadr+1
;
;	bsf	STATUS, RP1	;select bank 2
;
;	movfw	pgadr		;load w with pgadr ms byte
;	movwf	PMADRH		;store it
;
;	movfw	pgadr+1		;load w with pgadr ls byte
;	movwf	PMADRL		;store it
;
;	bsf	STATUS, RP0	;select bank 3
;	bsf	PMCON1, RD	;do the read
;	bcf	STATUS, RP0	;select bank 2
;	nop			;null command, not executed as pgm memory read occurs
;
;	movfw	PMDATH		;load ms byte
;	movwf	pgd		;store ms byte
;
;	movfw	PMDATL		;load ls byte
;	movwf	pgd+1		;store ls byte
;
;	bcf	STATUS, RP1	;select bank 0
;
;	incf	pgadr+1, f	;inc pgadr ls byte
;	skpnz			;skip next op if result <> 0
;	incf	pgadr, f	;yes - so inc pgadr ms byte
;
;	return
;
;-----------------------------------------------------------------------
; Initialization procedures
;-----------------------------------------------------------------------

SetupIo				;setup the I/O ports

	movlw	IntA		;load initial port A output constant
	movwf	PORTA		;set initial port A output bits

	movlw	IntB		;load initial port B output constants
	movwf	PORTB		;set initial port B output bits

	bsf	STATUS, RP0	;setup bank 1 registers

	movlw	DirA		;load port A direction constant
	movwf	TRISA		;initialize port A data direction register

	movlw	DirB		;load port B direction constant
	movwf	TRISB		;initialize port B data direction register

	movlw	PbPu		;load port B weak pullup constant
	movwf	WPUB		;turn on weak pullup for E^2 data line & RS232 opto input
	bcf	OPTION_REG, 7	;enable global weak pullups

	movlw	AnalA
	movwf	ANSEL		;select analog input channel

	bcf	STATUS, RP0	;back to bank 0

	return

;--------------------------------
; Setup TOD, days in month lookup table and 32.768khz T1 clock oscillator
; CkTod adjust days in Feb for leap years (year mod 4 = 0) and is y3k 
compatiable
;--------------------------------

Init32khz			;set up 32.768khz TOD oscillator

	movlw	b'00001111'	;set 1:1 prescaler, clock = external, enable T1 osc, count mode, no ext clock sync
	movwf	T1CON		;load t1 control with setup above & start oscillator & counting
	clrf	TMR1L		;set T1 low counter to zero
	clrf	TMR1H		;set T1 high counter to zero

;--------------------------------

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

w1sec
	btfss	TMR1H, 7	;test for 1 second flag
	goto	w1sec		;no so goto wait for 1 second flag to happen

	bcf	TMR1H, 7	;reset first 1 second flag

	return

;--------------------------------
; Setup initial programmable variables
;--------------------------------

GetPrams			;clear ram & set the default parameters

	movlw	ram0
	movwf	FSR		;set pointer to start of ram

nxtclr				;clear bank 0 ram from 0x20 thru 0x7f
	clrf	INDF		;clear @ pointer
	incf	FSR, f		;inc pointer
	btfss	FSR, 7		;test if cleared last ram
	goto	nxtclr		;no - so go clear more ram

	movlw	pptcon		;load default
	movwf	ppt		;store pulses / tick
	movwf	pptcnt		;initialize downcounter

	movlw	mpicon		;load default
	movwf	mpi		;store minutes per interval
	movwf	mpicnt		;initialize downcounter

	movlw	wptcon		;load default
	movwf	wpt		;store wh / tick

	movlw	spvcon		;load default
	movwf	spv		;store seconds per vpms
	movwf	spvcnt		;initialize downcounter

	movlw	dptcon		;load default black depth
	movwf	dpt		;store black depth
	movwf	dptcnt		;initialize downcounter

	movlw	dctcon		;load default
	movwf	dct		;store disk edge check time

	bsf	flgs, ledflg	;enable visual led to blink with black flag
	bsf	flgs, ecoflg	;enable echos on set commands
	bsf	flgs, setflg	;allow set & clear commands to work

	return

;--------------------------------

CkWork				;alternative main loop, callable every 4ms from anywhere

	call	CkDisc		;check whats happening at the edge

	btfss	TMR1H, 7	;check for 1 second flag
	return			;no 1 second flag so return

	call	CkTod		;update TOD & set flags for time related things to do

	btfsc	flgs, vpmflg	;test for VPM flag
	call	SendVPM		;yes - so send VPM

	btfsc	flgs, ivlflg	;test for new interval flag
	call	DoIvl		;yes - so do next interval

	return

;-----------------------------------------------------------------------
; Main Program
;-----------------------------------------------------------------------

Main				;start of Hermes

	call	GetPrams	;clear ram & set defaults
	call	Init32khz	;initialize TOD & wait 1 second
	call	SetupIo		;setup I/O ports
	call	InitAdc		;initialize the Adc
	call	RestEp		;restore operational parameters (TDO, spv, mpi, ppt, wpt, flgs) from E^2

	movlw	2
	call	DoBlink		;show processor working

	call	DoCal		;setup to allow self calibration at the edge
	call	SetDct		;setup time for next disc edge check

;--------------------------------

MainLoop			;we do this loop until battery power is lost

	Ck37khz			;switch to 37khz mode

cktime
	movfw	TMR1L		;load timer 1 low byte
	andlw	dctmsk		;and out don't care bits
	subwf	dctnxt, w	;is it time to do some work
	skpz			;yes - so do it
	goto	cktime		;no - so goto check time again

	Ck4mhz			;switch to 4mhz mode

	call	CkDisc		;check whats happening at the edge
	call	CkComms		;check and handle inward comms

	btfss	TMR1H, 7	;check for 1 second flag
	goto	MainLoop	;not 1 second flag so go slow

	call	CkTod		;update TOD & set flags for time related things to do

	btfsc	flgs, vpmflg	;test for VPM flag
	call	SendVPM		;yes - so send VPM

	btfsc	flgs, ivlflg	;test for new interval flag
	call	DoIvl		;yes - so do next interval

	goto	MainLoop	;go to do it again and again..............

;-----------------------------------------------------------------------
; program end
;-----------------------------------------------------------------------

	end


