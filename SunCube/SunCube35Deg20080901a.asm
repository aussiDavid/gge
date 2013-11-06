;***********************************************************************
;                          SunCube2.ASM                                ;
;                                                                      ;
;           This pogram & the system design is copyright               ;
;                                                                      ;
;                          Greg Watson                                 ;
;                              2007                                    ;
;                                                                      ;
;                      All rights reserved                             ;
;                                                                      ;
;***********************************************************************

;-----------------------------------------------------------------------
; Set up for CPU type & power on configuration
;-----------------------------------------------------------------------

	LIST P=16C771, R=DEC, f=INHX32

	#include p16c771.inc

	__CONFIG _CP_OFF & _BODEN_OFF & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT

;-----------------------------------------------------------------------
; Constants
;-----------------------------------------------------------------------

ram0	equ	0x20		;start of bank 0 ram
ramint	equ	0X80-7		;variables in bank insensitive ram

kwh10	equ	0x4000		;demo meter disk revs for 10kwhs in packed bcd
rbytes	equ	2		;revs / 10kwh xx xx

mpicst	equ	1		;minutes per interval
iprcst	equ	3		;intervals per report

tbytes	equ	2		;meter type xx xx

ser1	equ	0x64
ser2	equ	0x27
ser3	equ	0x10		;meter serial # in packed bcd
mbytes	equ	3		;meter number xx xx xx xx

gsm1	equ	0x04
gsm2	equ	0x38
gsm3	equ	0x80
gsm4	equ	0x44
gsm5	equ	0x97		;demo gsm phone # in packed bcd
pbytes	equ	5		;phone number xx xx xx xx xx

b9600	equ	256-104		;counts to make t0 overflow at 9600 baud

;-----------------------------------------------------------------------
; Port A defines
;-----------------------------------------------------------------------

#define	Opt	0		;Ir opto input bit (for Adc)
#define OptPort	PORTA		;Ir opto input port

#define	Mb	4		;open collector MBus comms line
#define	MbPort	PORTA		;Mbus port

#define AnalA	b'00000001'	;1=analog input

#define	DirA	b'00010001'	;0=output, 1=input
#define IntA	b'00010000'	;initial port A data

;-----------------------------------------------------------------------
; Port B defines
;-----------------------------------------------------------------------

#define Opo	0		;test opto input bit (ttl level)
#define OpoPort	PORTB		;test opto input port

#define	Led	1		;visual led bit
#define	LedPort	PORTB		;visual led port

#define	Rd	2		;comms receive data line
#define RdPort	PORTB		;comms receive data port

#define	Td	3		;comms transmit data line (initially input)
#define	TdPort	PORTB		;comms transmit data port
#define TdDir	TRISB		;comms port direction

#define	Ir	4		;Ir led bit
#define	IrPort	PORTB		;Ir led port

#define DirB	b'00001101'	;0=output, 1=input
#define	IntB	b'00000000'	;initial port B data

;-----------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------

SelMsg 	macro msgbeg, msgend

	movlw	high (msgbeg)
	movwf	pgadr		;load pgadr ms byte with address of first location

	movlw	low (msgbeg) 
	movwf	pgadr+1		;load pgadr ls byte with address of first location

	movlw	low (msgend-msgbeg)
	movwf	pglen		;load number of packed byte pairs in string
	endm

;-----------------------------------------------------------------------
; Variable Eeprom storage area (262,144 bits / 32,768 bytes for 24LC256)
;
; Arranged as 256 x 128 byte blocks
;  Per block:
;   32 bytes of general data, time stamps, etc
;   48 x 2 byte (16 bits) 30 minute daily interval data
;    15:1 = tamper during interval flag
;    14:1 = power lost during interval flag
;    13:1 = power restored during interval flag
;    12:13 = tick count from disc rotation (max = 8,191 ticks per 30 minutes)
;
; The first block is reserved for system use.
; The next 255 blocks are formed into a circular buffer for daily (24 hour) interval storage
;-----------------------------------------------------------------------

	org	0x0000	;start of Hermes reserved block

estart	res	96	;copy of ram variables, same addresses, just different physical storage
eiold	res	2	;address of oldest interval
ebold	res	2	;address of oldest block
eicur	res	2	;address of current interval
ebcur	res	2	;address of current block
eiavil	res	2	;address of next available interval
ebavil	res	2	;address of next available block
esnd	res	2	;address of next interval to download
ebnd	res	2	;address of next block to download

	org	0x0080	;address 128, start of daily interval storage area

egen	res	32	;32 bytes for general storage, time stamps, etc
eint	res	96	;96 bytes of 2 x 48 intervals
 
;-----------------------------------------------------------------------
; Variable ram storage area
;-----------------------------------------------------------------------

	org	ram0	;variables in ram bank 0

;------------------------
; Meter related variables
;------------------------

rp10kwh	res	rbytes	;revs / ticks per 10kwh xx xx in packed bcd
mnum	res	mbytes	;meter serial number xx xx xx in packed bcd
;mtype	res	tbytes	;meter type xx xx xx in packed bcd

;------------------------
; Interval variables
;------------------------

mpi	res	1	;minutes per interval
ipr	res	1	;intervals per report
i1	res	iprcst	;array to store interval data until I get the eeprom working
iptr	res	1	;pointer to current interval
imin	res	1	;minutes in interval downcounter
dodl	res	1	;flag to indicate download when period full

;------------------------
; Phone number storage
;------------------------

phgsm	res	pbytes	;phone # xxxx xxx xxx for install report in packed bcd
phpstn	res	pbytes	;phone # (xx) xxxx xxxx for interval data download
phevnt	res	pbytes	;phone # (xx) xxxx xxxx for event report

;------------------------
; Comm variables
;------------------------

baud	res	1	;baud delay loop counter
bitcnt	res	1	;bits to send counter
commch	res	1	;rotate right into carry char to send
cksum	res	1	;xor check sum of Mbus message
nkphb	res	1	;Nokia phone book index

;------------------------
; Eeprom variables
;------------------------

eplgn	res	1	;number of bytes to read from / write to the eeprom
epbuf	res	2	;eeprom r/w 2 byte buffer
epadr	res	2	;eeprom r/w 16 bit address

;------------------------
; Delay loop counters
;------------------------

dly1ms	res	1	;1ms delay loop counter
dlyxms	res	1	;x 1ms delay loop counter
dlyx100	res	1	;x 100ms delay loop counter

;------------------------
; Various common temp variables
;------------------------

tempbcd	res	1	;used by SendBcd
temp	res	1	;used by BtoBcd, MarkIt
temp1	res	1	;used by BtoBcd

;------------------------
; Black flag & other opto processing variables
;------------------------

bffcnt	res	1	;black flag found counter
;blkchr	res	1	;used to count #s sent to comms in Adc debug

bkcnt	res	1	;visual led blink counter

;------------------------
; 16 bit math variables
;------------------------

ACCaLO  res     1
ACCaHI  res     1	;high & low of ACCa
ACCbLO  res     1
ACCbHI  res     1	;high & low of ACCb

;------------------------
; TOD variables
;------------------------

day	res	1
i1day	res	1	;date stamp of first interval day
month	res	1
i1mth	res	1	;date stamp of first interval month
yearhi	res	1
i1yrhi	res	1	;date stamp of first interval year high
yearlo	res	1
i1yrlo	res	1	;date stamp of first interval year low

hour	res	1
i1hr	res	1	;date stamp of first interval hour
minute	res	1
i1min	res	1	;date stamp of first interval minute
second	res	1	
i1sec	res	1	;date stamp of first interval second

dmth	res	12	;days+1 in the month array for this year

t1tick	res	1	;1/2 second heart beat flag
tptr	res	1	;time pointer

;-----------------------------------------------------------------------
; Variables in bank insensitive ram
;-----------------------------------------------------------------------

	org	ramint	;variables in bank insensitive ram

;------------------------
; Interrupt variables
;------------------------

savewi	res	1	;save w during int handler storage
savest	res	1	;save status during int handler storage

;------------------------
; Program memory read variables
;------------------------

pglen	res	1	;length of string stored in program memory
pgadr	res	2	;16 bit program memory read address
pgd	res	2	;16 bit program memory data

;-----------------------------------------------------------------------
; Power on and interrupt handlers
;-----------------------------------------------------------------------

	org	0x0000		;power on reset entry point <<<<<<<<<<<<<<<

	goto	Main		;go to start of main code

;--------------------------------

	org	0x0004		;interrupt entry point <<<<<<<<<<<<<<<<<

	movwf	savewi		;save w

	movfw	STATUS		;load status in w
	movwf	savest		;save status flags

	clrf	STATUS		;make sure we are in bank 0

	movlw	low ((((65536*8)-500000)/8)-1)
	movwf	TMR1L		;reload t1 lsb with lsb of 500ms heart beat

	movlw	high ((((65536*8)-500000)/8)-1)
	movwf	TMR1H		;reload t1 msb with msb of 500ms heart beat

	bcf	PIR1, TMR1IF	;reset t1 overflow flag
	incf	t1tick, f	;inc 1/2 second heart beat, checked & cleared by CkTod

	movfw	savest		;load saved status flags
	movwf	STATUS		;restore status flags

	swapf	savewi, f	;swap nibbles to prepare for next nibble swap into w
	swapf	savewi, w	;restore w without effecting status flags
	retfie			;go back to where we came from with interrupts enabled

;-----------------------------------------------------------------------
; Time Procedures
;-----------------------------------------------------------------------

CkTod				;update TOD if needed

	btfss	t1tick, 1	;is bit 1 set (only occurs every two t1 1/2 second tod interrupts)
	return			;no - so just exit

	clrf	t1tick		;clear t1 int counter & inc TOD by 1 second

	incf	second, f	;inc second counter
	movlw	60		;load max second + 1 (0 - 59)
	subwf	second, w	;sub and put result in W
	skpz			;skip next op if second = 60
	return			;no - so go back to where we were
	clrf	second		;yes - so clear second

	incf	minute, f	;now inc minute count
	decf	imin, f		;dec minutes in interval (checked & set by CkNi)
	movlw	60		;load max minute + 1 (0 - 59)
	subwf	minute, w	;sub and put result in w
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

;-----------------------------------------------------------------------
; Interval procedures
;-----------------------------------------------------------------------

ClrIvl				;clear interval storage locations & setup other interval parameters

	movlw	i1		;load address of first interval
	movwf	FSR		;store in indirect address
	movwf	iptr		;store in interval pointer

	movfw	ipr		;load intervals per report
	movwf	temp		;store in temp down counter

clriv
	clrf	INDF		;clear interval
	incf	FSR, f		;inc to next interval
	decfsz	temp, f		;dec intervals to go & test for z
	goto	clriv		;no - so do it again

	movfw	mpi		;load minutes in interval
	movwf	imin		;store in interval minute downcounter
				;fall through to mark first interval time

;--------------------------------

MarkI1t				;record period start time

	movlw	day		;load address of day
	movwf	FSR		;store pointer to start of TOD array

	movlw	((i1sec-day)+1)/2
	movwf	temp		;store length of TOD array

markag
	movfw	INDF		;load TOD variable
	incf	FSR, f		;inc to next address
	movwf	INDF		;store it as first interval time
	incf	FSR, f		;inc again to get next TOD byte
	decfsz	temp, f		;dec counter & test for 0
	goto	markag		;no - so do it again

	return			;yes - so exit

;--------------------------------

CkNi				;check if we need a new interval

	movfw	imin		;load w with interval minutes to test if 0
	skpz			;skip next op if imin = 0
	return			;w <> 0 - so exit

	incf	iptr, f		;w = 0 - so inc interval storage pointer to next location

	movfw	mpi		;load minutes per interval
	movwf	imin		;reinitialize minutes for this interval

	return

;--------------------------------

CkPfull				;check if period full & if we do a data download

	movfw	iptr		;load iptr
	sublw	i1+iprcst	;sub max address
	skpz			;skip next op if result = 0
	return			;nz - so just return

	btfsc	dodl, 0		;z - so test if auto period download requested
	call	SendPwr		;yes - so send period power report
	goto	ClrIvl		;data sent - so clear old data & setup for new period

;-----------------------------------------------------------------------
; Delay procedures
;-----------------------------------------------------------------------

Delay1ms			;delay for 1 ms

	movlw	(1000-6)/4	;1ms delay loop value, 6us (call, setup, return), 4us loop
	movwf	dly1ms		;set loop cnt to delay 1ms

do1ms
	nop			;nop to make major loop 4us @ 4mhz
	decfsz	dly1ms, f	;dec loop count, skip if result = 0
	goto	do1ms		;no - so go do it again
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

;--------------------------------

Delay1sec			;delay 1 second

	movlw	10		;load 10 * 100ms delay

;--------------------------------

Delayw100ms			;delay for w * 100ms

	movwf	dlyx100		;store w (100 ms delay loop count)

dox100ms
	call	Delay100ms	;do 100ms delay
	decfsz	dlyx100, f	;dec 100ms loop counter & test for zero
	goto	dox100ms	;no - so do it again
	return			;yes - so exit

;---------------------------------

Delaybaud			;delay for 9600 baud rate (104 us)

	movlw	(104-14)/3	;load delay for 9600 baud
	movwf	baud		;store it in baud loop counter

dob
	decfsz	baud, f		;dec loop counter & test for zero
	goto	dob		;no - so do it again
	return			;yes - exit

;---------------------------------

Delayhbaud			;delay for 1/2 9600 baud rate (72 us)

	movlw	(72-14)/3	;load delay for 1/2 9600 baud time
	movwf	baud		;store it in baud loop counter

dohalfb
	decfsz	baud, f		;dec loop counter & test for zero
	goto	dohalfb		;no - so do it again
	return			;yes - exit

;-----------------------------------------------------------------------
; Eeprom procedures
;-----------------------------------------------------------------------

Inc16adr			;inc 16 bit address

	incf	epadr, f	;inc lsb of address
	skpnz			;if result <> 0, skip next op
	incf	epadr+1, f	;inc msb
	return

;--------------------------------

WEp				;write byte/s to the eprom, data = epbuf, length = eplgn, dest = epadr

	return

;--------------------------------


REp				;read bytes/s from the eeprom into epbuf, length = eplgn, source = epadr

	return

;-----------------------------------------------------------------------
; Message formatting & Comms procedures
;-----------------------------------------------------------------------

SndOnline			;send initial "On-Line message"

	bsf	STATUS, RP0	;select bank 1
	bcf	TdDir, Td	;make TD line output
	bcf	STATUS, RP0	;select bank 0

	call	Delay100ms	;delay for 100ms for Td to settle down

	SelMsg	Text, Textend	;select Gsm modem SMS text mode
	call	SendGsm		;send select text mode command

	call	Delay1sec	;delay 1 second for GSM module to respond to mode selection

	movlw	day		;select TOD as time to send
	call	SendHdr		;send common header with time array to use in w

	SelMsg	OL, OLend
	call	SendGsm		;send " Online " message

	movlw	0x1a		;send ctrl z to finish SMS message
	goto	Send8n		;do it

;--------------------------------

CkInComms			;check for inward comms

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

SendMtr				;send meter number stored as packed bcd in the bytes of mnum

	movlw	mnum		;load start address of meter number
	movwf	FSR		;set indirect pointer to start of meter number
	movlw	mbytes		;load bytes in meter number
	movwf	temp1		;set bytes to send

	goto	sendphn		;use sendphn to send meter number

;--------------------------------

SendPhGsm			;send GSM phone number stored as packed bcd in the bytes of phgsm

	movlw	phgsm		;load start address of GSM phone number
	movwf	FSR		;set indirect pointer to start of meter number
	movlw	pbytes		;load bytes in phone number
	movwf	temp1		;set bytes to send

sendphn
	swapf	INDF, w		;load first byte & swap nibbles 
	call	SendRight	;send left hexade as numeric ascii
	movfw	INDF		;load byte again
	call	SendRight	;send right hexade as numeric ascii
	incf	FSR, f		;inc to next byte
	decfsz	temp1, f	;dec & test if more bytes to go
	goto	sendphn		;yes - so do it

	goto	SendFd		;no - so send field delimiters

;--------------------------------

SendCmsg			;send start of GSM SMS message

	SelMsg	Cmsg, Cmsgend	;select "AT+CMSG="
	goto	SendGsm		;send it

;--------------------------------

SendFd				;send field delimiters ", " or " "

;	movlw	","		;load ","
;	call	Send8n		;send it
	movlw	" "		;load " "
	goto	Send8n		;send it

;--------------------------------

GetNt				;get next indirect date / time

	movfw	INDF		;load next time hack
	incf	FSR, f		;
	incf	FSR, f		;inc fsr to next time array element
	return			;return with time element in w

;--------------------------------

SendDate			;send the date as "dd/mm/yyyy "

	call	GetNt		;load day
	call	SendBcd		;send binary in w as 2 numeric bcds to comms
	movlw	"/"		;load "/"
	call	Send8n		;send it

	call	GetNt		;load month
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	movlw	"/"		;load "/"
	call	Send8n		;send it

	call	GetNt		;load year high
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	call	GetNt		;load year low
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	goto	SendFd		;send field delimiters

;--------------------------------

SendTime			;send the time as "hh:mm "

	call	GetNt		;load hour
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	movlw	":"		;load ":"
	call	Send8n		;send it

	call	GetNt		;load minute
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	movlw	":"		;load ":"
	call	Send8n		;send it

	call	GetNt		;load second
	call	SendBcd		;send binary in w as 2 numeric bcds to comms

	goto	SendFd		;send field delimiters

;--------------------------------

SendHdr				;send SMS text msg common header information
				;"AT+CMSG=pppppppp\0x0dEtsa mmmmmm 400:mpi:ipr:wh"

	movwf	tptr		;store time array address in w until needed

	call	SendCmsg	;send SMS text msg command
	call	SendPhGsm	;send GSM phone number

	movlw	0x0d
	call	Send8n		;send cr to end phone number section and enter message section

	SelMsg	Etsa, Etsaend
	call	SendGsm		;send "Etsa"
	call	SendFd		;send field delimiters

	call	SendMtr		;send meter number
;
;	movfw	tptr		;load time array address
;	movwf	FSR		;store to indirect address
;
;	call	SendDate	;send date 
;	call	SendTime	;send time
;
	movlw	"4"
	call	Send8n
	movlw	"0"
	call	Send8n
	movlw	"0"
	call	Send8n
	movlw	":"
	call	Send8n		;send revs / 1 kwh

	movfw	mpi		;load minutes in interval
	call	SendBcd		;send period

	movlw	":"		;load ":"
	call	Send8n		;send it

	movfw	ipr		;load intervals in report
	call	SendBcd		;send report length

	movlw	":"		;load ":"
	call	Send8n		;send it

	movlw	"w"		;
	call	Send8n		;send "w"
	movlw	"h"		;
	goto	Send8n		;send "h"

;--------------------------------

SendPwr				;send the power in the intervals as:
				;Etsa mmmmmmmm dd/mm/yyyy hh:mm:ss mpi:ipr:wh xx xx xx xx xx
				;------------------------------------------------------

	movlw	i1day		;select first interval time as time to send
	call	SendHdr		;send header information

	movfw	ipr		;load number of intervals to report
	movwf	dlyxms		;save interval counter

	movlw	i1		;load addess of interval 1
	movwf	FSR		;load pointer with address of first interval

pwra
	call	SendFd		;send field delimiters
	movfw	INDF		;load value in first interval
	call	Multw25		;convert ticks into wh (interval ticks * 2.5 = wh)
	call	SendBcd		;convert binary in w into 2 packed bcds, then send as 2 ascii
	incf	FSR, f		;inc memory pointer to next byte
	decfsz	dlyxms, f	;dec & test if more intervals to send?
	goto	pwra		;yes - so go to do it

	movlw	0x1a		;no - so send ctrl z to finish SMS message
	goto	Send8n		;do it

;--------------------------------	

SendGsm				;send rom text string to comms

	call	ReadPgm		;get next 2 bytes of message into pgd & inc pgadr

	rlf	pgd+1, w	;load carry with 7:1 of ls byte
	rlf	pgd, w		;shift carry into 0:1 ms byte & leave in w
	bcf	pgd+1, 7	;reset 7:1 of ls byte
	call	Send8n		;send ms byte (in w) to comms

	movfw	pgd+1		;load ls byte
	call	Send8n		;send ls byte (in w) to comms

	decfsz	pglen, f	;dec byte pairs to send & test for zero
	goto	SendGsm		;no - do it again
	return			;yes - so exit

;--------------------------------	

SendNok				;send rom text string to Nokia

	call	ReadPgm		;get next 2 bytes of message into pgd & inc pgadr

	rlf	pgd+1, w	;load carry with 7:1 of ls byte
	rlf	pgd, w		;shift carry into 0:1 ms byte & leave in w
	bcf	pgd+1, 7	;reset 7:1 of ls byte
	call	Send8e		;send ms byte (in w) to Nokia

	movfw	pgd+1		;load ls byte
	call	Send8e		;send ls byte (in w) to Nokia

	decfsz	pglen, f	;dec byte pairs to send & test for zero
	goto	SendNok		;no - do it again
	return			;yes - so exit

;---------------------------------

SendBcd				;convert binary in w into 2 packed bcd nibbles & send to comms

	call	BtoBcd		;convert to 2 packed bcds in w
	movwf	tempbcd		;save result
	swapf	tempbcd, w	;load swapped nibbles in w
	call	SendRight	;send ms nibble
	movfw	tempbcd		;load result again & fall through to SendRight

;--------------------------------

SendRight			;convert nibble in lsb of w into ascii and send it down the line

	andlw	0x0f		;zap w[7:4] to 0 (ms nibble)
	iorlw	0x30		;make it a ascii number by oring in 0x30 & fall through to Send8n

;---------------------------------

Send8n				;sent byte in w as 8N RS232 (low = 1)

	movwf	commch		;save byte to be sent

	movlw	8
	movwf	bitcnt		;init shift count

	bsf	TdPort, Td	;set Td high / spacing / 0 for start bit
	call	Delaybaud

next8n
	rrf	commch, f	;rotate right lsb into carry
	btfss	STATUS, C	;test if carry set
	goto	dozero8n	;no - so send 0
	bcf	TdPort, Td	;yes - so put 1 on TD line
	goto	dobaud8n	;goto baud delay

dozero8n
	bsf	TdPort, Td	;put 0 on TD line

dobaud8n
	call	Delaybaud	;delay for 1 baud time

	decfsz	bitcnt, f	;test if more bits to send
	goto	next8n		;yes - so do it again

	bcf	TdPort, Td	;no - so set td low / marking / 1 for stop bit
	goto	Delaybaud	;delay for 1 baud time

;---------------------------------

Send8e				;send byte in w as 8E Nokia MBus (high = 1)

	movwf	commch		;save w (byte to be sent)
	xorwf	cksum, f	;update checksum with xor of data in w

	movlw	8
	movwf	bitcnt		;init shift count for 8 data bits to generate parity
	clrf	temp		;clear bit counter

calcpar
	rrf	commch, f	;rotate 0:1 into carry
	btfsc	STATUS, C	;test if carry not set
	incf	temp, f		;carry set - so inc bit counter
	decfsz	bitcnt, f	;dec & test bits to test
	goto	calcpar		;not zero - so more bits to test

	rrf	commch, f	;1 more rotate right to get commchr back to original

	movfw	temp		;load bit count
	rrf	temp, f		;rotate 0:1 of bit count (even parity) into carry

	movlw	9
	movwf	bitcnt		;init shift count for 9 bits, carry = even parity bit

	bcf	MbPort, Mb	;set Mbus Td low / spacing / 0 for start bit
	call	Delaybaud

next8e
	rrf	commch, f	;rotate right lsb into carry
	btfss	STATUS, C	;test if carry set
	goto	dozero8e	;no - so send 0
	bsf	MbPort, Mb	;yes - so put 1 on Mbus TD line
	goto	dobaud8e	;goto baud delay

dozero8e
	bcf	MbPort, Mb	;put 0 on Mbus TD line

dobaud8e
	call	Delaybaud	;delay for 1 baud time

	decfsz	bitcnt, f	;test if more bits to send
	goto	next8e		;yes - so do it again

	bsf	MbPort, Mb	;no - so set td high / marking / 1 for stop bit
	goto	Delaybaud	;delay for 1 baud time

;---------------------------------

R8e				;return 8E byte from Nokia MBus (high = 1) in w

	call	Delayhbaud	;delay for 1/2 baud time
	setc			;set carry to flag possible rec error

	btfsc	RdPort, Rd	;make sure Rd is still low
	return			;no - so exit with carry set

	movlw	8
	movwf	bitcnt		;set bit counter to receive 8 bits
	clrf	commch		;clear comm char
	clrc			;clear carry

r8ea
	rrf	commch, f	;rotate partial received comm char right one bit
	call	Delaybaud	;yes - so delay full baud to get into middle of next bit
	btfsc	RdPort, Rd	;test status of Rd
	bsf	commch, 7	;set msb of comm ch
	decfsz	bitcnt, f	;test if more bits to receive
	goto	r8ea		;yes - so do it

	call	Delaybaud	;delay for middle of parity bit
	call	Delaybaud	;delay for middle of stop bit
	call	Delayhbaud	;delay for end of stop bit

	movfw	commch		;load w with received char
	return
	
;---------------------------------

R8n				;return 8N byte from RS232 (low = 1) in w

	call	Delayhbaud	;delay for 1/2 baud time
	setc			;set carry to flag possible rec error

	btfss	RdPort, Rd	;make sure Rd is still high
	return			;no - so exit with carry set

	movlw	8
	movwf	bitcnt		;set bit counter to receive 8 bits
	clrf	commch		;clear comm char
	clrc			;clear carry

r8na
	rrf	commch, f	;rotate partial received comm char right one bit
	call	Delaybaud	;yes - so delay full baud to get into middle of next bit
	btfss	RdPort, Rd	;test status of Rd
	bsf	commch, 7	;set msb of comm ch
	decfsz	bitcnt, f	;test if more bits to receive
	goto	r8na		;yes - so do it

	call	Delaybaud	;delay for middle of parity bit
	call	Delaybaud	;delay for middle of stop bit
	call	Delayhbaud	;delay for end of stop bit

	movfw	commch		;load w with received char
	return

;-----------------------------------------------------------------------
; Nokia Mbus phone book download procedures
;-----------------------------------------------------------------------

DlPb				;download the Nokia's phone book

	clrf	nkphb		;set to first index
	call	SndPbr		;send phone book request
	call	GetPb		;read phone book data sent by the Nokia
 	return

;--------------------------------

GetPb				;read requested phone book data

	return

;--------------------------------

SndPbr				;send request to the Nokia for the phone number stored at location in w

	clrf	cksum		;initialize check sum
	movwf	nkphb		;save phone book index

	SelMsg	PhMsg, PhMsgend
	call	SendNok		;send header to Nokia

	movlw	0x03		;read phone book command
	call	Send8e		;send it to the Nokia

	movwf	nkphb		;load phone book index
	call	Send8e		;send it to the Nokia

	movlw	0x00
	call	Send8e

	movlw	0x01		;load seq number
	call	Send8e		;send it to the Nokia

	movfw	cksum		;load checksum byte
	call	Send8e		;send it to the Nokia

	return

;-----------------------------------------------------------------------
; Led procedures
;-----------------------------------------------------------------------

LedOn
	bsf	LedPort, Led	;turn visual led on
	return

;---------------------------------

LedOff
	bcf	LedPort, Led	;turn visual led off
	return

;--------------------------------

IrOn
	bsf	IrPort, Ir	;turn IR led on
	return

;---------------------------------

IrOff
	bcf	IrPort, Ir	;turn IR led off
	return

;--------------------------------

DoBlink				;blink the led the number of times in w

	movwf	bkcnt		;save blink count

blinkagn
	call	LedOn		;on
	call	Delay100ms	;wait 100ms

	call	LedOff		;off
	call	Delay100ms	;wait 100ms

	decfsz	bkcnt, f	;dec blink count, is it zero?
	goto	blinkagn	;no - so blink them again

	Return			;yes - so exit

;-----------------------------------------------------------------------
; Adc procedures
;-----------------------------------------------------------------------

InitAdc				;initialize the Adc

	clrf	bffcnt		;initialize black flag found counter to zero

	bsf	STATUS, RP0	;select bank 1
	movlw	0x80		;right justified data, vref = AVdd/AVss
	movwf	ADCON1
	bcf	STATUS, RP0	;select bank 0
	return

;--------------------------------

DoAdc				;read current Opto level

	movlw	0x41		;Fosc/8, channel 0, done, adc enabled
	movwf	ADCON0		;enable Adc to sample input line
	nop			;
	nop			;
	nop			;3us delay to charge input cap
	bsf	ADCON0, GO	;start A/D conversion after acquisition delay

waitadc
	btfsc	ADCON0, GO	;Wait for "GO" to be reset by adc complete
	goto	waitadc		;no - so go to wait for adc complete
	return			;exit

;--------------------------------

;ACCbComms			;send ACCb to comms as string of #s
;
;	movf	ACCbHI, w
;	call	SendByte	;send msb of 16 bit difference to comms
;	movf	ACCbLO, w
;
;	movf	bffcnt, w
;	btfsc	STATUS, Z	;test bffcnt = 0
;	goto	nocomms		;yes - so skip sending idle
;	movwf	blkchr		;no - store bffcnt in blkchr
;
;sendgraph
;	movlw	'#'
;	call	SendByte	;send lsb of 16 bit difference to comms
;	decfsz	blkchr, f	;test if * sent = bffcnt + 1
;	goto	sendgraph	;no - so send * again
;
;	movlw	0x0d
;	call	SendByte	;send cr
;	movlw	0x0a
;	call	SendByte	;send lf
;
;nocomms
;	return

;--------------------------------

CkDisc				;main disc edge reader. Update interval tick if black flag just passed

	movlw	3
	call	Delaywms	;delay 3ms for the photo darling to respond

	call	DoAdc		;get opto value before led turned on

	movfw	ADRESH		;load Adc result ms byte
	movwf	ACCbHI		;store ms byte

	bsf	STATUS, RP0	;select bank 1
	movfw	ADRESL		;load Adc result ls byte
	bcf	STATUS, RP0	;select bank 0
	movwf	ACCbLO		;store ls byte

	call	IrOn		;turn IR led on to illuminate the disc edge

	movlw	3
	call	Delaywms	;delay 3ms for the photo darling to respond

	call	DoAdc		;get opto value with led turned on (should be smaller due to more light)

	call	IrOff		;turn IR led off to save power

	movfw	ADRESH		;load Adc result ms byte
	movwf	ACCaHI		;store ms byte

	bsf	STATUS, RP0	;select bank 1
	movfw	ADRESL		;load Adc result ls byte
	bcf	STATUS, RP0	;select bank 0
	movwf	ACCaLO		;store ls byte

	call	DblSub		;ACCb - ACCa > ACCb

	btfsc	ACCbHI, 7	;test if msb >= 0x80
	incf	ACCbHI, f	;yes - so inc msb to stop 'ff'

;	call	ACCbComms	;send result to comms for debug

	btfsc	ACCbHI, 3	;test result >= 1/2 Vcc
	goto	itslight	;no - so goto handle light

	btfsc	bffcnt, 3	;yes - so is black flag found counter = 8?
	goto	LedOn		;show the world we got 8 black cycles in a row & exit

	incf	bffcnt, f	;no - so inc black flag found counter
	return			;no valid black flag yet - so return

itslight
	movf	bffcnt, f	;set zero flag if black flag found counter = 0
	skpnz			;is black flag found counter = 0?
	goto	showlight	;yes - so ck if led on (black flag just passed)

	decf	bffcnt, f	;no - so dec black flag found counter
	return			;no valid black flag yet - so return

showlight
	btfss	LedPort, Led	;test if led on
	return			;no - so just return
	
	call	LedOff		;yes - so turn led off as black flag has passed

	movfw	iptr		;load current interval address
	movwf	FSR		;store current interval address to indirect pointer
	incf	INDF, f		;inc current interval tick count
	return			;return

;--------------------------------

CkPfail				;check & log power failures (loss of 50 hz EM field)

	return

;--------------------------------

CkTamper			;check & log tampering (loss of optical quality)

	return

;-----------------------------------------------------------------------
; Read program memory procedures
;-----------------------------------------------------------------------

ReadPgm				;load pgd from pgadr & inc pgadr+1 

	bsf	STATUS, RP1	;select bank 2

	movfw	pgadr		;load w with pgadr ms byte
	movwf	PMADRH		;store it

	movfw	pgadr+1		;load w with pgadr ls byte
	movwf	PMADRL		;store it

	bsf	STATUS, RP0	;select bank 3
	bsf	PMCON1, RD	;do the read
	bcf	STATUS, RP0	;select bank 2
	nop			;null command, not executed as pgm memory read occurs

	movfw	PMDATH		;load ms byte
	movwf	pgd		;store ms byte

	movfw	PMDATL		;load ls byte
	movwf	pgd+1		;store ls byte	

	bcf	STATUS, RP1	;select bank 0
	
	incf	pgadr+1, f	;inc pgadr ls byte
	skpnz			;skip next op if result <> 0
	incf	pgadr, f	;yes - so inc pgadr ms byte
	return

;-----------------------------------------------------------------------
; math procedures
;-----------------------------------------------------------------------

DblSub				;16 bit sub (ACCb - ACCa > ACCb)

	call	NegACCa		; At first negate ACCa; Then add

;--------------------------------

DblAdd				;16 bit add (ACCb + ACCa > ACCb)

	movf    ACCaLO, W
	addwf   ACCbLO, F       ;add lsb
	btfsc   STATUS, C       ;add in carry
	incf    ACCbHI, F
	movf    ACCaHI, W
	addwf   ACCbHI, F       ;add msb
	return

;--------------------------------

NegACCa				;16 bit negate (-ACCa > ACCa)

	comf    ACCaLO, F
	incf    ACCaLO, F
	btfsc   STATUS, Z
	decf    ACCaHI, F
	comf    ACCaHI, F
	return

;--------------------------------

Multw25				;multiply binary in w by 2.5 and leave in w

	clrc			;clear carry
	movwf	temp		;store original w
	rlf	W, w		;rotate left binary in w (mult * 2)
	clrc			;clear carry
	rrf	temp, f		;rotate right original binary in w (mult * 0.5)
	skpnc			;skip next op if carry not set
	incf	temp, f		;carry set - so inc temp to cause rounding on 0.5
	addwf	temp, w		;add two results together in w to get mult w * 2.5
	return

;-----------------------------------------------------------------------
; Opto alignment procedures
;-----------------------------------------------------------------------

TestOpto			;read opto level and set Td to inverse

	call	Delay1ms	;delay 1 ms
	btfss	OpoPort, Opo	;is opto level high (little reflection)
	goto	tdhigh		;no - so make Td high
	bcf	TdPort, Td	;yes - so make Td low
	return			;

tdhigh
	bsf	TdPort, Td	;make Td high for Opto = low (on disc edge)
	return			;

;-----------------------------------------------------------------------
; Initialization procedures
;-----------------------------------------------------------------------

SetupIo				;setup the I/O ports

	movlw	IntA
	movwf	PORTA		;set initial Port A output bits

	movlw	IntB
	movwf	PORTB		;set initial Port B output bits

	bsf	STATUS, RP0	;setup bank 1 registers

	movlw	DirA
	movwf	TRISA		;initialize Port A data direction register

	movlw	DirB
	movwf	TRISB		;initialize Port B data direction register

	movlw	AnalA
	movwf	ANSEL		;select analog input channel

	bcf	STATUS, RP0	;back to bank 0
	return

;--------------------------------
; setup the TOD, days in month lookup table and t1 / clock interrupt
; t1 is used to generate a interrupt every 1/2 second and incs t1tick
; CkTod updates the tod from finding bit 1 of t1tick set (every 2 x 1/2 second interrupts)
; CkTod adjust days in Feb for leap years (year mod 4 = 0) and is y3k compatiable
;--------------------------------

SetupTime			;setup time parameters

	movlw	20		;setup TOD initial values
	movwf	yearhi		;set high year to 20
	movlw	02
	movwf	yearlo		;set low year to 02 (2002)
	movlw	06
	movwf	month		;set month to May
	movlw	07
	movwf	day		;set day to 4th
	movlw	09
	movwf	hour		;set hour to 05:
	movlw	14
	movwf	minute		;set minute to :06:
	movlw	00
	movwf	second		;set second to :07

;--------------------------------

	movlw	31+1		;setup days in month array
	movwf	dmth		;load days+1 in Jan
	movlw	28+1
	movwf	dmth+1		;load days+1 in Feb (2002 is not mod 4 = 0 so it is not a leap year)
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

;--------------------------------
				;setup t1 for 1/2 second heart beat interrupt
	movlw	low ((((65536*8)-500000)/8)-1)
	movwf	TMR1L

	movlw	high ((((65536*8)-500000)/8)-1)
	movwf	TMR1H		;load t1 with 500ms heart beat

	movlw	b'00110001'	;set 1:8 prescaler, clock = internal tosc/4, count
	movwf	T1CON		;load t1 control with setup above & start counting

	clrf	t1tick		;clear 1/2 second heart beat flag (inc by t1 int routine)

	bcf	PIR1, TMR1IF	;reset t1 overflow flag

	bsf	INTCON, GIE	;enable general interrupts 
	bsf	INTCON, PEIE	;enable peripheral interrupts, just t1 for now

	bsf	STATUS, RP0	;select bank 1
	bsf	PIE1, TMR1IE	;enable t1 overflow interrupt
	bcf	STATUS, RP0	;select bank 0
	return

;--------------------------------
; Alignment & test code
; Download programming data from the phone book memory of the attached Nokia GSM phone via it's Mbus interface
; Generate a PWM signal on TD which indicates the quality of the reflective signal from the disc edge
; The Alignment & Test module then integerates this into a DC level for display on a DVM.
;--------------------------------

TestMode			;optical alignment & initial programming parameters downloading

	call	GetPrams	;download Hermes programming parameters

	movlw	1
	call	DoBlink		;show we are in test mode

	bsf	STATUS, RP0	;select bank 1
	bcf	TdDir, Td	;make TD bit output
	bcf	STATUS, RP0	;select bank 0

getopto
	call	IrOn		;turn ir led on & profile reflective signal

	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal

	call	IrOff		;turn ir led off & profile background signal

	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal
	call	TestOpto	;set Td to inverse of Opto signal

	goto	getopto		;do this until test box unplugged

;--------------------------------
; Download initial programming procedures
;--------------------------------

GetPrams			;get the initial programming parameters for this meter

	movlw	ser1
	movwf	mnum
	movlw	ser2
	movwf	mnum+1
	movlw	ser3
	movwf	mnum+2		;store meter serial # (in bcd)

	movlw	mpicst
	movwf	mpi		;store minutes per interval

	movlw	iprcst
	movwf	ipr		;store intervals per report

	movlw	high (kwh10)
	movwf	rp10kwh		;store msb of revs / 10kwh
	movlw	low (kwh10)
	movwf	rp10kwh+1	;store lsb of revs / 10kwh

	movlw	gsm1
	movwf	phgsm
	movlw	gsm2
	movwf	phgsm+1
	movlw	gsm3
	movwf	phgsm+2
	movlw	gsm4
	movwf	phgsm+3
	movlw	gsm5
	movwf	phgsm+4		;store gsm phone number until I get the Nokia download working

	bsf	dodl, 0		;flag auto period download for demo
	return

;-----------------------------------------------------------------------
; Rom stored messages
;-----------------------------------------------------------------------

PhMsg
	da	"\x1f\x00\x1d\x03\x07\x00\x00\x01\x00\x01"
PhMsgend

Cmsg
	da	"AT+CMGS="	;start of AT text mode SMS message command string
Cmsgend

Etsa
	da	"Etsa"		;Mp
Etsaend

OL
	da	" Online "	;"Online" message
OLend

Text
	da	"AT+CMGF=1\x0d"	;select sms text mode
Textend

;-----------------------------------------------------------------------
; Main Program
;-----------------------------------------------------------------------

Main				;start of Hermes

	call	SetupIo		;setup I/O ports
	call	Delay1sec	;wait 1 second for things to settle down

	btfsc	TdPort, Td	;is TD line low? (normally low but pulled up by resistor in test module)
	call	TestMode	;yes - so go into test mode until disconnected

	movlw	2
	call	DoBlink		;show we are in "OnLine" mode

	call	SetupTime	;setup default TOD, 1/2 second t1 heart beat & other time parameters
	call	GetPrams	;get initial meter specific / reporting parameters
	call	MarkI1t		;record time for Send Online message
	call	SndOnline	;send initial "On Line" message
	call	InitAdc		;initialize the Adc
	call	ClrIvl		;clear intervals & mark first interval time

MainLoop			;this is the main loop where we will stay until battery power is lost

	call	CkDisc		;check & inc current interval tick count if black flag found
	call	CkPfail		;check & record power fail / restore
	call	CkTamper	;check & record tampering
	call	CkTod		;check & update tod if needed
	call	CkNi		;check & inc to new interval if needed
	call	CkPfull		;check & do interval data download if period full
	call	CkInComms	;check for inward comms request (Ir meter reader or Comms central system)
	goto	MainLoop	;go to do it again and again..............

;-----------------------------------------------------------------------
; program end
;-----------------------------------------------------------------------

	end

