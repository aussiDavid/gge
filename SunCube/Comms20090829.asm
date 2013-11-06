;-----------------------------------------------------------------------
; Procedures (in page 1)
;-----------------------------------------------------------------------

ReCal
	btfss	Flag1,MsOK			;skip if EMPS installed
	return				;otherwise just exit

	clrGIE				;disable ints
	bcf	Flag1,TATGo			;turn off TAT calcs
	copy24	AltEnc,SAltEnc		;
	copy24	AltSky,SAltSky		;save alt info

	copy24	AziSky,SAziSky		;
	copy24	AziEnc,SAziEnc		;save azi info
	setGIE

	call10	GoAlt0			;move to what the azi encoder thinks is Alt 0
	call10	GoAzi0			;move to what the alt encoder thinks is Azi 0

tickres
	movlf	3*HbPSec,HpDwnCnt		;set HbDwnCnt for 3 second downcount to zero by int controller

doreshj
	call10	HandJob			;check for HJ to adjust Azi0 and Alt0 positions before recal is done
	skpnz				;skip if none
	goto	tickres			;HJ done so reset HbDwnCnt down counter

	movf	HpDwnCnt,f			;is HbDwnCnt = zero
	skpz				;skip if zero
	goto	doreshj			;go to check for HJ and if not so let HbDwnCnt count down
	
;recalibrate the Azi encoder

	call10	FAziMs			;find Azi EMPS using abs Cw movement
	btfsc	Flag1,MsOK			;skip if alt magnet not found
	goto	finrazi			;magnet found so do azi recal

	call	GoAzi0			;got to Azi0
	clrGIE				;disable ints
	copy24	SAziSky,AziSky		;restore AziSky
	setGIE				;enable ints
	goto	rcalalt			;do EMPS alt check

finrazi
	copy24	AziEnc,TmpEnc		;save magnet error offset value
	copy24	MsAzi,AziEnc		;reset current Azi encoder position from earlier EMPS MSAzi
	call10	GoAzi0			;go to real azi 0 to ensure EMPS sensor magnet has moved away from sensor

	copy24	TmpEnc,AA			;load magnet AziEnc error
	copy24	MsAzi,BB			;load original magnet value
	call10	AbsDiff			;get magnet and encoder error difference
	copy24	AA,AziSky			;save difference in AziSky

	copy24	TmpEnc,AA			;load azi error to AA
	copy24	MsAzi,BB			;load MsAzi to BB
	ifBgtrA1	dazia			;if MsAzi > azi error then branch

	copy24	SAziEnc,AA		;load original west azi
	copy24	AziSky,BB			;load azi error differential
	call10	Sub24			;sub them
	goto	frazi			;goto finish azi processing

dazia
	copy24	SAziEnc,AA		;load original east azi
	copy24	AziSky,BB			;load azi error differential
	call10	Add24			;add them
	
frazi
	copy24	AA,AziSky			;save corrected AziSky

;recalibrate the Alt encoder

rcalalt
	call10	FAltMs			;find Alt EMPS and leave AltEnc set with what it thinks is it's position
	btfsc	Flag1,MsOK			;skip if alt magnet not found
	goto	finralt			;magnet found so do alt recal

	call	GoAlt0			;got to Alt0
	clrGIE				;disable ints
	copy24	SAltSky,AltSky		;restore AltSky
	setGIE				;enable ints
	goto	rcexit			;goto to do exit stuff

finralt
	copy24	AltEnc,TmpEnc		;save just detected offset value
	copy24	MsAlt,AltEnc		;set current Alt encoder position from earlier EMPS MsAlt

	copy24	TmpEnc,AA			;load just detected offset
	copy24	MsAlt,BB			;load original magnet value
	call10	AbsDiff			;get magnet and encoder error difference
	copy24	AA,AltSky			;save difference in AltSky

	copy24	TmpEnc,AA			;load azi error to AA
	copy24	MsAlt,BB			;load MsAlt to BB
	ifBgtrA1	dalta			;if MsAlt > alt error then branch

	copy24	SAltEnc,AA			;load original alt
	copy24	AltSky,BB			;load azi error differential
	call10	Sub24			;sub them
	goto	fralt			;goto finish azi processing

dalta
	copy24	SAltEnc,AA			;load original east azi
	copy24	AltSky,BB			;load azi error differential
	call10	Add24			;add them
	
fralt
	copy24	AA,AltSky			;save corrected AltSky

rcexit					;recal error exit
	movlf	1,OnSunA			;force first TAT cycle to do an on sun lock
	bsf	Flag1,TATGo			;turn on TAT calcs
	return

;**********************************************************************************************
        
;       23/15 Bit Unsigned Fixed Point Divide 23/15 -> 23.15

;       Input:  23 bit unsigned fixed point dividend in AARGB0, AARGB1,AARGB2
;               15 bit unsigned fixed point divisor in BARGB0, BARGB1

;       Use:    CALL    FXD2315U

;       Output: 23 bit unsigned fixed point quotient in AARGB0, AARGB1,AARGB2
;               15 bit unsigned fixed point remainder in REMB0, REMB1

;       Result: AARG, REM  <--  AARG / BARG

;       Max Timing:     2+403+2 = 407 clks

;       Min Timing:     2+375+2 = 379 clks

;       PM: 2+117+1 = 120               DM: 7

FXD2315U
	        CLRF            REMB0
                CLRF            REMB1

;       Max Timing:     9+6*17+16+16+6*17+16+16+6*17+16+8 = 403 clks

;       Min Timing:     9+6*16+15+15+6*16+15+15+6*16+15+3 = 375 clks

;       PM: 7+2*40+22+8 = 117                                    DM: 7
;
;               MOVF            BB,W
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                RLF             AA+2, F
;
;                MOVLW           7
;                MOVWF           LoopCnt
;
;LOOPU2315A
;	      RLF             AA+2,W
;                RLF             REMB1, F
;                RLF             REMB0, F
;                MOVF            BB,W
;                BTFSS           AA+2,LSB
;                GOTO            UADD35LA
;
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                GOTO            UOK35LA
;
;UADD35LA
;	        ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;        
;UOK35LA
;	RLF             AA+2, F
;
;                DECFSZ          LoopCnt, F
;                GOTO            LOOPU2315A
;
;                RLF             AA+1,W
;                RLF             REMB1, F
;                RLF             REMB0, F
;                MOVF            BB,W
;                BTFSS           AA+2,LSB
;                GOTO            UADD35L8
;
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                GOTO            UOK35L8
;
;UADD35L8
;	        ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;        
;UOK35L8
;	 RLF             AA+1, F
;
;                MOVLW           7
;                MOVWF           LoopCnt
;
;LOOPU2315B
;	      RLF             AA+1,W
;                RLF             REMB1, F
;                RLF             REMB0, F
;                MOVF            BB,W
;                BTFSS           AA+1,LSB
;                GOTO            UADD35LB
;
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                GOTO            UOK35LB
;
;UADD35LB
;	        ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;        
;UOK35LB
;	 RLF             AA+1, F
;
;                DECFSZ          LoopCnt, F
;                GOTO            LOOPU2315B
;
;                RLF             AA,W
;                RLF             REMB1, F
;                RLF             REMB0, F
;                MOVF            BB,W
;                BTFSS           AA+1,LSB
;                GOTO            UADD35L16
;
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                GOTO            UOK35L16
;
;UADD35L16
;	       ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;       
;UOK35L16
;	        RLF             AA, F
;
;                MOVLW           7
;                MOVWF           LoopCnt
;
;LOOPU2315C
;	      RLF             AA,W
;                RLF             REMB1, F
;                RLF             REMB0, F
;                MOVF            BB,W
;                BTFSS           AA,LSB
;                GOTO            UADD35LC
;
;                SUBWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSS           STATUS,C
;                INCFSZ          BB+1,W
;                SUBWF           REMB0, F
;                GOTO            UOK35LC
;
;UADD35LC
;	        ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;        
;UOK35LC
;	 	RLF             AA, F
;
;                DECFSZ          LoopCnt, F
;                GOTO            LOOPU2315C
;
;                BTFSC           AA,LSB
;                GOTO            UOK35L
;                MOVF            BB,W
;	        ADDWF           REMB1, F
;                MOVF            BB+1,W
;                BTFSC           STATUS,C
;                INCFSZ          BB+1,W
;                ADDWF           REMB0, F
;UOK35L
;                RETLW           0x00
;
;**********************************************************************************************
;
;SaveSky
;	clrGIE
;	copy24	AltSky,SAltSky		;
;	copy24	AziSky,SAziSky		;save sky point
;	setGIE
;	return
;
;--------------------------------------------------

ResSky
	clrGIE
	copy24	SAltSky,AltSky		;
	copy24	SAziSky,AziSky		;restore sky point
	setGIE
	return

;----------------------------------------
; Led driver procedures
;----------------------------------------
;
;BlinkLed					;blink the led
;	bsf	STATUS,RP0		;select bank 1
;	movlf	DirBCom,TRISB		;initialize port B data direction register (rb1)
;	bcf	STATUS,RP0		;select bank 0
;
;	bsf	LedP,Led			;turn the led on
;
;	dlylms	250			;delay 250 ms
;
;	bcf	LedP,Led			;turn the led off
;
;	dlylms	250			;delay 250 ms
;
;	bsf	STATUS,RP0		;select bank 1
;	movlf	DirBHj,TRISB		;initialize port B data direction register (rb1)
;	bcf	STATUS,RP0		;select bank 0
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
;----------------------------------------

SetUpTOD
	setRP0
	movlf	31+1,dmth			;load days+1 in Jan
	movlf	28+1,dmth+1		;load days+1 in Feb (2003 is not mod 4 = 0 so it is not a leap year)
	movlf	31+1,dmth+2		;load days+1 in Mar
	movlf	30+1,dmth+3		;load days+1 in Apr
	movlf	31+1,dmth+4		;load days+1 in May
	movlf	30+1,dmth+5		;load days+1 in Jun
	movlf	31+1,dmth+6		;load days+1 in Jul
	movlf	31+1,dmth+7		;load days+1 in Aug
	movlf	30+1,dmth+8		;load days+1 in Sep
	movlf	31+1,dmth+9		;load days+1 in Oct
	movlf	30+1,dmth+10		;load days+1 in Nov
	movlf	31+1,dmth+11		;load days+1 in Dec
	clrRP0
	return

;----------------------------------------
; Interrupt specific procedures
;----------------------------------------

DecWupD					;dec 16 bit Wake up delay
	movf	WUpM,f			;is sleep delay lsb zero
	skpnz				;no so skip
	goto	ckWb1			;yes so check msb

	decf	WUpM,f			;no so dec it
	goto	ckWUpDZ			;check if downcount finished

ckWb1
	decf	WUpM,f			;dec sleep delay lsb to make it non zero
	decf	WUpM+1,f			;dec sleep delay msb for borrow

ckWUpDZ
	movfw	WUpM			;load lsb
	iorwf	WUpM+1,w			;or in msb
	skpnz				;skip if not zero
	bsf	Flag0,WUpZ		;set wake up minutes zero flag
	return

;----------------------------------------

UpDTod					;update time and date
	setRP0				;select bank 1
	movff	FSR,SFSR			;save FSR
	incf	second,f			;inc second counter
	movlw	60			;load max second + 1 (0 - 59)
	subwf	second,w			;sub and put result in W
	skpz				;skip next op if second = 60
	goto	endtod			;no - so go back to where we were

	clrf	second			;yes - so clear second
	incf	minute,f			;now inc minute count
	movlw	60			;load max minute + 1 (0 - 59)
	subwf	minute,w			;sub and put result in w
	skpz				;skip next op if minute = 60
	goto	endtod			;no - so go back to where we came from

	clrf	minute			;yes - so clear minute
	incf	hour,f			;now inc hour count
	movlw	24			;load max hour + 1 (0 - 23)
	subwf	hour,w			;sub and put result in w
	skpz				;skip next op if hour = 24
	goto	endtod			;no - so go back to where we came from

	clrf	hour			;yes - so clear hour
	incf	day,f			;now inc day count
	movfw	month			;load month (1 - 12)
	addlw	dmth-1			;add days in month array base address
	movwf	FSR			;store result in indirect addressing register
	movfw	INDF			;load days + 1 in month into w
	subwf	day,w			;sub and put result in w
	skpz				;skip next op if day = 1 + max in month
	goto	endtod			;no - so go back to where we came from

	clrf	day			;yes - so clear day
	incf	day,f			;inc start day to 1

	incf	month,f			;now inc month count
	movlw	13			;load max month + 1 (1 - 12)
	subwf	month,w			;sub and put result in w
	skpz				;skip next op if month = 13
	goto	endtod			;no - so go back to where we came from

	clrf	month			;yes - so clear month
	incf	month,f			;inc month to start from 1

	incf	yearlo,f			;inc year low
	movlw	100			;load max year low + 1 (0 - 99)
	subwf	yearlo,w			;sub and put result in w
	skpz				;skip next op if yearlo = 100
	goto	doleap			;no - so go do leap year adjust

	clrf	yearlo			;yes - so clear yearlo
	incf	yearhi,f			;inc to next century (like this code will EVER be executed!) 

doleap
	movlw	29+1			;assume it is a leap year (yearlo mod 4 = 0)
	btfss	yearlo,0			;is bit 0 zero?
	movlw	28+1			;no - so it is not a leap year
	btfss	yearlo,1			;is bit 1 zero
	movlw	28+1			;no - so it is not a leap year
	movwf	dmth+1			;store days in Feb for this year

endtod
	movff	SFSR,FSR			;restore FSR
	clrRP0
	return

;----------------------------------------

Inc24					;inc encoder count, only called by int handler
	movff	FSR,SFSR			;save original FSR
	movlw	Max1			;test if enc at max
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc encoder value

	incf	FSR,f			;inc to next byte
	movlw	Max2			;load next value to test
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc encoder value

	incf	FSR,f			;inc to next byte
	movlw	Max3			;load that bytes max value
	subwf	INDF,w			;test if this byte = max
	skpz				;yes so skip
	goto	inc241			;no so goto inc it

	movff	SFSR,FSR			;restore original FSR
	clrf	INDF
	incf	FSR,f			;inc to next byte
	clrf	INDF
	incf	FSR,f			;inc to next byte
	clrf	INDF			;encoder inced and rolled over to zero
	return				;so finally return	

inc241
	movff	SFSR,FSR			;restore FSR
	incfsz	INDF,f			;inc lsb
	return				;return if no overflow

	incf	FSR,f			;inc pointer to next byte
	incfsz	INDF,f	 		;inc lsb+1
	return				;return if no overflow

	incf	FSR,f			;inc to next byte
	incf	INDF,f			;simple inc lsb+2 will do here
	return				;finished here, so return

;----------------------------------------

Dec24					;dec encoder count, only called by interrupt handler
	movff	FSR,SFSR			;save original FSR
	movfw	INDF			;test if lsb is zero
	incf	FSR,f			;inc pointer to next byte
	iorwf	INDF,w			;test if lsb+1 is zero
	incf	FSR,f			;inc pointer to next byte
	iorwf	INDF,w			;test if lsb+2 is zero
	skpz				;yes so test next byte
	goto	dec241			;no so go to dec it

	movff	SFSR,FSR			;restore original FSR
	movlf	Max1,INDF			;set max value for this byte
	incf	FSR,f			;inc to next byte
	movlf	Max2,INDF			;set max value for this byte
	incf	FSR,f			;inc to next byte
	movlf	Max3,INDF			;set max value for this byte
	return				;with encoder at max as a result of a underflow

dec241
	movff	SFSR,FSR			;restore original FSR
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

Send8n					;sent byte in w as 8N RS232 (low = 1)
	movwf	xmtchr			;save byte to be sent

	movlf	8,bitcnt			;init shift count

	bsf	TdP,Td			;set Td high / spacing / 0 for start bit
	DlyB				;delay to send start bit

next8n
	rrf	xmtchr,f			;rotate right lsb into carry
	skpc				;skip if carry set
	goto	dozero8n			;no carry - so send 0
	bcf	TdP,Td			;yes there is a carry - so put 1 on TD line
	goto	dobaud8n			;goto baud delay

dozero8n
	bsf	TdP,Td			;put 0 on TD line

dobaud8n
	DlyB				;delay for 1 baud time

	decfsz	bitcnt,f			;test if more bits to send
	goto	next8n			;yes - so do it again

	bcf	TdP,Td			;no - so set td low / marking / 1 for stop bit
	DlyB				;
	DlyB				;delay for 2 baud time to generate 2 stop bits

	return

;----------------------------------------

Recv8n					;receive 8N byte from inverted RS232 input (low = 1)
	clrc				;clear carry as no valid char received

	btfss	RdP,Rd			;test for start bit (Rd line low)
	return				;false start bit

	DlyHB				;delay for 1/2 baud time
	btfss	RdP,Rd			;test for start bit (Rd line low)
	return				;false start bit

	movlf	8,bitcnt			;set bit counter to receive 8 bits
	clrf	rcvchr			;clear comm received character
	clrc				;clear carry

r8na
	rrf	rcvchr,f			;rotate partial received comm char right one bit through carry
	DlyB				;yes - so delay full baud to get into middle of next bit
	btfss	RdP,Rd			;test status of Rd
	bsf	rcvchr,7			;set msb of comm ch
	decfsz	bitcnt,f			;test if more bits to receive
	goto	r8na			;yes - so do it

	DlyB				;delay into the middle of the stop bit
	movfw	rcvchr			;load w with received char
	setc				;set carry to flag valid character received

	return

;----------------------------------------------------------
; Comms conversion procedures
;----------------------------------------------------------

SendLfCr					;send message end
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

SendBin3					;convert binary in w into 3 packed bcd nibbles & send to comms
	movwf	tempb			;save original value

	movlw	200			;
	subwf	tempb,w			;test if >=200
	skpc				;skip if >=200
	goto	ck100			;go to check if it is >100

	movlw	'2'			;load ascii 2
	call	Send8n			;send it
	movlw	200			;load 200
	subwf	tempb,f			;sub 200 from value
	goto	do99			;go to handle the rest

ck100
	movlw	100			;
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
;
;GetDec					;receive three ascii x.x and pack their ls hexade into 1 char
;	call	Recv8n			;receive 1st ascii in w
;	andlw	0x0f			;isolate 3:4
;	movwf	bcdchr			;store it away
;	swapf	bcdchr,f			;swap hexades
;
;	call	Recv8n			;get decimal point
;
;	call	Recv8n			;receive 2nd ascii in w
;	andlw	0x0f			;isolate 3:4
;	iorwf	bcdchr,w			;or in first bcd and return with result in w
;
;	return
;
;----------------------------------------
;
;GetBin					;get 2 bytes, convert into bcd and convert into binary
;	call	Recv8n			;receive 1st ascii in w
;	andlw	0x0f			;isolate 3:4
;	movwf	bcdchr			;store it away
;	swapf	bcdchr,f			;swap hexades
;
;	call	Recv8n			;receive 2nd ascii in w
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
	subwf   temp1,w			;sub 10 from binary in w
	btfss   STATUS,C			;test if w > 10
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
	call	SendDate			;send date
	call	SendFd			;,

	call	SendTime			;send time
	call	SendFd			;,

	call	SendTmr			;send timer & sleep data data
	call	SendFd			;,

	call	SendAzi			;send azi encoder
	call	SendFd			;,

	call	SendAlt			;send alt encoder
	call	SendFd			;,

	call	SendMov			;send move encoder
	call	SendFd			;,

	call	SendMath			;send math data
	call	SendFd			;,

	call	SendTAT			;send TAT data
	call	SendFd			;,

	call	SendAdc			;send adc data
	call	SendFd			;,

	movfw	Flag0			;load flag byte
	call	SendHex			;send it
	call	SendFd			;,

	call01	TWest			;get West status
	call	SendHex			;send it

	call01	TDn
	call	SendHex			;send it

	call	SendLfCr			;end message

	return

;----------------------------------------

SendTmr					;send timer stuff
	movfw	THb			;track update down counter
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	TodPS			;Tod update pre scaler
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	WUpPS			;Sleep heart beat pre scaler
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	WUpM+1			;load msb
	call	SendHex			;send it
	movfw	WUpM			;load lsb
	call	SendHex			;send it

	return

;----------------------------------------

SendAzi					;send hhhhhh,
	movfw	AziEnc+2			;load lsb
	call	SendHex			;send lsb
	movfw	AziEnc+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AziEnc			;load lab+2
	call	SendHex			;send lsb+2

	movlw	'/'			;load '/'
	call	Send8n			;send it

	movfw	AziSky+2			;load lsb
	call	SendHex			;send lsb
	movfw	AziSky+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AziSky			;load lab+2
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
	call	Send8n			;send it

	movfw	AltSky+2			;load lsb
	call	SendHex			;send lsb
	movfw	AltSky+1			;load lsb+1
	call	SendHex			;send lsb+1
	movfw	AltSky			;load lab+2
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

SendMath
	movfw	AA+2			;
	call	SendHex			;
	movfw	AA+1			;
	call	SendHex			;
	movfw	AA			;
	call	SendHex			;send 24 bit math input

	movlw	'/'			;load '/'
	call	Send8n			;send it

	movfw	BB+2			;
	call	SendHex			;		
	movfw	BB+1			;
	call	SendHex			;		
	movfw	BB			;
	call	SendHex			;send 24 bit math input

	return

;----------------------------------------

SendAdc					;send SunVdc,TarVdc,	
	call01	TSunVdc8			;get solar voltage

	movfw	SunVdc			;load SunVdc
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	TarVdc			;load TarAdc TAT index
	call	SendBin3			;send it

	return

;----------------------------------------

SendTAT					;send AziI,AltI,AziC,AltC,
	movfw	AziI			;load AziI TAT index
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	AltI			;load AltI TAT index
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	AziC			;load AziC TAT track adj
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	AltC			;load AltC TAT track adj
	call	SendBin3			;send it
	call	SendFd			;,

	movfw	MDir			;load last direction
	call	SendHex			;send it

	return

;----------------------------------------

SendDate					;send the date as "dd/mm/yyyy, "
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

SendTime					;send the time as "hh:mm:ss, "
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
;
;GetTime					;get time hh:mm:ss
;	call	GetBin			;get HH
;	movwf	hour			;store in hour
;
;	call	Recv8n			;:
;
;	call	GetBin			;get MM
;	movwf	minute			;store in minute
;
;	call	Recv8n			;:
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
;	call	Recv8n			;/
;
;	call	GetBin			;get MM
;	movwf	month			;store in month
;
;	call	Recv8n			;/
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
;	call	Recv8n			;get next byte
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


