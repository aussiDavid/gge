;-----------------------------------------------------------------------
; Procedures (in page 1)
;-----------------------------------------------------------------------
;----------------------------------------------------------
; Comms conversion procedures
;----------------------------------------------------------

SendLfCr					;send message end
	movlw	lf
	call10	Send8n			;send line feed

	movlw	cr
	call10	Send8n			;send carrage return

	return

;----------------------------------------

SendFd					;send delimiter
	movlw	','
	call10	Send8n			;send ','

	return

;----------------------------------------

SendHex					;send binary in w as 2 hex numbers
	movwf	tempw			;save binary
	swapf	tempw,w			;swap hexades to convert 7:4
	call	CovHex			;convert w 3:4 into Hex & leave in w
	call10	Send8n			;send it

	movfw	tempw			;load original again
	call	CovHex			;convert 3:4
	call10	Send8n			;sendit

	return

;----------------------------------------

SendBin3					;convert binary in w into 3 packed bcd nibbles & send to comms
	movwf	tempb			;save original value

	movlw	200			;
	subwf	tempb,w			;test if >=200
	skpc				;skip if >=200
	goto	ck100			;go to check if it is >100

	movlw	'2'			;load ascii 2
	call10	Send8n			;send it
	movlw	200			;load 200
	subwf	tempb,f			;sub 200 from value
	goto	do99			;go to handle the rest

ck100
	movlw	100			;
	subwf	tempb,w			;test if >=100
	skpc				;skip if >=100
	goto	snd0			;go to handle the rest

	movlw	'1'			;load ascii 1
	call10	Send8n			;send it
	movlw	100			;load 100
	subwf	tempb,f			;sub 100 from value
	goto	do99			;go to handle the rest

snd0
	movlw	'0'			;load ascii 0
	call10	Send8n			;send it

do99
	movfw	tempb			;load value
	SndBcd2				;send it

	return

;--------------------------------

SendDec					;send two packed BCD digits in w with a decimal point between
	movwf	tempw			;save w

	swapf	tempw,w			;load msb of revs and swap hexades to send left first
	SendR				;send it

	movlw	'.'			;load '.'
	call10	Send8n			;send decimal point

	movfw	tempw			;reload to send right hexade
	SendR				;send it

	return

;----------------------------------------
;
;GetDec					;receive three ascii x.x and pack their ls hexade into 1 char
;	call10	Recv8n			;receive 1st ascii in w
;	andlw	0x0f			;isolate 3:4
;	movwf	bcdchr			;store it away
;	swapf	bcdchr,f			;swap hexades
;
;	call10	Recv8n			;get decimal point
;
;	call10	Recv8n			;receive 2nd ascii in w
;	andlw	0x0f			;isolate 3:4
;	iorwf	bcdchr,w			;or in first bcd and return with result in w
;
;	return
;
;----------------------------------------
;
;GetBin					;get 2 bytes, convert into bcd and convert into binary
;	call10	Recv8n			;receive 1st ascii in w
;	andlw	0x0f			;isolate 3:4
;	movwf	bcdchr			;store it away
;	swapf	bcdchr,f			;swap hexades
;
;	call10	Recv8n			;receive 2nd ascii in w
;	andlw	0x0f			;isolate 3:4
;	iorwf	bcdchr,w			;or in first bcd and return with result in w
;
;	call	BcdtoB			;convert packed bcd in w into binary and leave in w
;
;	return
;
;----------------------------------------

BtoBcd
	clrf	temp			;clear temp msb
	movwf	temp1			;store binary

sub10
	movlw	10	
	subwf	   temp1,w			;sub 10 from binary in w
	btfss	   STATUS,C			;test if w > 10
	goto	    over			;no - so finish up conversion
	movwf	temp1			;yes - so store new binary - 10
	incf	    temp,f			;inc msb count
	goto	    sub10			;goto do another -10 cycle

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

	movlw	('A'-'9')-1			;load adjustment (Decimal to Alpha adjustment factor)
	addwf	temp, f			;make adjustment to alpha (A-F)

finhex
	movfw	temp			;load converted hex character

	return

;----------------------------------------

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
; Comms sending and receiving procedures
;----------------------------------------

SendSC
;	call	SendDate			;send date
;	call	SendFd			;,
;
;	call	SendTime			;send time
;	call	SendFd			;,
;
;	call	SendTmr			;send timer & sleep data data
;	call	SendFd			;,
;
	call	SendAzi			;send azi encoder
	call	SendFd			;,

	call	SendAlt			;send alt encoder
	call	SendFd			;,

	call	SendMov			;send move encoder
	call	SendFd			;,
;
;	call	SendMath			;send math data
;	call	SendFd			;,
;
	call	SendTAT			;send TAT data
	call	SendFd			;,

	call	SendAdc			;send adc data
	call	SendFd			;,
;
;	movfw	Flag0			;load flag byte
;	call	SendHex			;send it
;	call	SendFd			;,
;
	call10	TSWest			;get West status
	call	SendHex			;send it

	call10	TSDn
	call	SendHex			;send it

	call	SendLfCr			;end message

	return

;----------------------------------------
;
;SendTmr					;send timer stuff
;	movfw	THb			;track update down counter
;	call	SendBin3			;send it
;	call	SendFd			;,
;
;	movfw	TodPS			;Tod update pre scaler
;	call	SendBin3			;send it
;	call	SendFd			;,
;
;	movfw	WUpMPS			;Sleep heart beat pre scaler
;	call	SendBin3			;send it
;	call	SendFd			;,
;
;	movfw	WUpM+1			;load msb
;	call	SendHex			;send it
;	movfw	WUpM			;load lsb
;	call	SendHex			;send it
;
;	return
;
;----------------------------------------

SendAzi					;send hhhhhh,
	movfw	AziEnc+2			;load lsb
	call	SendHex			;send lsb
	movfw	AziEnc+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AziEnc			;load lab+2
	call	SendHex			;send lsb+2

	movlw	'/'			;load '/'
	call10	Send8n			;send it

	movfw	AziSun+2			;load lsb
	call	SendHex			;send lsb
	movfw	AziSun+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AziSun			;load lab+2
	call	SendHex			;send lsb+2

	return

;----------------------------------------

SendAlt					;send hhhhhh,
	movfw	AltEnc+2			;load lsb
	call	SendHex			;send lsb
	movfw	AltEnc+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AltEnc			;load lab+2
	call	SendHex			;send lsb+2

	movlw	'/'			;load '/'
	call10	Send8n			;send it

	movfw	AltSun+2			;load lsb
	call	SendHex			;send lsb
	movfw	AltSun+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AltSun			;load lab+2
	call	SendHex			;send lsb+2

	return

;----------------------------------------

SendMov					;send MovEnc hhhhhh
	movfw	MoveSz+2			;load lsb
	call	SendHex			;send lsb
	movfw	MoveSz+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	MoveSz			;load lab+2
	call	SendHex			;send lsb+2

	return

;----------------------------------------
;
;SendMath
;	movfw	AA+2			;
;	call	SendHex			;
;	movfw	AA+1			;
;	call	SendHex			;
;	movfw	AA			;
;	call	SendHex			;send 24 bit math input
;
;	movlw	'/'			;load '/'
;	call10	Send8n			;send it
;
;	movfw	BB+2			;
;	call	SendHex			;		
;	movfw	BB+1			;
;	call	SendHex			;		
;	movfw	BB			;
;	call	SendHex			;send 24 bit math input
;
;	return
;
;----------------------------------------

SendAdc					;send SunVdc,TarVdc,	
	call10	TSunVdc8			;get solar voltage

	movfw	SunVdc			;load SunVdc
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	TarVdc			;load TarAdc TAT index
	call	SendBin3			;send it

	return

;----------------------------------------

SendTAT					;send AziI,AltI,AziC,AltC,
	movfw	MDir			;load last direction
	call	SendHex			;send it

	return

;----------------------------------------
;
;SendDate					;send the date as "dd/mm/yyyy, "
;	movfw	day			;load day
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	movlw	'/'			;load '/'
;	call10	Send8n			;send it
;
;	movfw	month			;load month
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	movlw	'/'			;load '/'
;	call10	Send8n			;send it
;
;	movfw	yearhi			;load year high
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;	movfw	yearlo			;load year low
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	return
;
;----------------------------------------
;
;SendTime					;send the time as "hh:mm:ss, "
;	movfw	hour			;load hour
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	movlw	':'			;loas ':'
;	call10	Send8n			;send it
;
;	movfw	minute			;load minute
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	movlw	':'			;loas ':'
;	call10	Send8n			;send it
;
;	movfw	second			;load second
;	SndBcd2				;send binary in w as 2 numeric bcds to comms
;
;	return
;
;----------------------------------------
;
;GetTime					;get time hh:mm:ss
;	call	GetBin			;get HH
;	movwf	hour			;store in hour
;
;	call10	Recv8n			;:
;
;	call	GetBin			;get MM
;	movwf	minute			;store in minute
;
;	call10	Recv8n			;:
;
;	call	GetBin			;get SS
;	movwf	second			;store in second
;
;	return
;
;----------------------------------------
;
;GetDate					;get date dd/mm/yyyy
;	call	GetBin			;get DD
;	movwf	day			;store in day
;
;	call10	Recv8n			;/
;
;	call	GetBin			;get MM
;	movwf	month			;store in month
;
;	call10	Recv8n			;/
;
;	call	GetBin			;get YY high
;	movwf	yearhi			;store in year hi
;
;	call	GetBin			;get YY low
;	movwf	yearlo			;store in year lo
;
;	return
;
;----------------------------------------
;
;TogDump					;toggle auto disgnostic data dump on and off
;	call10	Recv8n			;get next byte
;	movwf	tempw			;save w
;	sublw	'1'			;test = 1
;	skpnz				;no - so skip enable
;	bsf	Flag0,DoDump		;enable optical quality monitoring
;
;	movfw	tempw			;load received byte
;	sublw	'0'			;test = 0
;	skpnz				;no - so skip disbale
;	bcf	Flag0,DoDump		;disable optical quality monitoring
;
;	return
;
;----------------------------------------
;
;GoAzi
;	return
;
;----------------------------------------
;
;GoAlt
;	return
;----------------------------------------
; Led driver procedures
;----------------------------------------
;
;BlinkLed					;blink the led
;	bsf	STATUS,RP0			;select bank 1
;	movlf	DirBCom,TRISB		;initialize port B data direction register (rb1)
;	bcf	STATUS,RP0			;select bank 0
;
;	bsf	LedP,Led			;turn the led on
;
;	dlylms	250			;delay 250 ms
;
;	bcf	LedP,Led			;turn the led off
;
;	dlylms	250			;delay 250 ms
;
;	bsf	STATUS,RP0			;select bank 1
;	movlf	DirBHj,TRISB		;initialize port B data direction register (rb1)
;	bcf	STATUS,RP0			;select bank 0
;	return
;
;----------------------------------------
; Test program memory for CheckSum errors
;----------------------------------------
;
;CkMem
;	setRP1		 		;select reg bank 2
;
;	clrf	CkSumL	 		;clear the CkSumL/H
;	clrf	CkSumH		 	;registers
;	clrf	EEADR		 	;set the Program Memory
;	clrf	EEADRH	 		;address to 0x0000
;
;CLoop				 	;loop for each location
;	setRP0			 	;goto reg bank 3 from reg bank 2
;
;	bsf	EECON1,EEPGD 		;set for program mem
;	bsf	EECON1,RD	 		;set for read operation
;	nop				;
;	nop				;delay for read to happen
;
;	clrRP0			 	;back to reg bank 2 from reg bank 3
;
;	movfw	EEDATA		 	;add low byte to CkSumL
;	addwf	CkSumL,f			;save result
;	skpnc			 	;skip if no overflow
;	incf	CkSumH,f	 		;yes, so incr CkSumH
;
;	movfw	EEDATH		 	;add high byte to CkSumH
;	addwf	CkSumH,f			;save result
;
;	incfsz	EEADR,f	 		;inc low address
;	goto	CLoop			;no overflow, so do next code pair
;
;	incfsz	EEADRH,f	 		;overflow, so incr high address
;	goto	CLoop		 	;EEADRH has not rolled over from 0x0F to 0X00 (top 4 bits do not exist and read as zero)
;
;	clrRP1				;back to reg bank 0 from reg bank 2
;
;	movfw	CkSumH			;load high byte
;	andlw	0x3F			;zap bits 6 & 7 as they don't exist in the 14 bit wide program memory
;	iorwf 	CkSumL,w			;or in low byte
;	return				;return with z=Ok, nz=Bad
;


