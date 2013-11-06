
	errorlevel	0			;set compiler error reporting level, 0 = everything, 2= no warnings
					;
;-----------------------------------------------------------;
					;define the physical stats we need for the firmware
#define 	TatSec	10			;seconds per track adjust (normally 18)
#define	IntsPerSec	4			;timer ints per second (normally 4)
#define	IntsPerMin	IntsPerSec*60		;timer ints per minute
#define	IntsPerTat	IntsPerSec*TatSec		;set timer ints per Tat update
					;
#define	SLkmin	2			;minutes between alternating alt and azi SunLocks
#define	TatsPerLk	(SLkmin*60)/TatSec		;TAT cycles between SunLocks
					;
#define	Retro	1			;enable retro azi tracking movement
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
	#include Mark9C2.asm			;main program loads here
					;
pg1avil	equ	0x0800-$			;calc spare memory in program memory block 0
					;
	org	0x0800			;program memory address for the start of page 1
					;
	#include CommsC2.asm			;Comms and misc code load next
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

	end

;################ Spare unused code ################
 
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
	call	SetCom			;setup port b for comms mode
	SndL	'5'			;ident this message
	call	SendSC			;dump the data down the com line
	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
