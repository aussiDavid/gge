#define 	TATSec	18			;seconds per track adjust (normally 18)
#define	HbPSec	4			;heart beats per second (normally 4)
#define	SLkmin	3			;minutes between SunLocks
#define	OnSunM	(SLkmin*60)/TATSec		;TAT cycles between SunLocks
#define	SCells	9			;number of series cells inside SunCube
#define	NorLok	(Adc14V*VAdj)/100		;normal op min solar voltage to do a sun lock
#define	MorLok	(Adc10V*VAdj)/100		;morning wake up min solar voltage to do a sun lock

#define	DegNSlp	(Deg360-Deg45)		;over night sleep alt degrees
#define	DegSlp	Deg5.0			;deg trigger to go to sleep and to wake up
#define	AltCalDeg	Deg15			;alt West recal degs

#define	FTAzi	Deg240			;start fast track azi

#define	TATVer	"20 Deg, "			;define TAT used
#define	Retro	1			;enable retro azi tracking movement

	#include Mark9.asm			;code for page 0
	#include TAT_20Deg.asm			;TAT goes at the start of page 1
	#include Comms.asm			;code for page 1 (more than comms)

;----------------------------------------
; program end
;----------------------------------------

pg2avil	equ	0x1000-$

	org	0x0fff			;point to end of program memory

	dw	0;(0x0000-0x0c65)		;store program memory check sum byte

	end

;################ Spare unused code ################
 
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
	call	SetCom			;setup port b for comms mode
	SndL	'5'			;ident this message
	call	SendSC			;dump the data down the com line
	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
