#define 	TATSec	18			;seconds per track adjust (normally 18)
#define	HbPSec	4			;heart beats per second (normally 4)
#define	SLkmin	3			;minutes between SunLocks
#define	OnSunM	(SLkmin*60)/TATSec		;TAT cycles between SunLocks
#define	SCells	8			;number of series cells inside SunCube
#define	NorLok	(Adc18V*VAdj)/100		;normal op min solar voltage to do a sun lock
#define	MorLok	(Adc13V*VAdj)/100		;morning wake up min solar voltage to do a sun lock

#define	AltCalDeg	Deg20			;alt West recal degs

	#include Mark9.asm			;code for page 0
	#include TAT_20Deg.asm		;TAT goes at the start of page 1
	#include Comms.asm			;code for page 1 (more than comms)

;----------------------------------------
; program end
;----------------------------------------

PeVer	dt	Version
PeCopy	dt	CopyRight

pg2avil	equ	0x1000-$

	org	0x0fff

	dw	0;(0x0000-0x0c65)		;store program memory check sum byte

	end

;################ Spare unused code ################
 
;>>>>>>>>>>> DEBUG CODE START <<<<<<<<<<
	call	SetCom			;setup port b for comms mode
	SndL	'5'			;ident this message
	call	SendSC			;dump the data down the com line
	call	SetHJ			;setup port b for hand controller mode
;>>>>>>>>>>> DEBUG CODE END <<<<<<<<<<
