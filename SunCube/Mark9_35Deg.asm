
	errorlevel	2			;set compiler error reporting level, 0 = everything, 2= no warnings
					;
#define	TATVer	"35 Deg, "			;define TAT used
					;
;-----------------------------------------------------------;
					;define the physical stats we need for the firmware
#define 	TatSec	33			;seconds per track adjust (normally 33)
#define	IntsPerSec	4			;timer ints per second (normally 4)
#define	IntsPerMin	IntsPerSec*60		;timer ints per minute
#define	IntsPerTat	IntsPerSec*TatSec		;set timer ints per Tat update
					;
#define	SLkmin	3			;minutes between alternating alt and azi SunLocks
#define	TatsPerLk	(SLkmin*60)/TatSec		;TAT cycles between SunLocks
					;
#define	SCells	9			;number of series cells inside SunCube
#define	Retro	0			;enable retro azi tracking movement
					;
;-----------------------------------------------------------;
					;define the voltages we need for the firmware
#define	NorVdc	(Adc20V*VAdj)/100		;normal op min solar voltage to do a sun lock (18v for India)
#define	MorVdc	(Adc14V*VAdj)/100		;morning min solar voltage to do a sun lock (10v for India)
#define	WUpVdc	(Adc04V*VAdj)/100		;morning wake up min solar voltage to wake up from sleep (04v for India)
					;
;-----------------------------------------------------------;
					;define the degree values we need for the firmware
#define	DegNSlp	Deg360-Deg45		;over night sleep alt degrees
#define	DegSlp	Deg5.0			;deg trigger to go to sleep and to wake up
#define	AltCalDeg	DegSlp+Deg10		;alt West recal degs
#define	FTAzi	Deg270			;start fast track azi, 270 for non retro and 245 for retro solar noon cross
;#define	FTAzi	Deg270-Deg25		;start fast track azi, 270 for non retro and 245 for retro solar noon cross
#define	SlopDeg	Deg0.10			;compensation movement for any worm gear slop
					;
;-----------------------------------------------------------;
					;ok we have defined the enviroment, so lets put some modules together to make the code
	org	0x0000			;program memory address for the start of page 0 (also power on reset entry point)
					;
	#include Mark9.asm			;main program loads here
					;
pg1avil	equ	0x0800-$			;calc spare memory in program memory block 0
	org	0x0800			;program memory address for the start of page 1
					;
	#include TAT_35Deg.asm			;TAT loads first
	#include Comms.asm			;Comms and misc code load next
					;
pg2avil	equ	0x1000-$			;calc spare program memory in block 2
					;
;------------------------------------------------------------
; program end
;------------------------------------------------------------
;
;	org	0x0fff			;point to end of program memory
;
;	dw	0;(0x0000-0x0c65)		;store program memory check sum byte
;
	end
;
;################ Spare unused code ################
;
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
;	call	SetCom			;setup port b for comms mode
;	SndL	'5'			;ident this message
;	call	SendSC			;dump the data down the com line
;	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
;
;
;
;
;	errorlevel 2
;
;#define	TATSec	33			;seconds per track adjust (normally 33)
;#define	HbPSec	4			;heart beats per second (normally 4)
;#define	TATmin	10			;minutes between SunLocks
;#define	OnSunM	(TATmin*60)/TATSec		;TAT cycles between SunLocks
;
;#define	SCells	9			;number of series cells inside SunCube
;#define	NorLok	(Adc14V*VAdj)/100		;normal op min solar voltage to do a sun lock
;#define	MorLok	(Adc10V*VAdj)/100		;morning wake up min solar voltage to do a sun lock
;
;#define	DegNSlp	(Deg360-Deg45)		;over night sleep alt degrees
;#define	DegSlp	Deg2.5			;deg trigger to go to sleep and to wake up
;#define	AltCalDeg	Deg10			;alt West recal degs
;
;#define	FTAzi	Deg270			;start fast track azi
;#define	TATVer	"35 Deg, "			;define TAT used
;#define	Retro	0			;enable retro tracking movement
;
;	#include Mark9.asm
;	#include TAT_35Deg.asm
;	#include Comms.asm
;
;----------------------------------------
; end of program code & lookup tables
;----------------------------------------
;
;pg2avil	equ	0x1000-$
;
;	org	0x0fff			;point to end of program memory
;
;	dw	0;(0x0000-0x0c65)		;store program memory check sum byte
;
;	end
;
;################ Spare unused code ################
;
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
;	call	SetCom			;setup port b for comms mode
;	SndL	'1'			;ident this message
;	call	SendSC			;dump the data down the com line
;	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<<<
;
;----------------------------------------
; EEprom procedures
;----------------------------------------
;
;EeRead
;
;	movfw	EeAdr			;load Ee address
;
;	banksel	EEADR		 	;select bank of EEADR
;	movwf	EEADR			;load address
;
;	banksel	EECON1		 	;select bank of EECON1
;	bcf	EECON1,EEPGD		;select data memory
;	bsf 	EECON1,RD 		;EE Read
;	nop				;
;	nop				;
;
;	banksel	EEDATA	 		;select bank of EEDATA
;	movfw 	EEDATA		 	;W = EEDATA
;	banksel	PORTA			;select default bank 0
;	return
;
;----------------------------------------
;
;EeWrite
;
;	banksel EECON1 			;Select Bank of EECON1
;
;WEeFin
;	btfsc 	EECON1,WR	 		;Wait for write
;	goto 	WEeFin 			;to complete
;
;	banksel	EEDATA	 		;Select Bank of EEADR
;	movwf 	EEDATA 			;Data Memory Value to write
;
;	banksel	EeAdr
;	movfw	EeAdr			;load Ee address
;
;	banksel	EEADR
;	movwf	EEADR			;Store it
;
;	banksel EECON1	 		;Select Bank of EECON1
;	bcf 	EECON1,EEPGD		;Point to DATA memory
;	bsf 	EECON1,WREN 		;Enable writes
;	bcf 	INTCON,GIE	 	;Disable INTs.
;	movlf 	0x55,EECON2 		;Write 55h
;	movlf 	0xAA,EECON2	 	;Write AAh
;	bsf 	EECON1,WR 		;Set WR bit to begin write
;	bsf 	INTCON,GIE	 	;Enable INTs
;	bcf 	EECON1,WREN 		;Disable writes
;	banksel	PORTA			;back to bank 0
;	return
;
;----------------------------------------
;
;StoTAT					;store debug TAT data
;
;	movlf	low(E0),EeAdr
;	movfw	AziI
;	call	EeWrite			;store alt index
;
;	movlf	low(E0+1),EeAdr
;	movfw	AltI
;	call	EeWrite			;store azi index
;
;	movlf	low(E0+2),EeAdr
;	movfw	AltC
;	call	EeWrite			;store alt TAT adjust value
;
;	movlf	low(E0+3),EeAdr
;	movfw	AziC
;	call	EeWrite			;store azi TAT adjuat value
;
;----------------------------------------
;
;StEonc
;	movlf	low(E0+4),EeAdr
;	movfw	AziEnc+2
;	call	EeWrite			;store it
;
;	movlf	low(E0+5),EeAdr
;	movfw	AziEnc+1
;	call	EeWrite			;store it
;
;	movlf	low(E0+6),EeAdr
;	movfw	AziEnc
;	call	EeWrite			;store it
;
;-------
;
;	movlf	low(E0+7),EeAdr
;	movfw	AltEnc+2
;	call	EeWrite			;store it
;
;	movlf	low(E0+8),EeAdr
;	movfw	AltEnc+1
;	call	EeWrite			;store it
;
;	movlf	low(E0+9),EeAdr
;	movfw	AltEnc
;	call	EeWrite			;store it
;	return
;

;--stored auto azi code until I have the time to get it working better ---
;
;	movfw	AltEnc+2			;
;	subwf	LstAlt+2,w		;
;	skpz				;
;	goto	tstvdc			;skip if they are equal
;
;	movfw	AltEnc+1			;
;	subwf	LstAlt+1,w		;
;	skpz				;
;	goto	tstvdc			;skip if they are equal
;
;	movfw	AltEnc			;
;	andlw	0xf0			;zap 3:4
;	subwf	LstAlt,w			;
;	skpz					;
;	goto	tstvdc			;skip if they are equal
;
;	movf	LstAzi+2,f		;
;	skpz				;skip if LstAzi is small
;	goto	tstlst			;it big so leave it alone
;
;	setdeg	Deg360,AA			;load the max encoder+1
;	copyenc	LstAzi,BB			;load last sun lock azi encoder
;	call	Add24			;make it big
;	copyenc	AA,LstAzi			;temp save in AziEnc
;
;tstlst
;	movf	AziEnc+2,f		;
;	skpz				;skip if AziEnc is small
;	goto	doazi0			;it is big so leave it alone
;
;	setdeg	Deg360,AA			;load the max encoder +1
;	copyenc	AziEnc,BB			;load the current azi encoder
;	call	Add24			;make it big and leave in AA
;	copyenc	AA,AziEnc			;temp save in 
;
;doazi0
;	copyenc	AziEnc,AA			;load AA with current azi encoder
;	copyenc	LstAzi,BB			;load bb with the last saved sun lock azi encoder value
;	call	Sub24			;sub current azi encoder from last sun lock azi encoder
;	call	Div2			;divide in half to get new AziEnc value
;	copyenc	AA,AziEnc			;we are at peak sun altitude (no altitude over 5 minutes), so reset azienc to polar azimuth
;	call	SetWUpM			;as we setting new azi 0 so set wake up minutes to max
;	movsc	Up,Deg1.0			;
;	movsc	Dn,Deg1.0			;move up and down to flag we did azi polar adj
;
;tstvdc
