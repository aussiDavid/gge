;------------------------------------------------------------
					;
	errorlevel	0			;set compiler error reporting level, 0 = everything, 2= no warnings
					;
;-----------------------------------------------------------;
					;define the physical stats we need for the firmware
#define	IntsPerSec	4			;timer ints per second (normally 4)
					;
#define 	SecPerTat	15			;seconds per track adjust (normally 10)
#define	IntsPerTat	IntsPerSec*SecPerTat		;set timer ints per Tat update
					;
#define	MinPerSLk	5			;minutes between SunLocks
#define	TatsPerLk	(MinPerSLk*60)/SecPerTat	;TAT cycles between SunLocks
					;
;-----------------------------------------------------------;
					;define the voltages we need for the firmware
#define	MorVdc	Adc18V			;morning min solat lock voltage
#define	NorVdc	Adc21V			;normal min solar lock voltage
					;
#define	SunLks	3			;repeat count for lock errors / initial lock
					;
;-----------------------------------------------------------;
					;define the degree values we need for the firmware
#define	EMPSAlt	Deg60			;EMPS Alt search range
#define	EMPSAzi	Deg60			;EMPS Azi search range
					;
#define	DegNSlp	Deg360-Deg45		;over night sleep alt degrees
#define	SlopDeg	Deg0.20			;compensation movement for any worm gear slop
#define	MinSz	0xe0			;mask for min size test
					;
#define	NudgeSz	Deg0.10			;size of nudge movement
#define	NudgeCnt	Deg5.0/NudgeSz		;max deg of nudge movement in any direction
					;
#define	HJDeg	Deg0.10			;size of hand controller movements
#define	HJsCnt	10			;number of small HJ moves before big

#define	Alt2High	(Deg90-Deg10)		;max solar altitude to dp azi sun lock
					;
;-----------------------------------------------------------;
					;ok we have defined the enviroment, so lets put some modules together to make the code
	org	0x0000			;program memory address for the start of page 0 (also power on reset entry point)
					;
	#include SuperTATF88Main.asm		;main program loads here
					;
pg1avil	equ	0x0800-$			;calc spare memory in program memory block 0
					;
	org	0x0800			;program memory address for the start of page 1
					;
	#include SuperTAtF88Comms.asm		;Comms and misc code load next
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
;	call	SetCom			;setup port b for comms mode
;	SndL	'5'			;ident this message
;	call	SendSC			;dump the data down the com line
;	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
