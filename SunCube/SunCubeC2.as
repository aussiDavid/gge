opt subtitle "HI-TECH Software Omniscient Code Generator (PRO mode) build 5239"

opt pagewidth 120

	opt pm

	processor	16F88
clrc	macro
	bcf	3,0
	endm
clrz	macro
	bcf	3,2
	endm
setc	macro
	bsf	3,0
	endm
setz	macro
	bsf	3,2
	endm
skipc	macro
	btfss	3,0
	endm
skipz	macro
	btfss	3,2
	endm
skipnc	macro
	btfsc	3,0
	endm
skipnz	macro
	btfsc	3,2
	endm
indf	equ	0
indf0	equ	0
pc	equ	2
pcl	equ	2
status	equ	3
fsr	equ	4
fsr0	equ	4
c	equ	1
z	equ	0
pclath	equ	10
;COMMON:	_main->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_main->_sin
;BANK1:	_sin->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_sin->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	_sin->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_main->_acos
;BANK1:	_acos->_asin
;BANK0:	_asin->_fabs
;BANK1:	_fabs->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_asin->_sqrt
;BANK1:	_sqrt->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	_asin->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_asin->_atan
;BANK0:	_atan->_fabs
;BANK1:	_fabs->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	_atan->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_atan->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_asin->_sin
;BANK1:	_sin->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_sin->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	_sin->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_acos->_sin
;BANK1:	_sin->___ftneg
;BANK1:	___ftneg->___ftsub
;BANK1:	___ftsub->___ftmul
;BANK0:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftmul->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftmul->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftsub->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftsub->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	___ftneg->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	_sin->_floor
;BANK0:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	_floor->___ftadd
;COMMON:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK0:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;BANK1:	___ftadd->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
;COMMON:	_sin->___ftdiv
;COMMON:	___ftdiv->_eval_poly
;BANK0:	___ftdiv->_eval_poly
	FNCALL	_main,___ftdiv
	FNCALL	_main,___ftadd
	FNCALL	_main,___awdiv
	FNCALL	_main,___aldiv
	FNCALL	_main,___lmul
	FNCALL	_main,___altoft
	FNCALL	_main,___ftmul
	FNCALL	_main,___ftsub
	FNCALL	_main,_sin
	FNCALL	_main,_cos
	FNCALL	_main,_atan2
	FNCALL	_main,___ftge
	FNCALL	_main,_asin
	FNCALL	_main,_acos
	FNCALL	_main,___ftneg
	FNCALL	_main,_tan
	FNCALL	_atan2,___ftge
	FNCALL	_atan2,_fabs
	FNCALL	_atan2,___ftdiv
	FNCALL	_atan2,_atan
	FNCALL	_atan2,___ftadd
	FNCALL	_atan2,___ftsub
	FNCALL	_atan2,___ftneg
	FNCALL	_tan,_sin
	FNCALL	_tan,_cos
	FNCALL	_tan,___ftdiv
	FNCALL	_acos,_asin
	FNCALL	_acos,___ftsub
	FNCALL	_cos,___ftge
	FNCALL	_cos,___ftadd
	FNCALL	_cos,_sin
	FNCALL	_asin,_fabs
	FNCALL	_asin,___ftge
	FNCALL	_asin,___ftmul
	FNCALL	_asin,___ftsub
	FNCALL	_asin,_sqrt
	FNCALL	_asin,___ftdiv
	FNCALL	_asin,_atan
	FNCALL	_asin,___ftneg
	FNCALL	_atan,_fabs
	FNCALL	_atan,___ftge
	FNCALL	_atan,___ftdiv
	FNCALL	_atan,___ftmul
	FNCALL	_atan,_eval_poly
	FNCALL	_atan,___ftsub
	FNCALL	_atan,___ftneg
	FNCALL	_sqrt,___ftge
	FNCALL	_sqrt,___ftmul
	FNCALL	_sqrt,___ftsub
	FNCALL	_sin,___ftge
	FNCALL	_sin,___ftneg
	FNCALL	_sin,___ftmul
	FNCALL	_sin,_floor
	FNCALL	_sin,___ftsub
	FNCALL	_sin,_eval_poly
	FNCALL	_sin,___ftdiv
	FNCALL	_eval_poly,___ftmul
	FNCALL	_eval_poly,___ftadd
	FNCALL	___ftdiv,___ftpack
	FNCALL	___ftsub,___ftadd
	FNCALL	_fabs,___ftge
	FNCALL	_fabs,___ftneg
	FNCALL	_floor,_frexp
	FNCALL	_floor,___ftge
	FNCALL	_floor,___fttol
	FNCALL	_floor,___altoft
	FNCALL	_floor,___ftadd
	FNCALL	___ftmul,___ftpack
	FNCALL	___altoft,___ftpack
	FNCALL	___ftadd,___ftpack
	FNROOT	_main
	global	atan@coeff_a
psect	strings,class=CODE,delta=2,reloc=256
global __pstrings
__pstrings:
	global	stringdir,stringtab,__stringbase,stringjmp
stringtab:
;	String table - string pointers are 1 byte each
	movwf	(btemp)&07Fh
	btfss	(btemp)&07Fh,7
	goto	stringcode
	bcf	status,7
	btfsc	btemp&7Fh,0
	bsf	status,7
	movf	indf,w
	return
stringcode:
	movf	fsr,w
stringdir:
movwf btemp&07Fh
movlw high(stringdir)
movwf pclath
movf btemp&07Fh,w
stringjmp:
	addwf pc
__stringbase:
	retlw	0
psect	strings
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan.c"
	line	10
atan@coeff_a:
	retlw	0x3c
	retlw	0x4
	retlw	0x42

	retlw	0x9f
	retlw	0x6a
	retlw	0x42

	retlw	0x90
	retlw	0x1
	retlw	0x42

	retlw	0x4d
	retlw	0xbb
	retlw	0x40

	retlw	0xec
	retlw	0x47
	retlw	0x3e

	retlw	0x8e
	retlw	0x1f
	retlw	0xbb

	global	atan@coeff_b
psect	strings
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan.c"
	line	19
atan@coeff_b:
	retlw	0x3c
	retlw	0x4
	retlw	0x42

	retlw	0x5a
	retlw	0x8b
	retlw	0x42

	retlw	0x4
	retlw	0x44
	retlw	0x42

	retlw	0x9c
	retlw	0x4f
	retlw	0x41

	retlw	0x0
	retlw	0x80
	retlw	0x3f

	global	sin@coeff_a
psect	strings
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\sin.c"
	line	15
sin@coeff_a:
	retlw	0xf4
	retlw	0x4a
	retlw	0x48

	retlw	0x95
	retlw	0x95
	retlw	0xc7

	retlw	0xc1
	retlw	0xdc
	retlw	0x45

	retlw	0xdc
	retlw	0x6d
	retlw	0xc3

	retlw	0xb3
	retlw	0x33
	retlw	0x40

	global	sin@coeff_b
psect	strings
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\sin.c"
	line	23
sin@coeff_b:
	retlw	0x34
	retlw	0x1
	retlw	0x48

	retlw	0x9d
	retlw	0xb0
	retlw	0x45

	retlw	0x0
	retlw	0xda
	retlw	0x42

	retlw	0x0
	retlw	0x80
	retlw	0x3f

	global	atan@coeff_a
	global	atan@coeff_b
	global	sin@coeff_a
	global	sin@coeff_b
	global	_ADCON0
_ADCON0  equ     31
	global	_ADRESH
_ADRESH  equ     30
	global	_CCP1CON
_CCP1CON  equ     23
	global	_CCPR1H
_CCPR1H  equ     22
	global	_CCPR1L
_CCPR1L  equ     21
	global	_FSR
_FSR  equ     4
	global	_INDF
_INDF  equ     0
	global	_INTCON
_INTCON  equ     11
	global	_PCL
_PCL  equ     2
	global	_PCLATH
_PCLATH  equ     10
	global	_PIR1
_PIR1  equ     12
	global	_PIR2
_PIR2  equ     13
	global	_PORTA
_PORTA  equ     5
	global	_PORTB
_PORTB  equ     6
	global	_RCREG
_RCREG  equ     26
	global	_RCSTA
_RCSTA  equ     24
	global	_SSPBUF
_SSPBUF  equ     19
	global	_SSPCON
_SSPCON  equ     20
	global	_STATUS
_STATUS  equ     3
	global	_T1CON
_T1CON  equ     16
	global	_T2CON
_T2CON  equ     18
	global	_TMR0
_TMR0  equ     1
	global	_TMR1H
_TMR1H  equ     15
	global	_TMR1L
_TMR1L  equ     14
	global	_TMR2
_TMR2  equ     17
	global	_TXREG
_TXREG  equ     25
	global	_ADCS0
_ADCS0  equ     254
	global	_ADCS1
_ADCS1  equ     255
	global	_ADDEN
_ADDEN  equ     195
	global	_ADGO
_ADGO  equ     250
	global	_ADIF
_ADIF  equ     102
	global	_ADON
_ADON  equ     248
	global	_CARRY
_CARRY  equ     24
	global	_CCP1IF
_CCP1IF  equ     98
	global	_CCP1M0
_CCP1M0  equ     184
	global	_CCP1M1
_CCP1M1  equ     185
	global	_CCP1M2
_CCP1M2  equ     186
	global	_CCP1M3
_CCP1M3  equ     187
	global	_CCP1X
_CCP1X  equ     189
	global	_CCP1Y
_CCP1Y  equ     188
	global	_CHS0
_CHS0  equ     251
	global	_CHS1
_CHS1  equ     252
	global	_CHS2
_CHS2  equ     253
	global	_CKP
_CKP  equ     164
	global	_CMIF
_CMIF  equ     110
	global	_CREN
_CREN  equ     196
	global	_DC
_DC  equ     25
	global	_EEIF
_EEIF  equ     108
	global	_FERR
_FERR  equ     194
	global	_GIE
_GIE  equ     95
	global	_GODONE
_GODONE  equ     250
	global	_INT0IE
_INT0IE  equ     92
	global	_INT0IF
_INT0IF  equ     89
	global	_IRP
_IRP  equ     31
	global	_OERR
_OERR  equ     193
	global	_OSFIF
_OSFIF  equ     111
	global	_PD
_PD  equ     27
	global	_PEIE
_PEIE  equ     94
	global	_RA0
_RA0  equ     40
	global	_RA1
_RA1  equ     41
	global	_RA2
_RA2  equ     42
	global	_RA3
_RA3  equ     43
	global	_RA4
_RA4  equ     44
	global	_RA5
_RA5  equ     45
	global	_RA6
_RA6  equ     46
	global	_RA7
_RA7  equ     47
	global	_RB0
_RB0  equ     48
	global	_RB1
_RB1  equ     49
	global	_RB2
_RB2  equ     50
	global	_RB3
_RB3  equ     51
	global	_RB4
_RB4  equ     52
	global	_RB5
_RB5  equ     53
	global	_RB6
_RB6  equ     54
	global	_RB7
_RB7  equ     55
	global	_RBIE
_RBIE  equ     91
	global	_RBIF
_RBIF  equ     88
	global	_RCIF
_RCIF  equ     101
	global	_RP0
_RP0  equ     29
	global	_RP1
_RP1  equ     30
	global	_RX9
_RX9  equ     198
	global	_RX9D
_RX9D  equ     192
	global	_SPEN
_SPEN  equ     199
	global	_SREN
_SREN  equ     197
	global	_SSPEN
_SSPEN  equ     165
	global	_SSPIF
_SSPIF  equ     99
	global	_SSPM0
_SSPM0  equ     160
	global	_SSPM1
_SSPM1  equ     161
	global	_SSPM2
_SSPM2  equ     162
	global	_SSPM3
_SSPM3  equ     163
	global	_SSPOV
_SSPOV  equ     166
	global	_T1CKPS0
_T1CKPS0  equ     132
	global	_T1CKPS1
_T1CKPS1  equ     133
	global	_T1OSCEN
_T1OSCEN  equ     131
	global	_T1RUN
_T1RUN  equ     134
	global	_T1SYNC
_T1SYNC  equ     130
	global	_T2CKPS0
_T2CKPS0  equ     144
	global	_T2CKPS1
_T2CKPS1  equ     145
	global	_TMR0IE
_TMR0IE  equ     93
	global	_TMR0IF
_TMR0IF  equ     90
	global	_TMR1CS
_TMR1CS  equ     129
	global	_TMR1IF
_TMR1IF  equ     96
	global	_TMR1ON
_TMR1ON  equ     128
	global	_TMR2IF
_TMR2IF  equ     97
	global	_TMR2ON
_TMR2ON  equ     146
	global	_TO
_TO  equ     28
	global	_TOUTPS0
_TOUTPS0  equ     147
	global	_TOUTPS1
_TOUTPS1  equ     148
	global	_TOUTPS2
_TOUTPS2  equ     149
	global	_TOUTPS3
_TOUTPS3  equ     150
	global	_TXIF
_TXIF  equ     100
	global	_WCOL
_WCOL  equ     167
	global	_ZERO
_ZERO  equ     26
	global	_ADCON1
_ADCON1  equ     159
	global	_ADRESL
_ADRESL  equ     158
	global	_ANSEL
_ANSEL  equ     155
	global	_CMCON
_CMCON  equ     156
	global	_CVRCON
_CVRCON  equ     157
	global	_OPTION
_OPTION  equ     129
	global	_OSCCON
_OSCCON  equ     143
	global	_OSCTUNE
_OSCTUNE  equ     144
	global	_PCON
_PCON  equ     142
	global	_PIE1
_PIE1  equ     140
	global	_PIE2
_PIE2  equ     141
	global	_PR2
_PR2  equ     146
	global	_SPBRG
_SPBRG  equ     153
	global	_SSPADD
_SSPADD  equ     147
	global	_SSPSTAT
_SSPSTAT  equ     148
	global	_TRISA
_TRISA  equ     133
	global	_TRISB
_TRISB  equ     134
	global	_TXSTA
_TXSTA  equ     152
	global	_ADCS2
_ADCS2  equ     1278
	global	_ADFM
_ADFM  equ     1279
	global	_ADIE
_ADIE  equ     1126
	global	_ANS0
_ANS0  equ     1240
	global	_ANS1
_ANS1  equ     1241
	global	_ANS2
_ANS2  equ     1242
	global	_ANS3
_ANS3  equ     1243
	global	_ANS4
_ANS4  equ     1244
	global	_ANS5
_ANS5  equ     1245
	global	_ANS6
_ANS6  equ     1246
	global	_BF
_BF  equ     1184
	global	_BOR
_BOR  equ     1136
	global	_BRGH
_BRGH  equ     1218
	global	_C1INV
_C1INV  equ     1252
	global	_C1OUT
_C1OUT  equ     1254
	global	_C2INV
_C2INV  equ     1253
	global	_C2OUT
_C2OUT  equ     1255
	global	_CCP1IE
_CCP1IE  equ     1122
	global	_CIS
_CIS  equ     1251
	global	_CKE
_CKE  equ     1190
	global	_CM0
_CM0  equ     1248
	global	_CM1
_CM1  equ     1249
	global	_CM2
_CM2  equ     1250
	global	_CMIE
_CMIE  equ     1134
	global	_CSRC
_CSRC  equ     1223
	global	_CVR0
_CVR0  equ     1256
	global	_CVR1
_CVR1  equ     1257
	global	_CVR2
_CVR2  equ     1258
	global	_CVR3
_CVR3  equ     1259
	global	_CVREN
_CVREN  equ     1263
	global	_CVROE
_CVROE  equ     1262
	global	_CVRR
_CVRR  equ     1261
	global	_DA
_DA  equ     1189
	global	_EEIE
_EEIE  equ     1132
	global	_INTEDG
_INTEDG  equ     1038
	global	_IOFS
_IOFS  equ     1146
	global	_IRCF0
_IRCF0  equ     1148
	global	_IRCF1
_IRCF1  equ     1149
	global	_IRCF2
_IRCF2  equ     1150
	global	_OSFIE
_OSFIE  equ     1135
	global	_OSTS
_OSTS  equ     1147
	global	_POR
_POR  equ     1137
	global	_PS0
_PS0  equ     1032
	global	_PS1
_PS1  equ     1033
	global	_PS2
_PS2  equ     1034
	global	_PSA
_PSA  equ     1035
	global	_RBPU
_RBPU  equ     1039
	global	_RCIE
_RCIE  equ     1125
	global	_RW
_RW  equ     1186
	global	_SCS0
_SCS0  equ     1144
	global	_SCS1
_SCS1  equ     1145
	global	_SMP
_SMP  equ     1191
	global	_SSPIE
_SSPIE  equ     1123
	global	_START
_START  equ     1187
	global	_STOP
_STOP  equ     1188
	global	_SYNC
_SYNC  equ     1220
	global	_T0CS
_T0CS  equ     1037
	global	_T0SE
_T0SE  equ     1036
	global	_TMR1IE
_TMR1IE  equ     1120
	global	_TMR2IE
_TMR2IE  equ     1121
	global	_TRISA0
_TRISA0  equ     1064
	global	_TRISA1
_TRISA1  equ     1065
	global	_TRISA2
_TRISA2  equ     1066
	global	_TRISA3
_TRISA3  equ     1067
	global	_TRISA4
_TRISA4  equ     1068
	global	_TRISA5
_TRISA5  equ     1069
	global	_TRISA6
_TRISA6  equ     1070
	global	_TRISA7
_TRISA7  equ     1071
	global	_TRISB0
_TRISB0  equ     1072
	global	_TRISB1
_TRISB1  equ     1073
	global	_TRISB2
_TRISB2  equ     1074
	global	_TRISB3
_TRISB3  equ     1075
	global	_TRISB4
_TRISB4  equ     1076
	global	_TRISB5
_TRISB5  equ     1077
	global	_TRISB6
_TRISB6  equ     1078
	global	_TRISB7
_TRISB7  equ     1079
	global	_TRMT
_TRMT  equ     1217
	global	_TUN0
_TUN0  equ     1152
	global	_TUN1
_TUN1  equ     1153
	global	_TUN2
_TUN2  equ     1154
	global	_TUN3
_TUN3  equ     1155
	global	_TUN4
_TUN4  equ     1156
	global	_TUN5
_TUN5  equ     1157
	global	_TX9
_TX9  equ     1222
	global	_TX9D
_TX9D  equ     1216
	global	_TXEN
_TXEN  equ     1221
	global	_TXIE
_TXIE  equ     1124
	global	_UA
_UA  equ     1185
	global	_VCFG0
_VCFG0  equ     1276
	global	_VCFG1
_VCFG1  equ     1277
	global	_EEADR
_EEADR  equ     269
	global	_EEADRH
_EEADRH  equ     271
	global	_EEADRL
_EEADRL  equ     269
	global	_EEDAT
_EEDAT  equ     268
	global	_EEDATA
_EEDATA  equ     268
	global	_EEDATH
_EEDATH  equ     270
	global	_WDTCON
_WDTCON  equ     261
	global	_SWDTEN
_SWDTEN  equ     2088
	global	_WDTPS0
_WDTPS0  equ     2089
	global	_WDTPS1
_WDTPS1  equ     2090
	global	_WDTPS2
_WDTPS2  equ     2091
	global	_WDTPS3
_WDTPS3  equ     2092
	global	_EECON1
_EECON1  equ     396
	global	_EECON2
_EECON2  equ     397
	global	_EEPGD
_EEPGD  equ     3175
	global	_FREE
_FREE  equ     3172
	global	_RD
_RD  equ     3168
	global	_WR
_WR  equ     3169
	global	_WREN
_WREN  equ     3170
	global	_WRERR
_WRERR  equ     3171
	file	"SunCubeC2.as"
	line	#
psect cinit,class=CODE,delta=2
global start_initialization
start_initialization:

psect cinit,class=CODE,delta=2
global end_of_initialization

;End of C runtime variable initationation code

end_of_initialization:
clrf status
ljmp _main	;jump to C main() function
psect	cstackBANK3,class=BANK3,space=1
global __pcstackBANK3
__pcstackBANK3:
	global	_main$983
_main$983:	; 4 bytes @ 0x0
	ds	4
	global	_main$992
_main$992:	; 3 bytes @ 0x4
	ds	3
	global	main@dLatitude
main@dLatitude:	; 3 bytes @ 0x7
	ds	3
	global	_main$993
_main$993:	; 3 bytes @ 0xA
	ds	3
	global	_main$990
_main$990:	; 3 bytes @ 0xD
	ds	3
	global	_main$986
_main$986:	; 3 bytes @ 0x10
	ds	3
	global	_main$987
_main$987:	; 3 bytes @ 0x13
	ds	3
	global	_main$981
_main$981:	; 3 bytes @ 0x16
	ds	3
	global	main@dSeconds
main@dSeconds:	; 3 bytes @ 0x19
	ds	3
	global	main@dMinutes
main@dMinutes:	; 3 bytes @ 0x1C
	ds	3
	global	main@dHours
main@dHours:	; 3 bytes @ 0x1F
	ds	3
	global	_main$994
_main$994:	; 3 bytes @ 0x22
	ds	3
	global	main@dLongitude
main@dLongitude:	; 3 bytes @ 0x25
	ds	3
	global	main@iDay
main@iDay:	; 2 bytes @ 0x28
	ds	2
	global	main@liAux2
main@liAux2:	; 4 bytes @ 0x2A
	ds	4
	global	main@dLocalMeanSiderealTime
main@dLocalMeanSiderealTime:	; 3 bytes @ 0x2E
	ds	3
	global	main@dGreenwichMeanSiderealTime
main@dGreenwichMeanSiderealTime:	; 3 bytes @ 0x31
	ds	3
	global	main@dMeanLongitude
main@dMeanLongitude:	; 3 bytes @ 0x34
	ds	3
	global	main@iYear
main@iYear:	; 2 bytes @ 0x37
	ds	4
	global	main@dSin_Latitude
main@dSin_Latitude:	; 3 bytes @ 0x3B
	ds	3
	global	main@dCos_Latitude
main@dCos_Latitude:	; 3 bytes @ 0x3E
	ds	3
	global	main@dHourAngle
main@dHourAngle:	; 3 bytes @ 0x41
	ds	3
	global	main@dMeanAnomaly
main@dMeanAnomaly:	; 3 bytes @ 0x44
	ds	3
	global	_main$988
_main$988:	; 3 bytes @ 0x47
	ds	3
	global	main@dCos_HourAngle
main@dCos_HourAngle:	; 3 bytes @ 0x4A
	ds	3
	global	main@dDecimalHours
main@dDecimalHours:	; 3 bytes @ 0x4D
	ds	3
	global	main@dEclipticObliquity
main@dEclipticObliquity:	; 3 bytes @ 0x50
	ds	3
	global	_main$991
_main$991:	; 3 bytes @ 0x53
	ds	3
	global	main@dEclipticLongitude
main@dEclipticLongitude:	; 3 bytes @ 0x56
	ds	3
	global	main@dLatitudeInRadians
main@dLatitudeInRadians:	; 3 bytes @ 0x59
	ds	3
	global	main@dSin_EclipticLongitude
main@dSin_EclipticLongitude:	; 3 bytes @ 0x5C
	ds	3
psect	cstackBANK2,class=BANK2,space=1
global __pcstackBANK2
__pcstackBANK2:
	global	main@dOmega
main@dOmega:	; 3 bytes @ 0x0
	ds	3
	global	main@dY
main@dY:	; 3 bytes @ 0x3
	ds	3
	global	main@dZenithAngle
main@dZenithAngle:	; 3 bytes @ 0x6
	ds	3
	global	main@dX
main@dX:	; 3 bytes @ 0x9
	ds	3
	global	main@liAux1
main@liAux1:	; 4 bytes @ 0xC
	ds	4
	global	main@dDeclination
main@dDeclination:	; 3 bytes @ 0x10
	ds	3
	global	main@dRightAscension
main@dRightAscension:	; 3 bytes @ 0x13
	ds	3
	global	_main$989
_main$989:	; 3 bytes @ 0x16
	ds	3
	global	main@dAzimuth
main@dAzimuth:	; 3 bytes @ 0x19
	ds	3
	global	_main$982
_main$982:	; 3 bytes @ 0x1C
	ds	3
	global	main@dElapsedJulianDays
main@dElapsedJulianDays:	; 3 bytes @ 0x1F
	ds	3
	global	_main$985
_main$985:	; 3 bytes @ 0x22
	ds	3
psect	cstackBANK1,class=BANK1,space=1
global __pcstackBANK1
__pcstackBANK1:
	global	?___ftdiv
?___ftdiv: ;@ 0x0
	global	___ftdiv@f1
___ftdiv@f1:	; 3 bytes @ 0x0
	ds	3
	global	___ftdiv@f2
___ftdiv@f2:	; 3 bytes @ 0x3
	ds	3
	global	___ftadd@sign
___ftadd@sign:	; 1 bytes @ 0x6
	ds	1
	global	___ftadd@exp2
___ftadd@exp2:	; 1 bytes @ 0x7
	ds	1
	global	___ftadd@exp1
___ftadd@exp1:	; 1 bytes @ 0x8
	ds	1
	global	?___ftadd
?___ftadd: ;@ 0x9
	global	___ftadd@f1
___ftadd@f1:	; 3 bytes @ 0x9
	ds	3
	global	___ftadd@f2
___ftadd@f2:	; 3 bytes @ 0xC
	ds	3
	global	___ftmul@exp
___ftmul@exp:	; 1 bytes @ 0xF
	ds	1
	global	___ftmul@f3_as_product
___ftmul@f3_as_product:	; 3 bytes @ 0x10
	ds	3
	global	___ftmul@cntr
___ftmul@cntr:	; 1 bytes @ 0x13
	ds	1
	global	___ftmul@sign
___ftmul@sign:	; 1 bytes @ 0x14
	ds	1
	global	?___ftmul
?___ftmul: ;@ 0x15
	global	___ftmul@f1
___ftmul@f1:	; 3 bytes @ 0x15
	ds	3
	global	___ftmul@f2
___ftmul@f2:	; 3 bytes @ 0x18
	ds	3
	global	?___ftsub
?___ftsub: ;@ 0x1B
	global	___ftsub@f1
___ftsub@f1:	; 3 bytes @ 0x1B
	ds	3
	global	___ftsub@f2
___ftsub@f2:	; 3 bytes @ 0x1E
	ds	3
	global	?___ftneg
?___ftneg: ;@ 0x21
	global	sqrt@z
sqrt@z:	; 3 bytes @ 0x21
	global	___ftneg@f1
___ftneg@f1:	; 3 bytes @ 0x21
	ds	3
	global	sqrt@i
sqrt@i:	; 1 bytes @ 0x24
	global	_atan$1005
_atan$1005:	; 3 bytes @ 0x24
	global	_sin$1007
_sin$1007:	; 3 bytes @ 0x24
	ds	1
	global	sqrt@q
sqrt@q:	; 3 bytes @ 0x25
	ds	2
	global	atan@recip
atan@recip:	; 1 bytes @ 0x27
	global	sin@y
sin@y:	; 3 bytes @ 0x27
	ds	1
	global	sqrt@x
sqrt@x:	; 3 bytes @ 0x28
	global	atan@val_squared
atan@val_squared:	; 3 bytes @ 0x28
	ds	2
	global	sin@x2
sin@x2:	; 3 bytes @ 0x2A
	ds	1
	global	?_sqrt
?_sqrt: ;@ 0x2B
	global	sqrt@y
sqrt@y:	; 3 bytes @ 0x2B
	global	atan@val
atan@val:	; 3 bytes @ 0x2B
	ds	2
	global	sin@sgn
sin@sgn:	; 1 bytes @ 0x2D
	ds	1
	global	?_atan
?_atan: ;@ 0x2E
	global	_cos$1006
_cos$1006:	; 3 bytes @ 0x2E
	global	atan@f
atan@f:	; 3 bytes @ 0x2E
	ds	3
	global	?_cos
?_cos: ;@ 0x31
	global	cos@f
cos@f:	; 3 bytes @ 0x31
	global	_asin$997
_asin$997:	; 3 bytes @ 0x31
	global	_atan2$1002
_atan2$1002:	; 3 bytes @ 0x31
	ds	3
	global	_atan2$1004
_atan2$1004:	; 3 bytes @ 0x34
	global	_asin$998
_asin$998:	; 3 bytes @ 0x34
	global	_tan$1009
_tan$1009:	; 3 bytes @ 0x34
	ds	3
	global	_tan$1008
_tan$1008:	; 3 bytes @ 0x37
	global	_asin$996
_asin$996:	; 3 bytes @ 0x37
	global	_atan2$1001
_atan2$1001:	; 3 bytes @ 0x37
	ds	3
	global	?_tan
?_tan: ;@ 0x3A
	global	_atan2$1003
_atan2$1003:	; 3 bytes @ 0x3A
	global	tan@x
tan@x:	; 3 bytes @ 0x3A
	global	_asin$1000
_asin$1000:	; 3 bytes @ 0x3A
	ds	3
	global	atan2@v
atan2@v:	; 3 bytes @ 0x3D
	global	asin@y
asin@y:	; 3 bytes @ 0x3D
	ds	3
	global	?_atan2
?_atan2: ;@ 0x40
	global	_asin$999
_asin$999:	; 3 bytes @ 0x40
	global	atan2@y
atan2@y:	; 3 bytes @ 0x40
	ds	3
	global	?_asin
?_asin: ;@ 0x43
	global	asin@x
asin@x:	; 3 bytes @ 0x43
	global	atan2@x
atan2@x:	; 3 bytes @ 0x43
	ds	3
	global	_acos$995
_acos$995:	; 3 bytes @ 0x46
	ds	3
	global	?_acos
?_acos: ;@ 0x49
	global	acos@x
acos@x:	; 3 bytes @ 0x49
	ds	3
	global	_main$984
_main$984:	; 4 bytes @ 0x4C
	ds	4
psect	cstackCOMMON,class=COMMON,space=1
global __pcstackCOMMON
__pcstackCOMMON:
	global	??___aldiv
??___aldiv: ;@ 0x0
	global	??___lmul
??___lmul: ;@ 0x0
	global	?___ftge
?___ftge: ;@ 0x0
	global	??___ftge
??___ftge: ;@ 0x0
	global	??_frexp
??_frexp: ;@ 0x0
	global	??___ftpack
??___ftpack: ;@ 0x0
	global	??___fttol
??___fttol: ;@ 0x0
	global	??___awdiv
??___awdiv: ;@ 0x0
	global	___awdiv@counter
___awdiv@counter:	; 1 bytes @ 0x0
	global	___ftge@ff1
___ftge@ff1:	; 3 bytes @ 0x0
	global	___lmul@product
___lmul@product:	; 4 bytes @ 0x0
	ds	1
	global	___awdiv@sign
___awdiv@sign:	; 1 bytes @ 0x1
	ds	1
	global	___awdiv@quotient
___awdiv@quotient:	; 2 bytes @ 0x2
	ds	1
	global	??___altoft
??___altoft: ;@ 0x3
	global	?___fttol
?___fttol: ;@ 0x3
	global	___ftge@ff2
___ftge@ff2:	; 3 bytes @ 0x3
	global	___fttol@f1
___fttol@f1:	; 3 bytes @ 0x3
	ds	4
	global	??___ftneg
??___ftneg: ;@ 0x7
	global	??___ftsub
??___ftsub: ;@ 0x7
	global	??_fabs
??_fabs: ;@ 0x7
	global	??_floor
??_floor: ;@ 0x7
	global	??_tan
??_tan: ;@ 0x7
	global	??_asin
??_asin: ;@ 0x7
	global	??_cos
??_cos: ;@ 0x7
	global	??_atan2
??_atan2: ;@ 0x7
	global	??_atan
??_atan: ;@ 0x7
	global	??_sin
??_sin: ;@ 0x7
	global	??_acos
??_acos: ;@ 0x7
	global	??_eval_poly
??_eval_poly: ;@ 0x7
	ds	4
	global	??___ftdiv
??___ftdiv: ;@ 0xB
	ds	3
psect	cstackBANK0,class=BANK0,space=1
global __pcstackBANK0
__pcstackBANK0:
	global	?_frexp
?_frexp: ;@ 0x0
	global	___fttol@sign1
___fttol@sign1:	; 1 bytes @ 0x0
	global	?___awdiv
?___awdiv: ;@ 0x0
	global	___awdiv@dividend
___awdiv@dividend:	; 2 bytes @ 0x0
	global	?___ftpack
?___ftpack: ;@ 0x0
	global	frexp@value
frexp@value:	; 3 bytes @ 0x0
	global	___ftpack@arg
___ftpack@arg:	; 3 bytes @ 0x0
	global	?___lmul
?___lmul: ;@ 0x0
	global	___lmul@multiplier
___lmul@multiplier:	; 4 bytes @ 0x0
	ds	1
	global	___fttol@lval
___fttol@lval:	; 4 bytes @ 0x1
	ds	1
	global	___awdiv@divisor
___awdiv@divisor:	; 2 bytes @ 0x2
	ds	1
	global	frexp@eptr
frexp@eptr:	; 1 bytes @ 0x3
	global	___ftpack@exp
___ftpack@exp:	; 1 bytes @ 0x3
	ds	1
	global	___ftpack@sign
___ftpack@sign:	; 1 bytes @ 0x4
	global	___lmul@multiplicand
___lmul@multiplicand:	; 4 bytes @ 0x4
	ds	1
	global	___fttol@exp1
___fttol@exp1:	; 1 bytes @ 0x5
	ds	1
	global	___altoft@sign
___altoft@sign:	; 1 bytes @ 0x6
	global	eval_poly@res
eval_poly@res:	; 3 bytes @ 0x6
	ds	1
	global	___altoft@exp
___altoft@exp:	; 1 bytes @ 0x7
	ds	1
	global	?___altoft
?___altoft: ;@ 0x8
	global	___aldiv@counter
___aldiv@counter:	; 1 bytes @ 0x8
	global	___altoft@c
___altoft@c:	; 4 bytes @ 0x8
	ds	1
	global	___aldiv@sign
___aldiv@sign:	; 1 bytes @ 0x9
	global	?_eval_poly
?_eval_poly: ;@ 0x9
	global	eval_poly@x
eval_poly@x:	; 3 bytes @ 0x9
	ds	1
	global	___aldiv@quotient
___aldiv@quotient:	; 4 bytes @ 0xA
	ds	2
	global	eval_poly@d
eval_poly@d:	; 1 bytes @ 0xC
	ds	1
	global	eval_poly@n
eval_poly@n:	; 2 bytes @ 0xD
	ds	1
	global	?___aldiv
?___aldiv: ;@ 0xE
	global	___aldiv@dividend
___aldiv@dividend:	; 4 bytes @ 0xE
	ds	1
	global	___ftdiv@cntr
___ftdiv@cntr:	; 1 bytes @ 0xF
	ds	1
	global	___ftdiv@f3
___ftdiv@f3:	; 3 bytes @ 0x10
	ds	2
	global	___aldiv@divisor
___aldiv@divisor:	; 4 bytes @ 0x12
	ds	1
	global	___ftdiv@exp
___ftdiv@exp:	; 1 bytes @ 0x13
	ds	1
	global	___ftdiv@sign
___ftdiv@sign:	; 1 bytes @ 0x14
	ds	1
	global	??___ftadd
??___ftadd: ;@ 0x15
	ds	3
	global	??___ftmul
??___ftmul: ;@ 0x18
	global	floor@expon
floor@expon:	; 2 bytes @ 0x18
	ds	2
	global	floor@i
floor@i:	; 3 bytes @ 0x1A
	ds	3
	global	?_floor
?_floor: ;@ 0x1D
	global	floor@x
floor@x:	; 3 bytes @ 0x1D
	ds	3
	global	??_sqrt
??_sqrt: ;@ 0x20
	global	?_fabs
?_fabs: ;@ 0x20
	global	?_sin
?_sin: ;@ 0x20
	global	fabs@d
fabs@d:	; 3 bytes @ 0x20
	global	sin@f
sin@f:	; 3 bytes @ 0x20
	ds	3
	global	??_main
??_main: ;@ 0x23
	ds	18
	global	?_main
?_main: ;@ 0x35
;Data sizes: Strings 0, constant 60, data 0, bss 0, persistent 0 stack 0
;Auto spaces:   Size  Autos    Used
; COMMON          14     14      14
; BANK0           80     53      53
; BANK1           80     80      80
; BANK3           96     95      95
; BANK2           96     37      37


;Pointer list with targets:

;?_sin	 size(1); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), 
;?___ftmul	float  size(1); Largest target is 0
;?___ftsub	float  size(1); Largest target is 0
;?___altoft	float  size(1); Largest target is 0
;?___lmul	unsigned long  size(1); Largest target is 0
;?___aldiv	long  size(1); Largest target is 0
;?___awdiv	int  size(1); Largest target is 0
;?___ftdiv	float  size(1); Largest target is 0
;?___ftadd	float  size(2); Largest target is 4
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), main@liAux2(BANK3[4]), atan@val(BANK1[3]), 
;eval_poly@d	PTR const  size(1); Largest target is 18
;		 -> atan@coeff_b(CODE[15]), atan@coeff_a(CODE[18]), sin@coeff_b(CODE[12]), sin@coeff_a(CODE[15]), 
;frexp@eptr	PTR int  size(1); Largest target is 2
;		 -> floor@expon(BANK0[2]), 
;?_cos	PTR int  size(1); Largest target is 0
;?_atan2	PTR int  size(1); Largest target is 0
;?_asin	PTR int  size(1); Largest target is 0
;?_acos	PTR int  size(1); Largest target is 0
;?___ftneg	float  size(2); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), atan@val(BANK1[3]), 
;?_tan	float  size(1); Largest target is 0
;?_fabs	float  size(1); Largest target is 0
;?_sqrt	float  size(1); Largest target is 0
;?_atan	float  size(1); Largest target is 3
;		 -> atan@val(BANK1[3]), 
;?_eval_poly	float  size(2); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), atan@val(BANK1[3]), 
;?_floor	float  size(1); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), 
;?___ftpack	float  size(2); Largest target is 4
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), main@liAux2(BANK3[4]), atan@val(BANK1[3]), 
;?___fttol	long  size(1); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), 
;?_frexp	long  size(1); Largest target is 3
;		 -> main@iYear(BANK3[2]), main@dLatitude(BANK3[3]), 


;Main: autosize = 0, tempsize = 18, incstack = 0, save=0


;Call graph:                      Base Space Used Autos Args Refs Density
;_main                                              190    0 933023   0.00
;                                   35 BANK0   18
;                                   76 BANK1    4
;                                    0 BANK3   95
;                                    0 BANK2   37
;            ___ftdiv
;            ___ftadd
;            ___awdiv
;            ___aldiv
;             ___lmul
;           ___altoft
;            ___ftmul
;            ___ftsub
;                _sin
;                _cos
;              _atan2
;             ___ftge
;               _asin
;               _acos
;            ___ftneg
;                _tan
;  ___aldiv                                           6    8  512   0.00
;                                    8 BANK0   14
;             ___lmul (ARG)
;  ___lmul                                            4    8  290   0.00
;                                    0 COMMO    4
;                                    0 BANK0    8
;            ___aldiv (ARG)
;  _atan2                                            18    6 128553   0.00
;                                   49 BANK1   21
;             ___ftge
;               _fabs
;            ___ftdiv
;               _atan
;            ___ftadd
;            ___ftsub
;            ___ftneg
;  ___awdiv                                           4    4  222   0.00
;                                    0 COMMO    4
;                                    0 BANK0    4
;  _tan                                               6    3 108840   0.00
;                                   52 BANK1    9
;                _sin
;                _cos
;            ___ftdiv
;  _acos                                              3    3 330034   0.00
;                                   70 BANK1    6
;               _asin
;            ___ftsub
;                _cos (ARG)
;                _sin (ARG)
;    _cos                                             6    3 55224   0.00
;                                   46 BANK1    6
;             ___ftge
;            ___ftadd
;                _sin
;    _asin                                           27    3 206351   0.00
;                                   49 BANK1   21
;               _fabs
;             ___ftge
;            ___ftmul
;            ___ftsub
;               _sqrt
;            ___ftdiv
;               _atan
;            ___ftneg
;                _sin (ARG)
;      _atan                                         10    3 65986   0.00
;                                   36 BANK1   13
;               _fabs
;             ___ftge
;            ___ftdiv
;            ___ftmul
;          _eval_poly
;            ___ftsub
;            ___ftneg
;      _sqrt                                         13    3 23847   0.00
;                                   32 BANK0    3
;                                   33 BANK1   13
;             ___ftge
;            ___ftmul
;            ___ftsub
;      _sin                                          10    3 51304   0.00
;                                   32 BANK0    3
;                                   36 BANK1   10
;             ___ftge
;            ___ftneg
;            ___ftmul
;              _floor
;            ___ftsub
;          _eval_poly
;            ___ftdiv
;        _eval_poly                                   7    6  990   0.00
;                                    7 COMMO    4
;                                    6 BANK0    9
;            ___ftmul
;            ___ftadd
;        ___ftdiv                                     9    6 2246   0.00
;                                   11 COMMO    3
;                                   15 BANK0    6
;                                    0 BANK1    6
;            ___ftadd (ARG)
;            ___ftmul (ARG)
;            ___ftneg (ARG)
;          _eval_poly (ARG)
;           ___ftpack
;        ___ftsub                                     0    6 17122   0.00
;                                   27 BANK1    6
;            ___ftmul (ARG)
;              _floor (ARG)
;            ___ftadd
;            ___ftdiv (ARG)
;            ___ftneg (ARG)
;        _fabs                                        0    3 19549   0.00
;                                   32 BANK0    3
;             ___ftge
;            ___ftneg
;        _floor                                       5    3 4759   0.00
;                                   24 BANK0    8
;              _frexp
;             ___ftge
;            ___fttol
;           ___altoft
;            ___ftadd
;          ___ftmul                                   9    6 6347   0.00
;                                   24 BANK0    3
;                                   15 BANK1   12
;           ___ftpack
;            ___ftadd (ARG)
;            ___ftdiv (ARG)
;          ___altoft                                  2    4  443   0.00
;                                    6 BANK0    6
;           ___ftpack
;            ___fttol (ARG)
;          ___ftadd                                   6    6 3704   0.00
;                                   21 BANK0    3
;                                    6 BANK1    9
;            ___ftdiv (ARG)
;           ___altoft (ARG)
;            ___ftmul (ARG)
;           ___ftpack
;          ___ftge                                    0    6  100   0.00
;                                    0 COMMO    6
;          ___fttol                                   9    4  186   0.00
;                                    0 COMMO    7
;                                    0 BANK0    6
;          _frexp                                     4    4  149   0.00
;                                    0 COMMO    4
;                                    0 BANK0    4
;          ___ftneg                                   0    3 19401   0.00
;                                   33 BANK1    3
;            ___ftsub (ARG)
;            ___ftdiv (ARG)
;            ___ftpack                                3    5  155   0.00
;                                    0 COMMO    3
;                                    0 BANK0    5
; Estimated maximum call depth 6
; Address spaces:

;Name               Size   Autos  Total    Cost      Usage
;BITCOMMON            E      0       0       0        0.0%
;CODE                 0      0       0       0        0.0%
;NULL                 0      0       0       0        0.0%
;COMMON               E      E       E       1      100.0%
;SFR0                 0      0       0       1        0.0%
;BITSFR0              0      0       0       1        0.0%
;BITSFR1              0      0       0       2        0.0%
;SFR1                 0      0       0       2        0.0%
;ABS                  0      0      22       2        0.0%
;STACK                0      0       0       3        0.0%
;BITBANK0            50      0       0       4        0.0%
;SFR3                 0      0       0       4        0.0%
;BITSFR3              0      0       0       4        0.0%
;BANK0               50     35      35       5       66.3%
;BITSFR2              0      0       0       5        0.0%
;SFR2                 0      0       0       5        0.0%
;BITBANK1            50      0       0       6        0.0%
;BANK1               50     50      50       7      100.0%
;BITBANK3            60      0       0       8        0.0%
;BANK3               60     5F      5F       9       99.0%
;BITBANK2            60      0       0      10        0.0%
;BANK2               60     25      25      11       38.5%
;DATA                 0      0      22      12        0.0%
;EEDATA             100      0       0    1000        0.0%

	global	_main
psect	maintext,local,class=CODE,delta=2
global __pmaintext
__pmaintext:

; *************** function _main *****************
; Defined at:
;		line 11 in file "C:\SunCube\SunPos.c"
; Parameters:    Size  Location     Type
;		None
; Auto vars:     Size  Location     Type
;  liAux1          4   12[BANK2 ] long 
;  liAux2          4   42[BANK3 ] long 
;  dElapsedJuli    3   31[BANK2 ] long 
;  dAzimuth        3   25[BANK2 ] long 
;  dRightAscens    3   19[BANK2 ] long 
;  dDeclination    3   16[BANK2 ] long 
;  dZenithAngle    3    6[BANK2 ] long 
;  dY              3    3[BANK2 ] long 
;  dX              3    9[BANK2 ] long 
;  dSin_Latitud    3   59[BANK3 ] long 
;  dSin_Eclipti    3   92[BANK3 ] long 
;  dOmega          3    0[BANK2 ] long 
;  dMeanAnomaly    3   68[BANK3 ] long 
;  dLatitudeInR    3   89[BANK3 ] long 
;  dHourAngle      3   65[BANK3 ] long 
;  dEclipticObl    3   80[BANK3 ] long 
;  dEclipticLon    3   86[BANK3 ] long 
;  dDecimalHour    3   77[BANK3 ] long 
;  dCos_Latitud    3   62[BANK3 ] long 
;  dCos_HourAng    3   74[BANK3 ] long 
;  dMeanLongitu    3   52[BANK3 ] long 
;  dLocalMeanSi    3   46[BANK3 ] long 
;  dGreenwichMe    3   49[BANK3 ] long 
;  dSeconds        3   25[BANK3 ] long 
;  dMinutes        3   28[BANK3 ] long 
;  dLongitude      3   37[BANK3 ] long 
;  dLatitude       3    7[BANK3 ] long 
;  dHours          3   31[BANK3 ] long 
;  iYear           2   55[BANK3 ] int 
;  iMonth          2    0        int 
;  iDay            2   40[BANK3 ] int 
; Return value:  Size  Location     Type
;                  2   53[BANK0 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 17F/0
;		On exit  : 160/40
;		Unchanged: FFE80/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0      18       4      95      37
;      Temp:    18
;      Total:  154
; This function calls:
;		___ftdiv
;		___ftadd
;		___awdiv
;		___aldiv
;		___lmul
;		___altoft
;		___ftmul
;		___ftsub
;		_sin
;		_cos
;		_atan2
;		___ftge
;		_asin
;		_acos
;		___ftneg
;		_tan
; This function is called by:
;		Startup code after reset
; This function uses a non-reentrant model
; 
psect	maintext
	file	"C:\SunCube\SunPos.c"
	line	11
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
;SunPos.c: 10: main()
;SunPos.c: 11: {
	
_main:	
	opt stack 7
; Regs used in _main: [allreg]
	line	13
	
l30001719:	
;SunPos.c: 13: int iYear=0;
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	clrf	(main@iYear)^0180h
	clrf	(main@iYear+1)^0180h
	line	15
;SunPos.c: 15: int iDay=0;
	clrf	(main@iDay)^0180h
	clrf	(main@iDay+1)^0180h
	
l30001720:	
	line	16
;SunPos.c: 16: double dHours=0;
	clrf	(main@dHours)^0180h
	clrf	(main@dHours+1)^0180h
	clrf	(main@dHours+2)^0180h
	
l30001721:	
	line	17
;SunPos.c: 17: double dMinutes=0;
	clrf	(main@dMinutes)^0180h
	clrf	(main@dMinutes+1)^0180h
	clrf	(main@dMinutes+2)^0180h
	
l30001722:	
	line	18
;SunPos.c: 18: double dSeconds=0;
	clrf	(main@dSeconds)^0180h
	clrf	(main@dSeconds+1)^0180h
	clrf	(main@dSeconds+2)^0180h
	
l30001723:	
	
l30001724:	
	
l30001725:	
	line	23
;SunPos.c: 23: double dLongitude=0;
	clrf	(main@dLongitude)^0180h
	clrf	(main@dLongitude+1)^0180h
	clrf	(main@dLongitude+2)^0180h
	
l30001726:	
	line	24
;SunPos.c: 24: double dLatitude=0;
	clrf	(main@dLatitude)^0180h
	clrf	(main@dLatitude+1)^0180h
	clrf	(main@dLatitude+2)^0180h
	
l30001727:	
	
l30001728:	
	
l30001729:	
	
l30001730:	
	
l30001731:	
	
l30001732:	
	
l30001733:	
	
l30001734:	
	
l30001735:	
	
l30001736:	
	
l30001737:	
	
l30001738:	
	
l30001739:	
	
l30001740:	
	
l30001741:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dSeconds)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSeconds+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSeconds+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+2)^080h
	movlw	0x0
	movwf	0+(?___ftdiv)^080h+03h
	movlw	0x70
	movwf	1+(?___ftdiv)^080h+03h
	movlw	0x42
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$981)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftdiv))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$981+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftdiv))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$981+2)^0180h
	
l30001742:	
	movf	(_main$981)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$981+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$981+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+2)^080h
	movlw	0x0
	movwf	0+(?___ftdiv)^080h+03h
	movlw	0x70
	movwf	1+(?___ftdiv)^080h+03h
	movlw	0x42
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMinutes)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMinutes+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMinutes+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+2)^0100h
	
l30001743:	
	file	"C:\SunCube\SunPos.c"
	line	53
;SunPos.c: 53: dDecimalHours = dHours + (dMinutes + (dSeconds / 60.0 ) / 60.0);
	movf	(_main$982)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHours)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHours+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHours+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dDecimalHours)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dDecimalHours+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dDecimalHours+2)^0180h
	
l30001744:	
	line	56
;SunPos.c: 56: liAux1 =(iMonth-14)/12;
	movlw	low(-14)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___awdiv)
	movlw	high(-14)
	movwf	((?___awdiv))+1
	movlw	0Ch
	movwf	0+(?___awdiv)+02h
	clrf	1+(?___awdiv)+02h
	fcall	___awdiv
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___awdiv)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@liAux1)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?___awdiv)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@liAux1+1)^0100h
	movlw	0
	btfsc	(main@liAux1+1)^0100h,7
	movlw	255
	movwf	(main@liAux1+2)^0100h
	movwf	(main@liAux1+3)^0100h
	
l30001745:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@liAux1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+0+0)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+0+0+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+0+0+2)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+3)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+0+0+3)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@iYear)^0180h,w
	addlw	low(01324h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+4+0)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@iYear+1)^0180h,w
	skipnc
	addlw	1
	addlw	high(01324h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	1+(??_main+4+0)
	movf	0+(??_main+4+0),w
	movwf	(??_main+6+0)
	movf	1+(??_main+4+0),w
	movwf	(??_main+6+0+1)
	movlw	0
	btfsc	(??_main+6+0+1),7
	movlw	255
	movwf	(??_main+6+0+2)
	movwf	(??_main+6+0+3)
	movf	0+(??_main+6+0),w
	addwf	(??_main+0+0),f
	movf	1+(??_main+6+0),w
	skipnc
	incfsz	1+(??_main+6+0),w
	goto	u1320
	goto	u1321
u1320:
	addwf	(??_main+0+1),f
u1321:
	movf	2+(??_main+6+0),w
	skipnc
	incfsz	2+(??_main+6+0),w
	goto	u1322
	goto	u1323
u1322:
	addwf	(??_main+0+2),f
u1323:
	movf	3+(??_main+6+0),w
	skipnc
	incf	3+(??_main+6+0),w
	addwf	(??_main+0+3),f
	movf	3+(??_main+0+0),w
	movwf	(?___aldiv+3)
	movf	2+(??_main+0+0),w
	movwf	(?___aldiv+2)
	movf	1+(??_main+0+0),w
	movwf	(?___aldiv+1)
	movf	0+(??_main+0+0),w
	movwf	(?___aldiv)

	movlw	064h
	movwf	0+(?___aldiv)+04h
	clrf	1+(?___aldiv)+04h
	clrf	2+(?___aldiv)+04h
	clrf	3+(?___aldiv)+04h

	fcall	___aldiv
	bcf	status, 7	;select IRP bank0
	movf	(3+(?___aldiv)),w
	movwf	(?___lmul+3)
	movf	(2+(?___aldiv)),w
	movwf	(?___lmul+2)
	movf	(1+(?___aldiv)),w
	movwf	(?___lmul+1)
	movf	(0+(?___aldiv)),w
	movwf	(?___lmul)

	movlw	03h
	movwf	0+(?___lmul)+04h
	clrf	1+(?___lmul)+04h
	clrf	2+(?___lmul)+04h
	clrf	3+(?___lmul)+04h

	fcall	___lmul
	movf	(3+(?___lmul)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$983+3)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?___lmul)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$983+2)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?___lmul)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$983+1)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(0+(?___lmul)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$983)^0180h

	
l30001746:	
	movlw	low(-2)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+0+0)
	movlw	high(-2)
	movwf	(??_main+0+0+1)
	movlw	low highword(-2)
	movwf	(??_main+0+0+2)
	movlw	high highword(-2)
	movwf	(??_main+0+0+3)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+3)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___lmul+3)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___lmul+2)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___lmul+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___lmul)

	movlw	0FFh
	movwf	3+(?___lmul)+04h
	movlw	0FFh
	movwf	2+(?___lmul)+04h
	movlw	0FFh
	movwf	1+(?___lmul)+04h
	movlw	0F4h
	movwf	0+(?___lmul)+04h

	fcall	___lmul
	movf	(0+(?___lmul)),w
	addwf	(??_main+0+0),f
	movf	(1+(?___lmul)),w
	skipnc
	incfsz	(1+(?___lmul)),w
	goto	u1330
	goto	u1331
u1330:
	addwf	(??_main+0+1),f
u1331:
	movf	(2+(?___lmul)),w
	skipnc
	incfsz	(2+(?___lmul)),w
	goto	u1332
	goto	u1333
u1332:
	addwf	(??_main+0+2),f
u1333:
	movf	(3+(?___lmul)),w
	skipnc
	incf	(3+(?___lmul)),w
	addwf	(??_main+0+3),f
	movf	3+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_main$984+3)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	2+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_main$984+2)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	1+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_main$984+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	0+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_main$984)^080h

	
l30001747:	
	file	"C:\SunCube\SunPos.c"
	line	59
;SunPos.c: 57: liAux2=(1461*(iYear + 4800 + liAux1))/4 + (367*(iMonth
;SunPos.c: 58: - 2-12*liAux1))/12- (3*((iYear + 4900
;SunPos.c: 59: + liAux1)/100))/4+iDay-32075;
	movlw	low(-32075)
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??_main+0+0)
	movlw	high(-32075)
	movwf	(??_main+0+0+1)
	movlw	low highword(-32075)
	movwf	(??_main+0+0+2)
	movlw	high highword(-32075)
	movwf	(??_main+0+0+3)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_main$984+3)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___lmul+3)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_main$984+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___lmul+2)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_main$984+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___lmul+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_main$984)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___lmul)

	movlw	0
	movwf	3+(?___lmul)+04h
	movlw	0
	movwf	2+(?___lmul)+04h
	movlw	01h
	movwf	1+(?___lmul)+04h
	movlw	06Fh
	movwf	0+(?___lmul)+04h

	fcall	___lmul
	movf	(3+(?___lmul)),w
	movwf	(?___aldiv+3)
	movf	(2+(?___lmul)),w
	movwf	(?___aldiv+2)
	movf	(1+(?___lmul)),w
	movwf	(?___aldiv+1)
	movf	(0+(?___lmul)),w
	movwf	(?___aldiv)

	movlw	0Ch
	movwf	0+(?___aldiv)+04h
	clrf	1+(?___aldiv)+04h
	clrf	2+(?___aldiv)+04h
	clrf	3+(?___aldiv)+04h

	fcall	___aldiv
	movf	(0+?___aldiv),w
	movwf	(??_main+4+0)
	movf	(1+?___aldiv),w
	movwf	(??_main+4+0+1)
	movf	(2+?___aldiv),w
	movwf	(??_main+4+0+2)
	movf	(3+?___aldiv),w
	movwf	(??_main+4+0+3)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+8+0)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+8+0+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+8+0+2)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@liAux1+3)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+8+0+3)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@iYear)^0180h,w
	addlw	low(012C0h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(??_main+12+0)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@iYear+1)^0180h,w
	skipnc
	addlw	1
	addlw	high(012C0h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	1+(??_main+12+0)
	movf	0+(??_main+12+0),w
	movwf	(??_main+14+0)
	movf	1+(??_main+12+0),w
	movwf	(??_main+14+0+1)
	movlw	0
	btfsc	(??_main+14+0+1),7
	movlw	255
	movwf	(??_main+14+0+2)
	movwf	(??_main+14+0+3)
	movf	0+(??_main+14+0),w
	addwf	(??_main+8+0),f
	movf	1+(??_main+14+0),w
	skipnc
	incfsz	1+(??_main+14+0),w
	goto	u1340
	goto	u1341
u1340:
	addwf	(??_main+8+1),f
u1341:
	movf	2+(??_main+14+0),w
	skipnc
	incfsz	2+(??_main+14+0),w
	goto	u1342
	goto	u1343
u1342:
	addwf	(??_main+8+2),f
u1343:
	movf	3+(??_main+14+0),w
	skipnc
	incf	3+(??_main+14+0),w
	addwf	(??_main+8+3),f
	movf	3+(??_main+8+0),w
	movwf	(?___lmul+3)
	movf	2+(??_main+8+0),w
	movwf	(?___lmul+2)
	movf	1+(??_main+8+0),w
	movwf	(?___lmul+1)
	movf	0+(??_main+8+0),w
	movwf	(?___lmul)

	movlw	0
	movwf	3+(?___lmul)+04h
	movlw	0
	movwf	2+(?___lmul)+04h
	movlw	05h
	movwf	1+(?___lmul)+04h
	movlw	0B5h
	movwf	0+(?___lmul)+04h

	fcall	___lmul
	bcf	status, 7	;select IRP bank0
	movf	(3+(?___lmul)),w
	movwf	(?___aldiv+3)
	movf	(2+(?___lmul)),w
	movwf	(?___aldiv+2)
	movf	(1+(?___lmul)),w
	movwf	(?___aldiv+1)
	movf	(0+(?___lmul)),w
	movwf	(?___aldiv)

	movlw	04h
	movwf	0+(?___aldiv)+04h
	clrf	1+(?___aldiv)+04h
	clrf	2+(?___aldiv)+04h
	clrf	3+(?___aldiv)+04h

	fcall	___aldiv
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___aldiv)),w
	addwf	(??_main+4+0),f
	movf	(1+(?___aldiv)),w
	skipnc
	incfsz	(1+(?___aldiv)),w
	goto	u1350
	goto	u1351
u1350:
	addwf	(??_main+4+1),f
u1351:
	movf	(2+(?___aldiv)),w
	skipnc
	incfsz	(2+(?___aldiv)),w
	goto	u1352
	goto	u1353
u1352:
	addwf	(??_main+4+2),f
u1353:
	movf	(3+(?___aldiv)),w
	skipnc
	incf	(3+(?___aldiv)),w
	addwf	(??_main+4+3),f
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$983+3)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___aldiv+3)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$983+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___aldiv+2)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$983+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___aldiv+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$983)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___aldiv)

	movlw	04h
	movwf	0+(?___aldiv)+04h
	clrf	1+(?___aldiv)+04h
	clrf	2+(?___aldiv)+04h
	clrf	3+(?___aldiv)+04h

	fcall	___aldiv
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___aldiv)),w
	subwf	(??_main+4+0),f
	movf	(1+(?___aldiv)),w
	skipc
	incfsz	(1+(?___aldiv)),w
	goto	u1361
	goto	u1362
u1361:
	subwf	(??_main+4+1),f
u1362:
	movf	(2+(?___aldiv)),w
	skipc
	incfsz	(2+(?___aldiv)),w
	goto	u1363
	goto	u1364
u1363:
	subwf	(??_main+4+2),f
u1364:
	movf	(3+(?___aldiv)),w
	skipc
	incfsz	(3+(?___aldiv)),w
	goto	u1365
	goto	u1366
u1365:
	subwf	(??_main+4+3),f
u1366:

	movf	0+(??_main+4+0),w
	addwf	(??_main+0+0),f
	movf	1+(??_main+4+0),w
	skipnc
	incfsz	1+(??_main+4+0),w
	goto	u1370
	goto	u1371
u1370:
	addwf	(??_main+0+1),f
u1371:
	movf	2+(??_main+4+0),w
	skipnc
	incfsz	2+(??_main+4+0),w
	goto	u1372
	goto	u1373
u1372:
	addwf	(??_main+0+2),f
u1373:
	movf	3+(??_main+4+0),w
	skipnc
	incf	3+(??_main+4+0),w
	addwf	(??_main+0+3),f
	movf	3+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@liAux2+3)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	2+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@liAux2+2)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	1+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@liAux2+1)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	0+(??_main+0+0),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@liAux2)^0180h

	
l30001748:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@liAux2+3)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___altoft+3)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@liAux2+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___altoft+2)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@liAux2+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___altoft+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@liAux2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?___altoft)

	fcall	___altoft
	movf	(0+(?___altoft)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?___altoft)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?___altoft)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+2)^080h
	movlw	0x0
	movwf	0+(?___ftdiv)^080h+03h
	movlw	0xc0
	movwf	1+(?___ftdiv)^080h+03h
	movlw	0x41
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	0+(?___ftadd)^080h+03h
	movf	(1+(?___ftdiv))^080h,w
	movwf	1+(?___ftadd)^080h+03h
	movf	(2+(?___ftdiv))^080h,w
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+2)^0100h
	
l30001749:	
	file	"C:\SunCube\SunPos.c"
	line	60
;SunPos.c: 60: dElapsedJulianDays=((double)(liAux2)-0.5+dDecimalHours/24.0)-2451545.0;
	movf	(_main$982)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0xa1
	movwf	0+(?___ftadd)^080h+03h
	movlw	0x15
	movwf	1+(?___ftadd)^080h+03h
	movlw	0xca
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dElapsedJulianDays)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dElapsedJulianDays+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dElapsedJulianDays+2)^0100h
	
l30001750:	
	line	66
;SunPos.c: 66: dOmega=2.1429-0.0010394594*dElapsedJulianDays;
	movlw	0x25
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub)^080h
	movlw	0x9
	movwf	(?___ftsub+1)^080h
	movlw	0x40
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x3e
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x88
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3a
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dOmega)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dOmega+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dOmega+2)^0100h
	
l30001751:	
	line	67
;SunPos.c: 67: dMeanLongitude = 4.8950630+ 0.017202791698*dElapsedJulianDays;
	movf	(main@dElapsedJulianDays)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xed
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x8c
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0xa4
	movwf	0+(?___ftadd)^080h+03h
	movlw	0x9c
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanLongitude)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanLongitude+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanLongitude+2)^0180h
	
l30001752:	
	line	68
;SunPos.c: 68: dMeanAnomaly = 6.2400600+ 0.0172019699*dElapsedJulianDays;
	bcf	status, 5	;RP0=0, select bank2
	movf	(main@dElapsedJulianDays)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xeb
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x8c
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0xaf
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xc7
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanAnomaly)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanAnomaly+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dMeanAnomaly+2)^0180h
	
l30001753:	
	line	71
	movf	(main@dMeanAnomaly)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanAnomaly+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanAnomaly+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	
l30001754:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanAnomaly)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanAnomaly+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanAnomaly+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x0
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x0
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x40
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$986)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$986+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$986+2)^0180h
	
l30001755:	
	file	"C:\SunCube\SunPos.c"
	line	71
	movf	(_main$986)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$986+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$986+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	
l30001756:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dOmega)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dOmega+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dOmega+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+1)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+2)^0100h
	
l30001757:	
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xdf
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x8
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3d
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xf2
	movwf	0+(?___ftmul)^080h+03h
	movlw	0xb6
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x39
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftadd)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftadd)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$987)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$987+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$987+2)^0180h
	
l30001758:	
	movf	(_main$987)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$987+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$987+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x4a
	movwf	0+(?___ftmul)^080h+03h
	movlw	0xaa
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x37
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988+2)^0180h
	
l30001759:	
	movf	(_main$988)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$988+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$988+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanLongitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanLongitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dMeanLongitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+2)^0100h
	
l30001760:	
	file	"C:\SunCube\SunPos.c"
	line	71
;SunPos.c: 69: dEclipticLongitude = dMeanLongitude + 0.03341607*sin( dMeanAnomaly )
;SunPos.c: 70: + 0.00034894*sin( 2*dMeanAnomaly )-0.0001134
;SunPos.c: 71: -0.0000203*sin(dOmega);
	movf	(_main$982)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0xd1
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xed
	movwf	1+(?___ftadd)^080h+03h
	movlw	0xb8
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticLongitude)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticLongitude+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticLongitude+2)^0180h
	
l30001761:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bcf	status, 5	;RP0=0, select bank2
	movf	(main@dOmega)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dOmega+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dOmega+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+2)^0100h
	
l30001762:	
	movlw	0x75
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub)^080h
	movlw	0xd1
	movwf	(?___ftsub+1)^080h
	movlw	0x3e
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x83
	movwf	0+(?___ftmul)^080h+03h
	movlw	0xd5
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x31
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$988+2)^0180h
	
l30001763:	
	file	"C:\SunCube\SunPos.c"
	line	73
;SunPos.c: 72: dEclipticObliquity = 0.4090928 - 6.2140e-9*dElapsedJulianDays
;SunPos.c: 73: +0.0000396*cos(dOmega);
	movf	(_main$988)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$988+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$988+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x18
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x26
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x38
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftadd)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftadd)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticObliquity)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticObliquity+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dEclipticObliquity+2)^0180h
	
l30001764:	
	line	79
;SunPos.c: 79: dSin_EclipticLongitude= sin( dEclipticLongitude );
	movf	(main@dEclipticLongitude)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticLongitude+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticLongitude+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_EclipticLongitude)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_EclipticLongitude+1)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_EclipticLongitude+2)^0180h
	
l30001765:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dEclipticObliquity)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticObliquity+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticObliquity+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+2)^0100h
	
l30001766:	
	file	"C:\SunCube\SunPos.c"
	line	80
;SunPos.c: 80: dY = cos( dEclipticObliquity ) * dSin_EclipticLongitude;
	movf	(_main$989)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY+2)^0100h
	
l30001767:	
	line	81
;SunPos.c: 81: dX = cos( dEclipticLongitude );
	bsf	status, 5	;RP0=1, select bank3
	movf	(main@dEclipticLongitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticLongitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticLongitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX+2)^0100h
	
l30001768:	
	line	82
;SunPos.c: 82: dRightAscension = atan2( dY,dX );
	movf	(main@dY)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dY+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dY+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?_atan2)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?_atan2)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?_atan2)^080h+03h
	fcall	_atan2
	movf	(0+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension+2)^0100h
	
l30001769:	
	line	83
;SunPos.c: 83: if( dRightAscension < 0.0 ) dRightAscension = dRightAscension + (2*3.14159265358979323846);
	movf	(main@dRightAscension)^0100h,w
	movwf	(?___ftge)
	movf	(main@dRightAscension+1)^0100h,w
	movwf	(?___ftge+1)
	movf	(main@dRightAscension+2)^0100h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1381
	goto	u1380
u1381:
	goto	l30001771
u1380:
	
l30001770:	
	movf	(main@dRightAscension)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dRightAscension+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dRightAscension+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0x10
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xc9
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dRightAscension+2)^0100h
	
l30001771:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bsf	status, 5	;RP0=1, select bank3
	movf	(main@dEclipticObliquity)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticObliquity+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dEclipticObliquity+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+1)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+2)^0100h
	
l30001772:	
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_EclipticLongitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$990)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$990+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$990+2)^0180h
	
l30001773:	
	file	"C:\SunCube\SunPos.c"
	line	84
;SunPos.c: 84: dDeclination = asin( sin( dEclipticObliquity )*dSin_EclipticLongitude );
	movf	(_main$990)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_asin)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$990+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_asin+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$990+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_asin+2)^080h
	fcall	_asin
	movf	(0+(?_asin))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dDeclination)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_asin))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dDeclination+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_asin))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dDeclination+2)^0100h
	
l30001774:	
	
l30001775:	
	
l30001776:	
	
l30001777:	
	
l30001778:	
	
l30001779:	
	
l30001780:	
	
l30001781:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dElapsedJulianDays)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dElapsedJulianDays+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x93
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x86
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3d
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dDecimalHours+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$982+2)^0100h
	
l30001782:	
	file	"C:\SunCube\SunPos.c"
	line	99
;SunPos.c: 97: dGreenwichMeanSiderealTime = 6.6974243242 +
;SunPos.c: 98: 0.0657098283*dElapsedJulianDays
;SunPos.c: 99: + dDecimalHours;
	movf	(_main$982)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$982+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0x51
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xd6
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dGreenwichMeanSiderealTime)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dGreenwichMeanSiderealTime+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dGreenwichMeanSiderealTime+2)^0180h
	
l30001783:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dGreenwichMeanSiderealTime)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dGreenwichMeanSiderealTime+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dGreenwichMeanSiderealTime+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x0
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x70
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x41
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLongitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLongitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLongitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991+2)^0180h
	
l30001784:	
	file	"C:\SunCube\SunPos.c"
	line	101
;SunPos.c: 100: dLocalMeanSiderealTime = (dGreenwichMeanSiderealTime*15
;SunPos.c: 101: + dLongitude)*(3.14159265358979323846/180);
	movf	(_main$991)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$991+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$991+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xfa
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x8e
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLocalMeanSiderealTime)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLocalMeanSiderealTime+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLocalMeanSiderealTime+2)^0180h
	
l30001785:	
	line	102
;SunPos.c: 102: dHourAngle = dLocalMeanSiderealTime - dRightAscension;
	movf	(main@dLocalMeanSiderealTime)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLocalMeanSiderealTime+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLocalMeanSiderealTime+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dRightAscension)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dRightAscension+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dRightAscension+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dHourAngle)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dHourAngle+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftsub))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dHourAngle+2)^0180h
	
l30001786:	
	line	103
;SunPos.c: 103: dLatitudeInRadians = dLatitude*(3.14159265358979323846/180);
	movf	(main@dLatitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xfa
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x8e
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLatitudeInRadians)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLatitudeInRadians+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dLatitudeInRadians+2)^0180h
	
l30001787:	
	line	104
;SunPos.c: 104: dCos_Latitude = cos( dLatitudeInRadians );
	movf	(main@dLatitudeInRadians)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitudeInRadians+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitudeInRadians+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_Latitude)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_Latitude+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_Latitude+2)^0180h
	
l30001788:	
	line	105
;SunPos.c: 105: dSin_Latitude = sin( dLatitudeInRadians );
	movf	(main@dLatitudeInRadians)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitudeInRadians+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dLatitudeInRadians+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_Latitude)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_Latitude+1)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dSin_Latitude+2)^0180h
	
l30001789:	
	line	106
;SunPos.c: 106: dCos_HourAngle = cos( dHourAngle );
	movf	(main@dHourAngle)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHourAngle+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHourAngle+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_HourAngle)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_HourAngle+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(main@dCos_HourAngle+2)^0180h
	
l30001790:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bcf	status, 5	;RP0=0, select bank2
	movf	(main@dDeclination)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_cos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$989+2)^0100h
	
l30001791:	
	movf	(_main$989)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$989+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftmul))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$991+2)^0180h
	
l30001792:	
	bcf	status, 5	;RP0=0, select bank2
	movf	(main@dDeclination)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+1)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+2)^0100h
	
l30001793:	
	bsf	status, 5	;RP0=1, select bank3
	movf	(_main$991)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$991+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$991+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftadd)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftadd)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$992)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$992+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$992+2)^0180h
	
l30001794:	
	file	"C:\SunCube\SunPos.c"
	line	108
;SunPos.c: 107: dZenithAngle = (acos( dCos_Latitude*dCos_HourAngle
;SunPos.c: 108: *cos(dDeclination) + sin( dDeclination )*dSin_Latitude));
	movf	(_main$992)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_acos)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$992+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_acos+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$992+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_acos+2)^080h
	fcall	_acos
	movf	(0+(?_acos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_acos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_acos))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle+2)^0100h
	
l30001795:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	bsf	status, 5	;RP0=1, select bank3
	movf	(main@dHourAngle)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHourAngle+1)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dHourAngle+2)^0180h,w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$993)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$993+1)^0180h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank3
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$993+2)^0180h
	
l30001796:	
	file	"C:\SunCube\SunPos.c"
	line	109
;SunPos.c: 109: dY = -sin( dHourAngle );
	movf	(_main$993)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftneg)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$993+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftneg+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$993+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dY+2)^0100h
	
l30001797:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dDeclination)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_tan)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_tan+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dDeclination+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_tan+2)^080h
	fcall	_tan
	movf	(0+(?_tan))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$994)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_tan))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$994+1)^0180h
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_tan))^080h,w
	bsf	status, 6	;RP1=1, select bank3
	movwf	(_main$994+2)^0180h
	
l30001798:	
	file	"C:\SunCube\SunPos.c"
	line	110
;SunPos.c: 110: dX = tan( dDeclination )*dCos_Latitude - dSin_Latitude*dCos_HourAngle;
	movf	(_main$994)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$994+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(_main$994+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_Latitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftsub)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftsub+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftsub+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dSin_Latitude+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle+1)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bsf	status, 6	;RP1=1, select bank3
	movf	(main@dCos_HourAngle+2)^0180h,w
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dX+2)^0100h
	
l30001799:	
	line	111
;SunPos.c: 111: dAzimuth = atan2( dY, dX );
	movf	(main@dY)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dY+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dY+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?_atan2+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?_atan2)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?_atan2)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dX+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?_atan2)^080h+03h
	fcall	_atan2
	movf	(0+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?_atan2))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+2)^0100h
	
l30001800:	
	line	112
;SunPos.c: 112: if (dAzimuth < 0.0 )
	movf	(main@dAzimuth)^0100h,w
	movwf	(?___ftge)
	movf	(main@dAzimuth+1)^0100h,w
	movwf	(?___ftge+1)
	movf	(main@dAzimuth+2)^0100h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1391
	goto	u1390
u1391:
	goto	l30001802
u1390:
	
l30001801:	
	line	113
;SunPos.c: 113: dAzimuth = dAzimuth + (2*3.14159265358979323846);
	movf	(main@dAzimuth)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dAzimuth+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dAzimuth+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0x10
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xc9
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+2)^0100h
	
l30001802:	
	line	114
;SunPos.c: 114: dAzimuth = dAzimuth/(3.14159265358979323846/180);
	movf	(main@dAzimuth)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dAzimuth+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dAzimuth+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftdiv+2)^080h
	movlw	0xfa
	movwf	0+(?___ftdiv)^080h+03h
	movlw	0x8e
	movwf	1+(?___ftdiv)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dAzimuth+2)^0100h
	
l30001803:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(main@dZenithAngle)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dZenithAngle+1)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dZenithAngle+2)^0100h,w
	bcf	status, 6	;RP1=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+1)^0100h
	bcf	status, 6	;RP1=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 6	;RP1=1, select bank2
	movwf	(_main$985+2)^0100h
	
l30001804:	
	file	"C:\SunCube\SunPos.c"
	line	118
;SunPos.c: 117: dZenithAngle = (dZenithAngle + (6371.01/149597890)
;SunPos.c: 118: *sin(dZenithAngle))/(3.14159265358979323846/180);
	movf	(_main$985)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(_main$985+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xa0
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x32
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x38
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dZenithAngle)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	0+(?___ftadd)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dZenithAngle+1)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	1+(?___ftadd)^080h+03h
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movf	(main@dZenithAngle+2)^0100h,w
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(?___ftdiv)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(?___ftdiv+2)^080h
	movlw	0xfa
	movwf	0+(?___ftdiv)^080h+03h
	movlw	0x8e
	movwf	1+(?___ftdiv)^080h+03h
	movlw	0x3c
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(1+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle+1)^0100h
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	movf	(2+(?___ftdiv))^080h,w
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(main@dZenithAngle+2)^0100h
	
l2:	
	global	start
	ljmp	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
; =============== function _main ends ============

psect	maintext
	line	119
	signat	_main,90
	global	___aldiv
psect	text348,local,class=CODE,delta=2
global __ptext348
__ptext348:

; *************** function ___aldiv *****************
; Defined at:
;		line 5 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
; Parameters:    Size  Location     Type
;  dividend        4   14[BANK0 ] long 
;  divisor         4   18[BANK0 ] long 
; Auto vars:     Size  Location     Type
;  quotient        4   10[BANK0 ] long 
;  sign            1    9[BANK0 ] unsigned char 
;  counter         1    8[BANK0 ] unsigned char 
; Return value:  Size  Location     Type
;                  4   14[BANK0 ] long 
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 160/0
;		On exit  : 60/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0      14       0       0       0
;      Temp:     0
;      Total:   14
; This function calls:
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text348
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	5
	global	__size_of___aldiv
	__size_of___aldiv	equ	__end_of___aldiv-___aldiv
	
___aldiv:	
	opt stack 6
; Regs used in ___aldiv: [wreg+status,2+status,0]
	line	9
	
l30002072:	
	clrf	(___aldiv@sign)
	
l30002073:	
	line	10
	btfss	(___aldiv@divisor+3),7
	goto	u2161
	goto	u2160
u2161:
	goto	l267
u2160:
	
l30002074:	
	line	11
	comf	(___aldiv@divisor),f
	comf	(___aldiv@divisor+1),f
	comf	(___aldiv@divisor+2),f
	comf	(___aldiv@divisor+3),f
	incf	(___aldiv@divisor),f
	skipnz
	incf	(___aldiv@divisor+1),f
	skipnz
	incf	(___aldiv@divisor+2),f
	skipnz
	incf	(___aldiv@divisor+3),f
	line	12
	clrf	(___aldiv@sign)
	incf	(___aldiv@sign),f
	
l267:	
	line	14
	btfss	(___aldiv@dividend+3),7
	goto	u2171
	goto	u2170
u2171:
	goto	l30002077
u2170:
	
l30002075:	
	line	15
	comf	(___aldiv@dividend),f
	comf	(___aldiv@dividend+1),f
	comf	(___aldiv@dividend+2),f
	comf	(___aldiv@dividend+3),f
	incf	(___aldiv@dividend),f
	skipnz
	incf	(___aldiv@dividend+1),f
	skipnz
	incf	(___aldiv@dividend+2),f
	skipnz
	incf	(___aldiv@dividend+3),f
	
l30002076:	
	line	16
	movlw	(01h)
	xorwf	(___aldiv@sign),f
	
l30002077:	
	line	18
	clrf	(___aldiv@quotient)
	clrf	(___aldiv@quotient+1)
	clrf	(___aldiv@quotient+2)
	clrf	(___aldiv@quotient+3)
	
l30002078:	
	line	19
	movf	(___aldiv@divisor+3),w
	iorwf	(___aldiv@divisor+2),w
	iorwf	(___aldiv@divisor+1),w
	iorwf	(___aldiv@divisor),w
	skipnz
	goto	u2181
	goto	u2180
u2181:
	goto	l30002088
u2180:
	
l30002079:	
	line	20
	clrf	(___aldiv@counter)
	incf	(___aldiv@counter),f
	goto	l30002081
	
l30002080:	
	line	22
	clrc
	rlf	(___aldiv@divisor),f
	rlf	(___aldiv@divisor+1),f
	rlf	(___aldiv@divisor+2),f
	rlf	(___aldiv@divisor+3),f
	line	23
	incf	(___aldiv@counter),f
	
l30002081:	
	line	21
	btfss	(___aldiv@divisor+3),(31)&7
	goto	u2191
	goto	u2190
u2191:
	goto	l30002080
u2190:
	
l30002082:	
	line	26
	clrc
	rlf	(___aldiv@quotient),f
	rlf	(___aldiv@quotient+1),f
	rlf	(___aldiv@quotient+2),f
	rlf	(___aldiv@quotient+3),f
	
l30002083:	
	line	27
	movf	(___aldiv@divisor+3),w
	subwf	(___aldiv@dividend+3),w
	skipz
	goto	u2205
	movf	(___aldiv@divisor+2),w
	subwf	(___aldiv@dividend+2),w
	skipz
	goto	u2205
	movf	(___aldiv@divisor+1),w
	subwf	(___aldiv@dividend+1),w
	skipz
	goto	u2205
	movf	(___aldiv@divisor),w
	subwf	(___aldiv@dividend),w
u2205:
	skipc
	goto	u2201
	goto	u2200
u2201:
	goto	l30002086
u2200:
	
l30002084:	
	line	28
	movf	(___aldiv@divisor),w
	subwf	(___aldiv@dividend),f
	movf	(___aldiv@divisor+1),w
	skipc
	incfsz	(___aldiv@divisor+1),w
	subwf	(___aldiv@dividend+1),f
	movf	(___aldiv@divisor+2),w
	skipc
	incfsz	(___aldiv@divisor+2),w
	subwf	(___aldiv@dividend+2),f
	movf	(___aldiv@divisor+3),w
	skipc
	incfsz	(___aldiv@divisor+3),w
	subwf	(___aldiv@dividend+3),f
	
l30002085:	
	line	29
	bsf	(___aldiv@quotient)+(0/8),(0)&7
	
l30002086:	
	line	31
	clrc
	rrf	(___aldiv@divisor+3),f
	rrf	(___aldiv@divisor+2),f
	rrf	(___aldiv@divisor+1),f
	rrf	(___aldiv@divisor),f
	
l30002087:	
	line	32
	decfsz	(___aldiv@counter),f
	goto	u2211
	goto	u2210
u2211:
	goto	l30002082
u2210:
	
l30002088:	
	line	34
	movf	(___aldiv@sign),w
	skipz
	goto	u2220
	goto	l30002090
u2220:
	
l30002089:	
	line	35
	comf	(___aldiv@quotient),f
	comf	(___aldiv@quotient+1),f
	comf	(___aldiv@quotient+2),f
	comf	(___aldiv@quotient+3),f
	incf	(___aldiv@quotient),f
	skipnz
	incf	(___aldiv@quotient+1),f
	skipnz
	incf	(___aldiv@quotient+2),f
	skipnz
	incf	(___aldiv@quotient+3),f
	
l30002090:	
	line	36
	movf	(___aldiv@quotient+3),w
	movwf	(?___aldiv+3)
	movf	(___aldiv@quotient+2),w
	movwf	(?___aldiv+2)
	movf	(___aldiv@quotient+1),w
	movwf	(?___aldiv+1)
	movf	(___aldiv@quotient),w
	movwf	(?___aldiv)

	
l266:	
	return
	opt stack 0
GLOBAL	__end_of___aldiv
	__end_of___aldiv:
; =============== function ___aldiv ends ============

psect	text349,local,class=CODE,delta=2
global __ptext349
__ptext349:
	line	37
	signat	___aldiv,8316
	global	___lmul

; *************** function ___lmul *****************
; Defined at:
;		line 3 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\lmul.c"
; Parameters:    Size  Location     Type
;  multiplier      4    0[BANK0 ] unsigned long 
;  multiplicand    4    4[BANK0 ] unsigned long 
; Auto vars:     Size  Location     Type
;  product         4    0[COMMON] unsigned long 
; Return value:  Size  Location     Type
;                  4    0[BANK0 ] unsigned long 
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 60/0
;		On exit  : 60/0
;		Unchanged: FFF9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         4       8       0       0       0
;      Temp:     0
;      Total:   12
; This function calls:
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text349
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\lmul.c"
	line	3
	global	__size_of___lmul
	__size_of___lmul	equ	__end_of___lmul-___lmul
	
___lmul:	
	opt stack 6
; Regs used in ___lmul: [wreg+status,2+status,0]
	line	4
	
l30002044:	
	clrf	(___lmul@product)
	clrf	(___lmul@product+1)
	clrf	(___lmul@product+2)
	clrf	(___lmul@product+3)
	
l117:	
	line	7
	btfss	(___lmul@multiplier),(0)&7
	goto	u2061
	goto	u2060
u2061:
	goto	l30002046
u2060:
	
l30002045:	
	line	8
	movf	(___lmul@multiplicand),w
	addwf	(___lmul@product),f
	movf	(___lmul@multiplicand+1),w
	clrz
	skipnc
	addlw	1
	skipnz
	goto	u2071
	addwf	(___lmul@product+1),f
u2071:
	movf	(___lmul@multiplicand+2),w
	clrz
	skipnc
	addlw	1
	skipnz
	goto	u2072
	addwf	(___lmul@product+2),f
u2072:
	movf	(___lmul@multiplicand+3),w
	clrz
	skipnc
	addlw	1
	skipnz
	goto	u2073
	addwf	(___lmul@product+3),f
u2073:

	
l30002046:	
	line	9
	clrc
	rlf	(___lmul@multiplicand),f
	rlf	(___lmul@multiplicand+1),f
	rlf	(___lmul@multiplicand+2),f
	rlf	(___lmul@multiplicand+3),f
	
l30002047:	
	line	10
	clrc
	rrf	(___lmul@multiplier+3),f
	rrf	(___lmul@multiplier+2),f
	rrf	(___lmul@multiplier+1),f
	rrf	(___lmul@multiplier),f
	line	11
	movf	(___lmul@multiplier+3),w
	iorwf	(___lmul@multiplier+2),w
	iorwf	(___lmul@multiplier+1),w
	iorwf	(___lmul@multiplier),w
	skipz
	goto	u2081
	goto	u2080
u2081:
	goto	l117
u2080:
	
l30002048:	
	line	12
	movf	(___lmul@product+3),w
	movwf	(?___lmul+3)
	movf	(___lmul@product+2),w
	movwf	(?___lmul+2)
	movf	(___lmul@product+1),w
	movwf	(?___lmul+1)
	movf	(___lmul@product),w
	movwf	(?___lmul)

	
l114:	
	return
	opt stack 0
GLOBAL	__end_of___lmul
	__end_of___lmul:
; =============== function ___lmul ends ============

psect	text350,local,class=CODE,delta=2
global __ptext350
__ptext350:
	line	13
	signat	___lmul,8316
	global	_atan2

; *************** function _atan2 *****************
; Defined at:
;		line 9 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan2.c"
; Parameters:    Size  Location     Type
;  y               3   64[BANK1 ] unsigned long 
;  x               3   67[BANK1 ] unsigned long 
; Auto vars:     Size  Location     Type
;  v               3   61[BANK1 ] unsigned long 
; Return value:  Size  Location     Type
;                  3   64[BANK1 ] unsigned long 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0      21       0       0
;      Temp:     0
;      Total:   21
; This function calls:
;		___ftge
;		_fabs
;		___ftdiv
;		_atan
;		___ftadd
;		___ftsub
;		___ftneg
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text350
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan2.c"
	line	9
	global	__size_of_atan2
	__size_of_atan2	equ	__end_of_atan2-_atan2
	
_atan2:	
	opt stack 6
; Regs used in _atan2: [allreg]
	line	12
	
l30001805:	
	movf	(atan2@x+2)^080h,w
	iorwf	(atan2@x+1)^080h,w
	iorwf	(atan2@x)^080h,w
	skipz
	goto	u1401
	goto	u1400
u1401:
	goto	l30001815
u1400:
	
l30001806:	
	line	13
	movf	(atan2@y+2)^080h,w
	iorwf	(atan2@y+1)^080h,w
	iorwf	(atan2@y)^080h,w
	skipz
	goto	u1411
	goto	u1410
u1411:
	goto	l30001809
u1410:
	
l30001807:	
	line	15
	clrf	(?_atan2)^080h
	clrf	(?_atan2+1)^080h
	clrf	(?_atan2+2)^080h
	goto	l10
	
l30001809:	
	line	17
	clrf	(?___ftge)
	clrf	(?___ftge+1)
	clrf	(?___ftge+2)
	movf	(atan2@y)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(atan2@y+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(atan2@y+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1421
	goto	u1420
u1421:
	goto	l30001813
u1420:
	
l30001810:	
	line	18
	movlw	0x10
	movwf	(?_atan2)^080h
	movlw	0xc9
	movwf	(?_atan2+1)^080h
	movlw	0x3f
	movwf	(?_atan2+2)^080h
	goto	l10
	
l30001813:	
	line	21
	movlw	0x10
	movwf	(?_atan2)^080h
	movlw	0xc9
	movwf	(?_atan2+1)^080h
	movlw	0xbf
	movwf	(?_atan2+2)^080h
	goto	l10
	
l30001815:	
	line	24
	movf	(atan2@y+2)^080h,w
	iorwf	(atan2@y+1)^080h,w
	iorwf	(atan2@y)^080h,w
	skipz
	goto	u1431
	goto	u1430
u1431:
	goto	l30001822
u1430:
	
l30001816:	
	line	25
	clrf	(?___ftge)
	clrf	(?___ftge+1)
	clrf	(?___ftge+2)
	movf	(atan2@x)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(atan2@x+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(atan2@x+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1441
	goto	u1440
u1441:
	goto	l30001820
u1440:
	
l30001817:	
	line	26
	clrf	(?_atan2)^080h
	clrf	(?_atan2+1)^080h
	clrf	(?_atan2+2)^080h
	goto	l10
	
l30001820:	
	line	29
	movlw	0x10
	movwf	(?_atan2)^080h
	movlw	0x49
	movwf	(?_atan2+1)^080h
	movlw	0x40
	movwf	(?_atan2+2)^080h
	goto	l10
	
l30001822:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(atan2@x)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan2@x+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan2@x+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	fcall	_fabs
	movf	(0+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1001)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1001+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1001+2)^080h
	movf	(atan2@y)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan2@y+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan2@y+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	fcall	_fabs
	movf	(0+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1002)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1002+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_atan2$1002+2)^080h
	
l30001823:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan2.c"
	line	32
	movf	(_atan2$1001)^080h,w
	movwf	(?___ftge)
	movf	(_atan2$1001+1)^080h,w
	movwf	(?___ftge+1)
	movf	(_atan2$1001+2)^080h,w
	movwf	(?___ftge+2)
	movf	(_atan2$1002)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(_atan2$1002+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(_atan2$1002+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfss	status,0
	goto	u1451
	goto	u1450
u1451:
	goto	l30001831
u1450:
	
l30001824:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(atan2@y)^080h,w
	movwf	(?___ftdiv)^080h
	movf	(atan2@y+1)^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(atan2@y+2)^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(atan2@x)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(atan2@x+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(atan2@x+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_atan2$1003)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_atan2$1003+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_atan2$1003+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan2.c"
	line	33
	movf	(_atan2$1003)^080h,w
	movwf	(?_atan)^080h
	movf	(_atan2$1003+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(_atan2$1003+2)^080h,w
	movwf	(?_atan+2)^080h
	fcall	_atan
	movf	(0+(?_atan))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?_atan))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?_atan))^080h,w
	movwf	(atan2@v+2)^080h
	
l30001825:	
	line	34
	movf	(atan2@x)^080h,w
	movwf	(?___ftge)
	movf	(atan2@x+1)^080h,w
	movwf	(?___ftge+1)
	movf	(atan2@x+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1461
	goto	u1460
u1461:
	goto	l30001829
u1460:
	
l30001826:	
	line	35
	movf	(atan2@y)^080h,w
	movwf	(?___ftge)
	movf	(atan2@y+1)^080h,w
	movwf	(?___ftge+1)
	movf	(atan2@y+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfss	status,0
	goto	u1471
	goto	u1470
u1471:
	goto	l30001828
u1470:
	
l30001827:	
	line	36
	movf	(atan2@v)^080h,w
	movwf	(?___ftadd)^080h
	movf	(atan2@v+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(atan2@v+2)^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0x10
	movwf	0+(?___ftadd)^080h+03h
	movlw	0x49
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x40
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(atan2@v+2)^080h
	goto	l30001829
	
l30001828:	
	line	38
	movf	(atan2@v)^080h,w
	movwf	(?___ftsub)^080h
	movf	(atan2@v+1)^080h,w
	movwf	(?___ftsub+1)^080h
	movf	(atan2@v+2)^080h,w
	movwf	(?___ftsub+2)^080h
	movlw	0x10
	movwf	0+(?___ftsub)^080h+03h
	movlw	0x49
	movwf	1+(?___ftsub)^080h+03h
	movlw	0x40
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(atan2@v+2)^080h
	
l30001829:	
	line	39
	movf	(atan2@v)^080h,w
	movwf	(?_atan2)^080h
	movf	(atan2@v+1)^080h,w
	movwf	(?_atan2+1)^080h
	movf	(atan2@v+2)^080h,w
	movwf	(?_atan2+2)^080h
	goto	l10
	
l30001831:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(atan2@x)^080h,w
	movwf	(?___ftdiv)^080h
	movf	(atan2@x+1)^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(atan2@x+2)^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(atan2@y)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(atan2@y+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(atan2@y+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_atan2$1003)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_atan2$1003+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_atan2$1003+2)^080h
	movf	(_atan2$1003)^080h,w
	movwf	(?_atan)^080h
	movf	(_atan2$1003+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(_atan2$1003+2)^080h,w
	movwf	(?_atan+2)^080h
	fcall	_atan
	movf	(0+(?_atan))^080h,w
	movwf	(_atan2$1004)^080h
	movf	(1+(?_atan))^080h,w
	movwf	(_atan2$1004+1)^080h
	movf	(2+(?_atan))^080h,w
	movwf	(_atan2$1004+2)^080h
	
l30001832:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan2.c"
	line	41
	movf	(_atan2$1004)^080h,w
	movwf	(?___ftneg)^080h
	movf	(_atan2$1004+1)^080h,w
	movwf	(?___ftneg+1)^080h
	movf	(_atan2$1004+2)^080h,w
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?___ftneg))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?___ftneg))^080h,w
	movwf	(atan2@v+2)^080h
	
l30001833:	
	line	42
	movf	(atan2@y)^080h,w
	movwf	(?___ftge)
	movf	(atan2@y+1)^080h,w
	movwf	(?___ftge+1)
	movf	(atan2@y+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1481
	goto	u1480
u1481:
	goto	l30001835
u1480:
	
l30001834:	
	line	43
	movf	(atan2@v)^080h,w
	movwf	(?___ftsub)^080h
	movf	(atan2@v+1)^080h,w
	movwf	(?___ftsub+1)^080h
	movf	(atan2@v+2)^080h,w
	movwf	(?___ftsub+2)^080h
	movlw	0x10
	movwf	0+(?___ftsub)^080h+03h
	movlw	0xc9
	movwf	1+(?___ftsub)^080h+03h
	movlw	0x3f
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(atan2@v+2)^080h
	goto	l30001829
	
l30001835:	
	line	45
	movf	(atan2@v)^080h,w
	movwf	(?___ftadd)^080h
	movf	(atan2@v+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(atan2@v+2)^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0x10
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xc9
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x3f
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(atan2@v)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(atan2@v+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(atan2@v+2)^080h
	goto	l30001829
	
l10:	
	return
	opt stack 0
GLOBAL	__end_of_atan2
	__end_of_atan2:
; =============== function _atan2 ends ============

psect	text351,local,class=CODE,delta=2
global __ptext351
__ptext351:
	line	47
	signat	_atan2,8315
	global	___awdiv

; *************** function ___awdiv *****************
; Defined at:
;		line 5 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\awdiv.c"
; Parameters:    Size  Location     Type
;  dividend        2    0[BANK0 ] int 
;  divisor         2    2[BANK0 ] int 
; Auto vars:     Size  Location     Type
;  quotient        2    2[COMMON] int 
;  sign            1    1[COMMON] unsigned char 
;  counter         1    0[COMMON] unsigned char 
; Return value:  Size  Location     Type
;                  2    0[BANK0 ] int 
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 17F/0
;		On exit  : 60/0
;		Unchanged: FFE80/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         4       4       0       0       0
;      Temp:     0
;      Total:    8
; This function calls:
;		Nothing
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text351
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\awdiv.c"
	line	5
	global	__size_of___awdiv
	__size_of___awdiv	equ	__end_of___awdiv-___awdiv
	
___awdiv:	
	opt stack 6
; Regs used in ___awdiv: [wreg+status,2+status,0]
	line	9
	
l30002050:	
	clrf	(___awdiv@sign)
	
l30002051:	
	line	10
	btfss	(___awdiv@divisor+1),7
	goto	u2091
	goto	u2090
u2091:
	goto	l30002054
u2090:
	
l30002052:	
	line	11
	comf	(___awdiv@divisor),f
	comf	(___awdiv@divisor+1),f
	incf	(___awdiv@divisor),f
	skipnz
	incf	(___awdiv@divisor+1),f
	
l30002053:	
	line	12
	clrf	(___awdiv@sign)
	incf	(___awdiv@sign),f
	
l30002054:	
	line	14
	btfss	(___awdiv@dividend+1),7
	goto	u2101
	goto	u2100
u2101:
	goto	l30002057
u2100:
	
l30002055:	
	line	15
	comf	(___awdiv@dividend),f
	comf	(___awdiv@dividend+1),f
	incf	(___awdiv@dividend),f
	skipnz
	incf	(___awdiv@dividend+1),f
	
l30002056:	
	line	16
	movlw	(01h)
	xorwf	(___awdiv@sign),f
	
l30002057:	
	line	18
	clrf	(___awdiv@quotient)
	clrf	(___awdiv@quotient+1)
	
l30002058:	
	line	19
	movf	(___awdiv@divisor+1),w
	iorwf	(___awdiv@divisor),w
	skipnz
	goto	u2111
	goto	u2110
u2111:
	goto	l30002068
u2110:
	
l30002059:	
	line	20
	clrf	(___awdiv@counter)
	incf	(___awdiv@counter),f
	goto	l30002061
	
l30002060:	
	line	22
	clrc
	rlf	(___awdiv@divisor),f
	rlf	(___awdiv@divisor+1),f
	line	23
	incf	(___awdiv@counter),f
	
l30002061:	
	line	21
	btfss	(___awdiv@divisor+1),(15)&7
	goto	u2121
	goto	u2120
u2121:
	goto	l30002060
u2120:
	
l30002062:	
	line	26
	clrc
	rlf	(___awdiv@quotient),f
	rlf	(___awdiv@quotient+1),f
	
l30002063:	
	line	27
	movf	(___awdiv@divisor+1),w
	subwf	(___awdiv@dividend+1),w
	skipz
	goto	u2135
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),w
u2135:
	skipc
	goto	u2131
	goto	u2130
u2131:
	goto	l30002066
u2130:
	
l30002064:	
	line	28
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),f
	movf	(___awdiv@divisor+1),w
	skipc
	decf	(___awdiv@dividend+1),f
	subwf	(___awdiv@dividend+1),f
	
l30002065:	
	line	29
	bsf	(___awdiv@quotient)+(0/8),(0)&7
	
l30002066:	
	line	31
	clrc
	rrf	(___awdiv@divisor+1),f
	rrf	(___awdiv@divisor),f
	
l30002067:	
	line	32
	decfsz	(___awdiv@counter),f
	goto	u2141
	goto	u2140
u2141:
	goto	l30002062
u2140:
	
l30002068:	
	line	34
	movf	(___awdiv@sign),w
	skipz
	goto	u2150
	goto	l30002070
u2150:
	
l30002069:	
	line	35
	comf	(___awdiv@quotient),f
	comf	(___awdiv@quotient+1),f
	incf	(___awdiv@quotient),f
	skipnz
	incf	(___awdiv@quotient+1),f
	
l30002070:	
	line	36
	movf	(___awdiv@quotient+1),w
	movwf	(?___awdiv+1)
	movf	(___awdiv@quotient),w
	movwf	(?___awdiv)
	
l198:	
	return
	opt stack 0
GLOBAL	__end_of___awdiv
	__end_of___awdiv:
; =============== function ___awdiv ends ============

psect	text352,local,class=CODE,delta=2
global __ptext352
__ptext352:
	line	37
	signat	___awdiv,8314
	global	_tan

; *************** function _tan *****************
; Defined at:
;		line 10 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\tan.c"
; Parameters:    Size  Location     Type
;  x               3   58[BANK1 ] int 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   58[BANK1 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0       9       0       0
;      Temp:     0
;      Total:    9
; This function calls:
;		_sin
;		_cos
;		___ftdiv
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text352
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\tan.c"
	line	10
	global	__size_of_tan
	__size_of_tan	equ	__end_of_tan-_tan
	
_tan:	
	opt stack 6
; Regs used in _tan: [allreg]
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	
l30001845:	
	movf	(tan@x)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank1
	movf	(tan@x+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(tan@x+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_tan$1008)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_tan$1008+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_tan$1008+2)^080h
	movf	(tan@x)^080h,w
	movwf	(?_cos)^080h
	movf	(tan@x+1)^080h,w
	movwf	(?_cos+1)^080h
	movf	(tan@x+2)^080h,w
	movwf	(?_cos+2)^080h
	fcall	_cos
	movf	(0+(?_cos))^080h,w
	movwf	(_tan$1009)^080h
	movf	(1+(?_cos))^080h,w
	movwf	(_tan$1009+1)^080h
	movf	(2+(?_cos))^080h,w
	movwf	(_tan$1009+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\tan.c"
	line	15
	movf	(_tan$1008)^080h,w
	movwf	(?___ftdiv)^080h
	movf	(_tan$1008+1)^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(_tan$1008+2)^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(_tan$1009)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(_tan$1009+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(_tan$1009+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(?_tan)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(?_tan+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(?_tan+2)^080h
	
l48:	
	return
	opt stack 0
GLOBAL	__end_of_tan
	__end_of_tan:
; =============== function _tan ends ============

psect	text353,local,class=CODE,delta=2
global __ptext353
__ptext353:
	line	16
	signat	_tan,4219
	global	_acos

; *************** function _acos *****************
; Defined at:
;		line 9 in file "../../common/acos.c"
; Parameters:    Size  Location     Type
;  x               3   73[BANK1 ] int 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   73[BANK1 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0       6       0       0
;      Temp:     0
;      Total:    6
; This function calls:
;		_asin
;		___ftsub
; This function is called by:
;		_main
; This function uses a non-reentrant model
; 
psect	text353
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\acos.c"
	line	9
	global	__size_of_acos
	__size_of_acos	equ	__end_of_acos-_acos
	
_acos:	
	opt stack 6
; Regs used in _acos: [allreg]
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	
l30001876:	
	movf	(acos@x)^080h,w
	movwf	(?_asin)^080h
	movf	(acos@x+1)^080h,w
	movwf	(?_asin+1)^080h
	movf	(acos@x+2)^080h,w
	movwf	(?_asin+2)^080h
	fcall	_asin
	movf	(0+(?_asin))^080h,w
	movwf	(_acos$995)^080h
	movf	(1+(?_asin))^080h,w
	movwf	(_acos$995+1)^080h
	movf	(2+(?_asin))^080h,w
	movwf	(_acos$995+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\acos.c"
	line	10
	movlw	0x10
	movwf	(?___ftsub)^080h
	movlw	0xc9
	movwf	(?___ftsub+1)^080h
	movlw	0x3f
	movwf	(?___ftsub+2)^080h
	movf	(_acos$995)^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(_acos$995+1)^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(_acos$995+2)^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(?_acos)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(?_acos+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(?_acos+2)^080h
	
l5:	
	return
	opt stack 0
GLOBAL	__end_of_acos
	__end_of_acos:
; =============== function _acos ends ============

psect	text354,local,class=CODE,delta=2
global __ptext354
__ptext354:
	line	11
	signat	_acos,4219
	global	_cos

; *************** function _cos *****************
; Defined at:
;		line 14 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\cos.c"
; Parameters:    Size  Location     Type
;  f               3   49[BANK1 ] int 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   49[BANK1 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0       6       0       0
;      Temp:     0
;      Total:    6
; This function calls:
;		___ftge
;		___ftadd
;		_sin
; This function is called by:
;		_main
;		_tan
; This function uses a non-reentrant model
; 
psect	text354
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\cos.c"
	line	14
	global	__size_of_cos
	__size_of_cos	equ	__end_of_cos-_cos
	
_cos:	
	opt stack 5
; Regs used in _cos: [allreg]
	line	21
	
l30001838:	
	movlw	0x10
	movwf	(?___ftge)
	movlw	0x49
	movwf	(?___ftge+1)
	movlw	0x40
	movwf	(?___ftge+2)
	movf	(cos@f)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(cos@f+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(cos@f+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1491
	goto	u1490
u1491:
	goto	l30001842
u1490:
	
l30001839:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(cos@f)^080h,w
	movwf	(?___ftadd)^080h
	movf	(cos@f+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(cos@f+2)^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0xcc
	movwf	0+(?___ftadd)^080h+03h
	movlw	0x96
	movwf	1+(?___ftadd)^080h+03h
	movlw	0xc0
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(_cos$1006)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(_cos$1006+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(_cos$1006+2)^080h
	
l30001840:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\cos.c"
	line	22
	movf	(_cos$1006)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_cos$1006+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(_cos$1006+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+2)
	fcall	_sin
	movf	(0+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?_cos)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?_cos+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_sin)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?_cos+2)^080h
	goto	l28
	
l30001842:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(cos@f)^080h,w
	movwf	(?___ftadd)^080h
	movf	(cos@f+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(cos@f+2)^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	0x10
	movwf	0+(?___ftadd)^080h+03h
	movlw	0xc9
	movwf	1+(?___ftadd)^080h+03h
	movlw	0x3f
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(_cos$1006)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(_cos$1006+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(_cos$1006+2)^080h
	goto	l30001840
	
l28:	
	return
	opt stack 0
GLOBAL	__end_of_cos
	__end_of_cos:
; =============== function _cos ends ============

psect	text355,local,class=CODE,delta=2
global __ptext355
__ptext355:
	line	24
	signat	_cos,4219
	global	_asin

; *************** function _asin *****************
; Defined at:
;		line 10 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
; Parameters:    Size  Location     Type
;  x               3   67[BANK1 ] int 
; Auto vars:     Size  Location     Type
;  y               3   61[BANK1 ] int 
; Return value:  Size  Location     Type
;                  3   67[BANK1 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0      21       0       0
;      Temp:     0
;      Total:   21
; This function calls:
;		_fabs
;		___ftge
;		___ftmul
;		___ftsub
;		_sqrt
;		___ftdiv
;		_atan
;		___ftneg
; This function is called by:
;		_main
;		_acos
; This function uses a non-reentrant model
; 
psect	text355
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	10
	global	__size_of_asin
	__size_of_asin	equ	__end_of_asin-_asin
	
_asin:	
	opt stack 5
; Regs used in _asin: [allreg]
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	
l30001863:	
	movf	(asin@x)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(asin@x+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(asin@x+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	fcall	_fabs
	movf	(0+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$996)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$996+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$996+2)^080h
	
l30001864:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	14
	movlw	0x0
	movwf	(?___ftge)
	movlw	0x80
	movwf	(?___ftge+1)
	movlw	0x3f
	movwf	(?___ftge+2)
	movf	(_asin$996)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(_asin$996+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(_asin$996+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1551
	goto	u1550
u1551:
	goto	l30001867
u1550:
	
l30001865:	
	line	16
	clrf	(?_asin)^080h
	clrf	(?_asin+1)^080h
	clrf	(?_asin+2)^080h
	goto	l6
	
l30001867:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movlw	0x0
	movwf	(?___ftsub)^080h
	movlw	0x80
	movwf	(?___ftsub+1)^080h
	movlw	0x3f
	movwf	(?___ftsub+2)^080h
	movf	(asin@x)^080h,w
	movwf	(?___ftmul)^080h
	movf	(asin@x+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(asin@x+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(asin@x)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(asin@x+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(asin@x+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(1+(?___ftmul))^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(2+(?___ftmul))^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(_asin$997)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(_asin$997+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(_asin$997+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	19
	movf	(_asin$997)^080h,w
	movwf	(?_sqrt)^080h
	movf	(_asin$997+1)^080h,w
	movwf	(?_sqrt+1)^080h
	movf	(_asin$997+2)^080h,w
	movwf	(?_sqrt+2)^080h
	fcall	_sqrt
	movf	(0+(?_sqrt))^080h,w
	movwf	(asin@y)^080h
	movf	(1+(?_sqrt))^080h,w
	movwf	(asin@y+1)^080h
	movf	(2+(?_sqrt))^080h,w
	movwf	(asin@y+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(asin@x)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(asin@x+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(asin@x+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	fcall	_fabs
	movf	(0+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$998)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$998+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(_asin$998+2)^080h
	
l30001868:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	20
	movf	(_asin$998)^080h,w
	movwf	(?___ftge)
	movf	(_asin$998+1)^080h,w
	movwf	(?___ftge+1)
	movf	(_asin$998+2)^080h,w
	movwf	(?___ftge+2)
	movlw	0xc3
	movwf	0+(?___ftge)+03h
	movlw	0x35
	movwf	1+(?___ftge)+03h
	movlw	0x3f
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1561
	goto	u1560
u1561:
	goto	l30001871
u1560:
	
l30001869:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(asin@x)^080h,w
	movwf	(?___ftdiv)^080h
	movf	(asin@x+1)^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(asin@x+2)^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(asin@y)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(asin@y+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(asin@y+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_asin$999)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_asin$999+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_asin$999+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	21
	movf	(_asin$999)^080h,w
	movwf	(?_atan)^080h
	movf	(_asin$999+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(_asin$999+2)^080h,w
	movwf	(?_atan+2)^080h
	fcall	_atan
	movf	(0+(?_atan))^080h,w
	movwf	(?_asin)^080h
	movf	(1+(?_atan))^080h,w
	movwf	(?_asin+1)^080h
	movf	(2+(?_atan))^080h,w
	movwf	(?_asin+2)^080h
	goto	l6
	
l30001871:	
	line	22
	movf	(asin@x)^080h,w
	movwf	(?___ftge)
	movf	(asin@x+1)^080h,w
	movwf	(?___ftge+1)
	movf	(asin@x+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1571
	goto	u1570
u1571:
	goto	l30001874
u1570:
	
l30001872:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(asin@y)^080h,w
	movwf	(?___ftneg)^080h
	movf	(asin@y+1)^080h,w
	movwf	(?___ftneg+1)^080h
	movf	(asin@y+2)^080h,w
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	movwf	(?___ftdiv)^080h
	movf	(1+(?___ftneg))^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(2+(?___ftneg))^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(asin@x)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(asin@x+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(asin@x+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_asin$999)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_asin$999+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_asin$999+2)^080h
	movf	(_asin$999)^080h,w
	movwf	(?_atan)^080h
	movf	(_asin$999+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(_asin$999+2)^080h,w
	movwf	(?_atan+2)^080h
	fcall	_atan
	movf	(0+(?_atan))^080h,w
	movwf	(_asin$1000)^080h
	movf	(1+(?_atan))^080h,w
	movwf	(_asin$1000+1)^080h
	movf	(2+(?_atan))^080h,w
	movwf	(_asin$1000+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	23
	movlw	0x10
	movwf	(?___ftsub)^080h
	movlw	0xc9
	movwf	(?___ftsub+1)^080h
	movlw	0x3f
	movwf	(?___ftsub+2)^080h
	movf	(_asin$1000)^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(_asin$1000+1)^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(_asin$1000+2)^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(?___ftneg)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(?___ftneg+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	movwf	(?_asin)^080h
	movf	(1+(?___ftneg))^080h,w
	movwf	(?_asin+1)^080h
	movf	(2+(?___ftneg))^080h,w
	movwf	(?_asin+2)^080h
	goto	l6
	
l30001874:	
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(asin@y)^080h,w
	movwf	(?___ftdiv)^080h
	movf	(asin@y+1)^080h,w
	movwf	(?___ftdiv+1)^080h
	movf	(asin@y+2)^080h,w
	movwf	(?___ftdiv+2)^080h
	movf	(asin@x)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(asin@x+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(asin@x+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_asin$999)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_asin$999+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_asin$999+2)^080h
	movf	(_asin$999)^080h,w
	movwf	(?_atan)^080h
	movf	(_asin$999+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(_asin$999+2)^080h,w
	movwf	(?_atan+2)^080h
	fcall	_atan
	movf	(0+(?_atan))^080h,w
	movwf	(_asin$1000)^080h
	movf	(1+(?_atan))^080h,w
	movwf	(_asin$1000+1)^080h
	movf	(2+(?_atan))^080h,w
	movwf	(_asin$1000+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\asin.c"
	line	24
	movlw	0x10
	movwf	(?___ftsub)^080h
	movlw	0xc9
	movwf	(?___ftsub+1)^080h
	movlw	0x3f
	movwf	(?___ftsub+2)^080h
	movf	(_asin$1000)^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(_asin$1000+1)^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(_asin$1000+2)^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(?_asin)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(?_asin+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(?_asin+2)^080h
	
l6:	
	return
	opt stack 0
GLOBAL	__end_of_asin
	__end_of_asin:
; =============== function _asin ends ============

psect	text356,local,class=CODE,delta=2
global __ptext356
__ptext356:
	line	25
	signat	_asin,4219
	global	_atan

; *************** function _atan *****************
; Defined at:
;		line 9 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan.c"
; Parameters:    Size  Location     Type
;  f               3   46[BANK1 ] int 
; Auto vars:     Size  Location     Type
;  val             3   43[BANK1 ] int 
;  val_squared     3   40[BANK1 ] int 
;  recip           1   39[BANK1 ] unsigned char 
; Return value:  Size  Location     Type
;                  3   46[BANK1 ] unsigned char 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0      13       0       0
;      Temp:     0
;      Total:   13
; This function calls:
;		_fabs
;		___ftge
;		___ftdiv
;		___ftmul
;		_eval_poly
;		___ftsub
;		___ftneg
; This function is called by:
;		_asin
;		_atan2
; This function uses a non-reentrant model
; 
psect	text356
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan.c"
	line	9
	global	__size_of_atan
	__size_of_atan	equ	__end_of_atan-_atan
	
_atan:	
	opt stack 4
; Regs used in _atan: [allreg]
	line	30
	
l30001852:	
	movf	(atan@f)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@f+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@f+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	fcall	_fabs
	movf	(0+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(atan@val)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(atan@val+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_fabs)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(atan@val+2)^080h
	movf	((atan@val+2)^080h)&07fh,w
	iorwf	((atan@val+1)^080h)&07fh,w
	iorwf	((atan@val)^080h)&07fh,w
	skipz
	goto	u1511
	goto	u1510
u1511:
	goto	l30001855
u1510:
	
l30001853:	
	line	31
	clrf	(?_atan)^080h
	clrf	(?_atan+1)^080h
	clrf	(?_atan+2)^080h
	goto	l24
	
l30001855:	
	line	32
	movlw	0x0
	movwf	(?___ftge)
	movlw	0x80
	movwf	(?___ftge+1)
	movlw	0x3f
	movwf	(?___ftge+2)
	movf	(atan@val)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(atan@val+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(atan@val+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	movlw	0
	btfss	status,0
	movlw	1
	movwf	(atan@recip)^080h
	xorlw	0
	skipnz
	goto	u1521
	goto	u1520
u1521:
	goto	l26
u1520:
	
l30001856:	
	line	33
	movlw	0x0
	movwf	(?___ftdiv)^080h
	movlw	0x80
	movwf	(?___ftdiv+1)^080h
	movlw	0x3f
	movwf	(?___ftdiv+2)^080h
	movf	(atan@val)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(atan@val+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(atan@val+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(atan@val)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(atan@val+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(atan@val+2)^080h
	
l26:	
	line	34
	movf	(atan@val)^080h,w
	movwf	(?___ftmul)^080h
	movf	(atan@val+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(atan@val+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(atan@val)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(atan@val+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(atan@val+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(atan@val_squared)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(atan@val_squared+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(atan@val_squared+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(atan@val_squared)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@val_squared+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@val_squared+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+2)
	movlw	((atan@coeff_a-__stringbase))&0ffh
	movwf	(0+(?_eval_poly)+03h)
	movlw	05h
	movwf	0+(?_eval_poly)+04h
	clrf	1+(?_eval_poly)+04h
	fcall	_eval_poly
	movf	(0+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+2)^080h
	movf	(atan@val_squared)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@val_squared+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(atan@val_squared+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+2)
	movlw	((atan@coeff_b-__stringbase))&0ffh
	movwf	(0+(?_eval_poly)+03h)
	movlw	04h
	movwf	0+(?_eval_poly)+04h
	clrf	1+(?_eval_poly)+04h
	fcall	_eval_poly
	movf	(0+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftdiv)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	1+(?___ftdiv)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_atan$1005)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_atan$1005+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_atan$1005+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\atan.c"
	line	35
	movf	(atan@val)^080h,w
	movwf	(?___ftmul)^080h
	movf	(atan@val+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(atan@val+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(_atan$1005)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(_atan$1005+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(_atan$1005+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(atan@val)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(atan@val+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(atan@val+2)^080h
	
l30001857:	
	line	36
	movf	(atan@recip)^080h,w
	skipz
	goto	u1530
	goto	l30001859
u1530:
	
l30001858:	
	line	37
	movlw	0x10
	movwf	(?___ftsub)^080h
	movlw	0xc9
	movwf	(?___ftsub+1)^080h
	movlw	0x3f
	movwf	(?___ftsub+2)^080h
	movf	(atan@val)^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(atan@val+1)^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(atan@val+2)^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(atan@val)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(atan@val+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(atan@val+2)^080h
	
l30001859:	
	line	38
	movf	(atan@f)^080h,w
	movwf	(?___ftge)
	movf	(atan@f+1)^080h,w
	movwf	(?___ftge+1)
	movf	(atan@f+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfss	status,0
	goto	u1541
	goto	u1540
u1541:
	goto	l30001861
u1540:
	
l30001860:	
	movf	(atan@val)^080h,w
	movwf	(?_atan)^080h
	movf	(atan@val+1)^080h,w
	movwf	(?_atan+1)^080h
	movf	(atan@val+2)^080h,w
	movwf	(?_atan+2)^080h
	goto	l24
	
l30001861:	
	movf	(atan@val)^080h,w
	movwf	(?___ftneg)^080h
	movf	(atan@val+1)^080h,w
	movwf	(?___ftneg+1)^080h
	movf	(atan@val+2)^080h,w
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	movwf	(?_atan)^080h
	movf	(1+(?___ftneg))^080h,w
	movwf	(?_atan+1)^080h
	movf	(2+(?___ftneg))^080h,w
	movwf	(?_atan+2)^080h
	
l24:	
	return
	opt stack 0
GLOBAL	__end_of_atan
	__end_of_atan:
; =============== function _atan ends ============

psect	text357,local,class=CODE,delta=2
global __ptext357
__ptext357:
	line	39
	signat	_atan,4219
	global	_sqrt

; *************** function _sqrt *****************
; Defined at:
;		line 14 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\sqrt.c"
; Parameters:    Size  Location     Type
;  y               3   43[BANK1 ] unsigned char 
; Auto vars:     Size  Location     Type
;  x               3   40[BANK1 ] unsigned char 
;  q               3   37[BANK1 ] unsigned char 
;  z               3   33[BANK1 ] unsigned char 
;  i               1   36[BANK1 ] unsigned char 
; Return value:  Size  Location     Type
;                  3   43[BANK1 ] unsigned char 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       3      13       0       0
;      Temp:     3
;      Total:   16
; This function calls:
;		___ftge
;		___ftmul
;		___ftsub
; This function is called by:
;		_asin
; This function uses a non-reentrant model
; 
psect	text357
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\sqrt.c"
	line	14
	global	__size_of_sqrt
	__size_of_sqrt	equ	__end_of_sqrt-_sqrt
	
_sqrt:	
	opt stack 4
; Regs used in _sqrt: [allreg]
	line	19
	
l30001898:	
	clrf	(?___ftge)
	clrf	(?___ftge+1)
	clrf	(?___ftge+2)
	movf	(sqrt@y)^080h,w
	movwf	0+(?___ftge)+03h
	movf	(sqrt@y+1)^080h,w
	movwf	1+(?___ftge)+03h
	movf	(sqrt@y+2)^080h,w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfss	status,0
	goto	u1621
	goto	u1620
u1621:
	goto	l30001902
u1620:
	
l30001899:	
	line	20
	movf	(sqrt@y)^080h,w
	movwf	(?___ftge)
	movf	(sqrt@y+1)^080h,w
	movwf	(?___ftge+1)
	movf	(sqrt@y+2)^080h,w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1631
	goto	u1630
u1631:
	goto	l30001900
u1630:
	
l30001900:	
	line	22
	clrf	(?_sqrt)^080h
	clrf	(?_sqrt+1)^080h
	clrf	(?_sqrt+2)^080h
	goto	l42
	
l30001902:	
	line	24
	movf	(sqrt@y)^080h,w
	movwf	(sqrt@z)^080h
	movf	(sqrt@y+1)^080h,w
	movwf	(sqrt@z+1)^080h
	movf	(sqrt@y+2)^080h,w
	movwf	(sqrt@z+2)^080h
	
l30001903:	
	line	30
	movf	(sqrt@y)^080h,w
	sublw	low(0BE6EC8h)
	movwf	(sqrt@x)^080h
	movf	(sqrt@y+1)^080h,w
	skipc
	incfsz	(sqrt@y+1)^080h,w
	sublw	high(0BE6EC8h)
	movwf	1+(sqrt@x)^080h
	movf	(sqrt@y+2)^080h,w
	skipc
	incfsz	(sqrt@y+2)^080h,w
	sublw	low highword(0BE6EC8h)
	movwf	2+(sqrt@x)^080h
	line	31
	clrc
	rrf	(sqrt@x+2)^080h,f
	rrf	(sqrt@x+1)^080h,f
	rrf	(sqrt@x)^080h,f
	
l30001904:	
	line	32
	movlw	low(08000h)
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??_sqrt+0+0)
	movlw	high(08000h)
	movwf	(??_sqrt+0+0+1)
	movlw	low highword(08000h)
	movwf	(??_sqrt+0+0+2)
	movf	0+(??_sqrt+0+0),w
	bsf	status, 5	;RP0=1, select bank1
	subwf	(sqrt@z)^080h,f
	bcf	status, 5	;RP0=0, select bank0
	movf	1+(??_sqrt+0+0),w
	skipc
	incfsz	1+(??_sqrt+0+0),w
	goto	u1645
	goto	u1646
u1645:
	bsf	status, 5	;RP0=1, select bank1
	subwf	(sqrt@z+1)^080h,f
u1646:
	bcf	status, 5	;RP0=0, select bank0
	movf	2+(??_sqrt+0+0),w
	skipc
	incf	2+(??_sqrt+0+0),w
	goto	u1647
	goto	u1648
u1647:
	bsf	status, 5	;RP0=1, select bank1
	subwf	(sqrt@z+2)^080h,f
u1648:
	bcf	status, 5	;RP0=0, select bank0
	bsf	status, 5	;RP0=1, select bank1

	
l30001905:	
	line	34
	movlw	(04h)
	movwf	(sqrt@i)^080h
	
l30001906:	
	line	37
	movf	(sqrt@x)^080h,w
	movwf	(?___ftmul)^080h
	movf	(sqrt@x+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(sqrt@x+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(sqrt@z)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(sqrt@z+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(sqrt@z+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(sqrt@q)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(sqrt@q+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(sqrt@q+2)^080h
	
l30001907:	
	line	38
	movf	(sqrt@q)^080h,w
	movwf	(?___ftmul)^080h
	movf	(sqrt@q+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(sqrt@q+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(sqrt@x)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(sqrt@x+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(sqrt@x+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(sqrt@q)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(sqrt@q+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(sqrt@q+2)^080h
	
l30001908:	
	line	39
	movf	(sqrt@q)^080h,w
	movwf	(?___ftmul)^080h
	movf	(sqrt@q+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(sqrt@q+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(sqrt@x)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(sqrt@x+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(sqrt@x+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(sqrt@q)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(sqrt@q+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(sqrt@q+2)^080h
	
l30001909:	
	line	40
	movf	(sqrt@x)^080h,w
	movwf	(?___ftmul)^080h
	movf	(sqrt@x+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(sqrt@x+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movlw	0x0
	movwf	0+(?___ftmul)^080h+03h
	movlw	0xc0
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3f
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(sqrt@x)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(sqrt@x+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(sqrt@x+2)^080h
	
l30001910:	
	line	41
	movf	(sqrt@x)^080h,w
	movwf	(?___ftsub)^080h
	movf	(sqrt@x+1)^080h,w
	movwf	(?___ftsub+1)^080h
	movf	(sqrt@x+2)^080h,w
	movwf	(?___ftsub+2)^080h
	movf	(sqrt@q)^080h,w
	movwf	0+(?___ftsub)^080h+03h
	movf	(sqrt@q+1)^080h,w
	movwf	1+(?___ftsub)^080h+03h
	movf	(sqrt@q+2)^080h,w
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	movwf	(sqrt@x)^080h
	movf	(1+(?___ftsub))^080h,w
	movwf	(sqrt@x+1)^080h
	movf	(2+(?___ftsub))^080h,w
	movwf	(sqrt@x+2)^080h
	
l30001911:	
	line	42
	decfsz	(sqrt@i)^080h,f
	goto	u1651
	goto	u1650
u1651:
	goto	l30001906
u1650:
	
l30001912:	
	line	43
	movf	(sqrt@x)^080h,w
	movwf	(?___ftmul)^080h
	movf	(sqrt@x+1)^080h,w
	movwf	(?___ftmul+1)^080h
	movf	(sqrt@x+2)^080h,w
	movwf	(?___ftmul+2)^080h
	movf	(sqrt@y)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(sqrt@y+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(sqrt@y+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?_sqrt)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?_sqrt+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?_sqrt+2)^080h
	
l42:	
	return
	opt stack 0
GLOBAL	__end_of_sqrt
	__end_of_sqrt:
; =============== function _sqrt ends ============

psect	text358,local,class=CODE,delta=2
global __ptext358
__ptext358:
	line	44
	signat	_sqrt,4219
	global	_sin

; *************** function _sin *****************
; Defined at:
;		line 14 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\sin.c"
; Parameters:    Size  Location     Type
;  f               3   32[BANK0 ] unsigned char 
; Auto vars:     Size  Location     Type
;  x2              3   42[BANK1 ] unsigned char 
;  y               3   39[BANK1 ] unsigned char 
;  sgn             1   45[BANK1 ] unsigned char 
; Return value:  Size  Location     Type
;                  3   32[BANK0 ] unsigned char 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       3      10       0       0
;      Temp:     0
;      Total:   13
; This function calls:
;		___ftge
;		___ftneg
;		___ftmul
;		_floor
;		___ftsub
;		_eval_poly
;		___ftdiv
; This function is called by:
;		_main
;		_cos
;		_tan
; This function uses a non-reentrant model
; 
psect	text358
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\sin.c"
	line	14
	global	__size_of_sin
	__size_of_sin	equ	__end_of_sin-_sin
	
_sin:	
	opt stack 4
; Regs used in _sin: [allreg]
	line	37
	
l30001878:	
	bsf	status, 5	;RP0=1, select bank1
	clrf	(sin@sgn)^080h
	
l30001879:	
	line	38
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	movwf	(?___ftge)
	movf	(sin@f+1),w
	movwf	(?___ftge+1)
	movf	(sin@f+2),w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1581
	goto	u1580
u1581:
	goto	l30001882
u1580:
	
l30001880:	
	line	39
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001881:	
	line	40
	bsf	status, 5	;RP0=1, select bank1
	clrf	(sin@sgn)^080h
	incf	(sin@sgn)^080h,f
	
l30001882:	
	line	42
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0xfa
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x22
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x3e
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001883:	
	line	43
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	movwf	(?_floor)
	movf	(sin@f+1),w
	movwf	(?_floor+1)
	movf	(sin@f+2),w
	movwf	(?_floor+2)
	fcall	_floor
	movf	(0+(?_floor)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_floor)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	1+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_floor)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001884:	
	line	44
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	movlw	0x0
	movwf	0+(?___ftmul)^080h+03h
	movlw	0x80
	movwf	1+(?___ftmul)^080h+03h
	movlw	0x40
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001885:	
	line	45
	movlw	0x0
	movwf	(?___ftge)
	movlw	0x0
	movwf	(?___ftge+1)
	movlw	0x40
	movwf	(?___ftge+2)
	movf	(sin@f),w
	movwf	0+(?___ftge)+03h
	movf	(sin@f+1),w
	movwf	1+(?___ftge)+03h
	movf	(sin@f+2),w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1591
	goto	u1590
u1591:
	goto	l30001888
u1590:
	
l30001886:	
	line	46
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub+2)^080h
	movlw	0x0
	movwf	0+(?___ftsub)^080h+03h
	movlw	0x0
	movwf	1+(?___ftsub)^080h+03h
	movlw	0x40
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001887:	
	line	47
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@sgn)^080h,w
	xorlw	0
	movlw	0
	skipnz
	movlw	1
	movwf	(sin@sgn)^080h
	
l30001888:	
	line	49
	movlw	0x0
	movwf	(?___ftge)
	movlw	0x80
	movwf	(?___ftge+1)
	movlw	0x3f
	movwf	(?___ftge+2)
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	movwf	0+(?___ftge)+03h
	movf	(sin@f+1),w
	movwf	1+(?___ftge)+03h
	movf	(sin@f+2),w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1601
	goto	u1600
u1601:
	goto	l39
u1600:
	
l30001889:	
	line	50
	movlw	0x0
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftsub)^080h
	movlw	0x0
	movwf	(?___ftsub+1)^080h
	movlw	0x40
	movwf	(?___ftsub+2)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	1+(?___ftsub)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	2+(?___ftsub)^080h+03h
	fcall	___ftsub
	movf	(0+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftsub))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l39:	
	line	51
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(sin@x2)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(sin@x2+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(sin@x2+2)^080h
	line	52
	movf	(sin@x2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly)
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@x2+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@x2+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+2)
	movlw	((sin@coeff_b-__stringbase))&0ffh
	movwf	(0+(?_eval_poly)+03h)
	movlw	03h
	movwf	0+(?_eval_poly)+04h
	clrf	1+(?_eval_poly)+04h
	fcall	_eval_poly
	movf	(0+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(sin@y)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(sin@y+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(sin@y+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\aldiv.c"
	line	37
	movf	(sin@x2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly)
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@x2+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@x2+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_eval_poly+2)
	movlw	((sin@coeff_a-__stringbase))&0ffh
	movwf	(0+(?_eval_poly)+03h)
	movlw	04h
	movwf	0+(?_eval_poly)+04h
	clrf	1+(?_eval_poly)+04h
	fcall	_eval_poly
	movf	(0+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?_eval_poly)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+2)^080h
	movf	(sin@y)^080h,w
	movwf	0+(?___ftdiv)^080h+03h
	movf	(sin@y+1)^080h,w
	movwf	1+(?___ftdiv)^080h+03h
	movf	(sin@y+2)^080h,w
	movwf	2+(?___ftdiv)^080h+03h
	fcall	___ftdiv
	movf	(0+(?___ftdiv))^080h,w
	movwf	(_sin$1007)^080h
	movf	(1+(?___ftdiv))^080h,w
	movwf	(_sin$1007+1)^080h
	movf	(2+(?___ftdiv))^080h,w
	movwf	(_sin$1007+2)^080h
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\sin.c"
	line	53
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	movf	(_sin$1007)^080h,w
	movwf	0+(?___ftmul)^080h+03h
	movf	(_sin$1007+1)^080h,w
	movwf	1+(?___ftmul)^080h+03h
	movf	(_sin$1007+2)^080h,w
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftmul))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(sin@f+2)
	
l30001890:	
	line	54
	bsf	status, 5	;RP0=1, select bank1
	movf	(sin@sgn)^080h,w
	skipz
	goto	u1610
	goto	l30001893
u1610:
	
l30001891:	
	line	55
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_sin+2)
	goto	l36
	
l30001893:	
	line	56
	bcf	status, 5	;RP0=0, select bank0
	movf	(sin@f),w
	movwf	(?_sin)
	movf	(sin@f+1),w
	movwf	(?_sin+1)
	movf	(sin@f+2),w
	movwf	(?_sin+2)
	
l36:	
	return
	opt stack 0
GLOBAL	__end_of_sin
	__end_of_sin:
; =============== function _sin ends ============

psect	text359,local,class=CODE,delta=2
global __ptext359
__ptext359:
	line	57
	signat	_sin,4219
	global	_eval_poly

; *************** function _eval_poly *****************
; Defined at:
;		line 5 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\evalpoly.c"
; Parameters:    Size  Location     Type
;  x               3    9[BANK0 ] unsigned char 
;  d               1   12[BANK0 ] PTR const 
;		 -> atan@coeff_b(15), atan@coeff_a(18), sin@coeff_b(12), sin@coeff_a(15), 
;  n               2   13[BANK0 ] int 
; Auto vars:     Size  Location     Type
;  res             3    6[BANK0 ] int 
; Return value:  Size  Location     Type
;                  3    9[BANK0 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         4       9       0       0       0
;      Temp:     4
;      Total:   13
; This function calls:
;		___ftmul
;		___ftadd
; This function is called by:
;		_atan
;		_sin
; This function uses a non-reentrant model
; 
psect	text359
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\evalpoly.c"
	line	5
	global	__size_of_eval_poly
	__size_of_eval_poly	equ	__end_of_eval_poly-_eval_poly
	
_eval_poly:	
	opt stack 3
; Regs used in _eval_poly: [allreg]
	line	8
	
l30001847:	
	movf	(eval_poly@n),w
	addwf	(eval_poly@n),w
	addwf	(eval_poly@n),w
	movwf	(??_eval_poly+0+0)
	movf	(eval_poly@d),w
	addwf	(??_eval_poly+0+0),w
	movwf	(??_eval_poly+1+0)
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	movwf	(eval_poly@res)
	incf	(??_eval_poly+1+0),f
	movf	(??_eval_poly+1+0),w
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	movwf	(eval_poly@res+1)
	incf	(??_eval_poly+1+0),f
	movf	(??_eval_poly+1+0),w
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	movwf	(eval_poly@res+2)
	goto	l30001849
	
l30001848:	
	line	10
	movf	(eval_poly@x),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(eval_poly@x+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(eval_poly@x+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(eval_poly@res),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftmul)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(eval_poly@res+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	1+(?___ftmul)^080h+03h
	bcf	status, 5	;RP0=0, select bank0
	movf	(eval_poly@res+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	2+(?___ftmul)^080h+03h
	fcall	___ftmul
	movf	(0+(?___ftmul))^080h,w
	movwf	(?___ftadd)^080h
	movf	(1+(?___ftmul))^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(2+(?___ftmul))^080h,w
	movwf	(?___ftadd+2)^080h
	movlw	-1
	bcf	status, 5	;RP0=0, select bank0
	addwf	(eval_poly@n),f
	skipc
	decf	(eval_poly@n+1),f
	movf	((eval_poly@n+1))&07fh,w
	movwf	(??_eval_poly+0+0+1)
	movf	((eval_poly@n))&07fh,w
	movwf	(??_eval_poly+0+0)
	movf	0+(??_eval_poly+0+0),w
	addwf	0+(??_eval_poly+0+0),w
	addwf	0+(??_eval_poly+0+0),w
	movwf	(??_eval_poly+2+0)
	movf	(eval_poly@d),w
	addwf	(??_eval_poly+2+0),w
	movwf	(??_eval_poly+3+0)
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	bsf	status, 5	;RP0=1, select bank1
	movwf	0+(?___ftadd)^080h+03h
	incf	(??_eval_poly+3+0),f
	movf	(??_eval_poly+3+0),w
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	movwf	1+(?___ftadd)^080h+03h
	incf	(??_eval_poly+3+0),f
	movf	(??_eval_poly+3+0),w
	FNCALL _eval_poly,stringtab
	fcall	stringdir
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(eval_poly@res)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(eval_poly@res+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(eval_poly@res+2)
	
l30001849:	
	line	9
	movf	((eval_poly@n+1)),w
	iorwf	((eval_poly@n)),w
	skipz
	goto	u1501
	goto	u1500
u1501:
	goto	l30001848
u1500:
	
l30001850:	
	line	11
	movf	(eval_poly@res),w
	movwf	(?_eval_poly)
	movf	(eval_poly@res+1),w
	movwf	(?_eval_poly+1)
	movf	(eval_poly@res+2),w
	movwf	(?_eval_poly+2)
	
l30:	
	return
	opt stack 0
GLOBAL	__end_of_eval_poly
	__end_of_eval_poly:
; =============== function _eval_poly ends ============

psect	text360,local,class=CODE,delta=2
global __ptext360
__ptext360:
	line	12
	signat	_eval_poly,12411
	global	___ftdiv

; *************** function ___ftdiv *****************
; Defined at:
;		line 50 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftdiv.c"
; Parameters:    Size  Location     Type
;  f1              3    0[BANK1 ] float 
;  f2              3    3[BANK1 ] float 
; Auto vars:     Size  Location     Type
;  f3              3   16[BANK0 ] float 
;  sign            1   20[BANK0 ] unsigned char 
;  exp             1   19[BANK0 ] unsigned char 
;  cntr            1   15[BANK0 ] unsigned char 
; Return value:  Size  Location     Type
;                  3    0[BANK1 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         3       6       6       0       0
;      Temp:     3
;      Total:   15
; This function calls:
;		___ftpack
; This function is called by:
;		_main
;		_asin
;		_atan2
;		_atan
;		_sin
;		_tan
; This function uses a non-reentrant model
; 
psect	text360
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftdiv.c"
	line	50
	global	__size_of___ftdiv
	__size_of___ftdiv	equ	__end_of___ftdiv-___ftdiv
	
___ftdiv:	
	opt stack 3
; Regs used in ___ftdiv: [wreg+status,2+status,0+pclath+cstack]
	line	55
	
l30001972:	
	movf	(___ftdiv@f1)^080h,w
	movwf	(??___ftdiv+0+0)
	movf	(___ftdiv@f1+1)^080h,w
	movwf	(??___ftdiv+0+0+1)
	movf	(___ftdiv@f1+2)^080h,w
	movwf	(??___ftdiv+0+0+2)
	clrc
	rlf	(??___ftdiv+0+1),w
	rlf	(??___ftdiv+0+2),w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(___ftdiv@exp)
	movf	((___ftdiv@exp))&07fh,f
	skipz
	goto	u1851
	goto	u1850
u1851:
	goto	l30001975
u1850:
	
l30001973:	
	line	56
	bsf	status, 5	;RP0=1, select bank1
	clrf	(?___ftdiv)^080h
	clrf	(?___ftdiv+1)^080h
	clrf	(?___ftdiv+2)^080h
	goto	l120
	
l30001975:	
	line	57
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftdiv@f2)^080h,w
	movwf	(??___ftdiv+0+0)
	movf	(___ftdiv@f2+1)^080h,w
	movwf	(??___ftdiv+0+0+1)
	movf	(___ftdiv@f2+2)^080h,w
	movwf	(??___ftdiv+0+0+2)
	clrc
	rlf	(??___ftdiv+0+1),w
	rlf	(??___ftdiv+0+2),w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(___ftdiv@sign)
	movf	((___ftdiv@sign))&07fh,f
	skipz
	goto	u1861
	goto	u1860
u1861:
	goto	l122
u1860:
	
l30001976:	
	line	58
	bsf	status, 5	;RP0=1, select bank1
	clrf	(?___ftdiv)^080h
	clrf	(?___ftdiv+1)^080h
	clrf	(?___ftdiv+2)^080h
	goto	l120
	
l122:	
	line	59
	clrf	(___ftdiv@f3)
	clrf	(___ftdiv@f3+1)
	clrf	(___ftdiv@f3+2)
	
l30001978:	
	line	60
	movf	(___ftdiv@sign),w
	addlw	089h
	movwf	(??___ftdiv+0+0)
	movf	(??___ftdiv+0+0),w
	subwf	(___ftdiv@exp),f
	
l30001979:	
	line	61
	bsf	status, 5	;RP0=1, select bank1
	movf	0+(((___ftdiv@f1)^080h)+2),w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(___ftdiv@sign)
	
l30001980:	
	line	62
	bsf	status, 5	;RP0=1, select bank1
	movf	0+(((___ftdiv@f2)^080h)+2),w
	bcf	status, 5	;RP0=0, select bank0
	xorwf	(___ftdiv@sign),f
	
l30001981:	
	line	63
	movlw	(080h)
	andwf	(___ftdiv@sign),f
	
l30001982:	
	line	64
	bsf	status, 5	;RP0=1, select bank1
	bsf	(___ftdiv@f1)^080h+(15/8),(15)&7
	
l30001983:	
	line	65
	movlw	0FFh
	andwf	(___ftdiv@f1)^080h,f
	movlw	0FFh
	andwf	(___ftdiv@f1+1)^080h,f
	movlw	0
	andwf	(___ftdiv@f1+2)^080h,f
	
l30001984:	
	line	66
	bsf	(___ftdiv@f2)^080h+(15/8),(15)&7
	
l30001985:	
	line	67
	movlw	0FFh
	andwf	(___ftdiv@f2)^080h,f
	movlw	0FFh
	andwf	(___ftdiv@f2+1)^080h,f
	movlw	0
	andwf	(___ftdiv@f2+2)^080h,f
	
l30001986:	
	line	68
	movlw	(018h)
	bcf	status, 5	;RP0=0, select bank0
	movwf	(___ftdiv@cntr)
	
l30001987:	
	line	70
	clrc
	rlf	(___ftdiv@f3),f
	rlf	(___ftdiv@f3+1),f
	rlf	(___ftdiv@f3+2),f
	line	71
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftdiv@f2+2)^080h,w
	subwf	(___ftdiv@f1+2)^080h,w
	skipz
	goto	u1875
	movf	(___ftdiv@f2+1)^080h,w
	subwf	(___ftdiv@f1+1)^080h,w
	skipz
	goto	u1875
	movf	(___ftdiv@f2)^080h,w
	subwf	(___ftdiv@f1)^080h,w
u1875:
	skipc
	goto	u1871
	goto	u1870
u1871:
	goto	l30001990
u1870:
	
l30001988:	
	line	72
	movf	(___ftdiv@f2)^080h,w
	subwf	(___ftdiv@f1)^080h,f
	movf	(___ftdiv@f2+1)^080h,w
	skipc
	incfsz	(___ftdiv@f2+1)^080h,w
	subwf	(___ftdiv@f1+1)^080h,f
	movf	(___ftdiv@f2+2)^080h,w
	skipc
	incf	(___ftdiv@f2+2)^080h,w
	subwf	(___ftdiv@f1+2)^080h,f
	
l30001989:	
	line	73
	bcf	status, 5	;RP0=0, select bank0
	bsf	(___ftdiv@f3)+(0/8),(0)&7
	
l30001990:	
	line	75
	clrc
	bsf	status, 5	;RP0=1, select bank1
	rlf	(___ftdiv@f1)^080h,f
	rlf	(___ftdiv@f1+1)^080h,f
	rlf	(___ftdiv@f1+2)^080h,f
	
l30001991:	
	line	76
	bcf	status, 5	;RP0=0, select bank0
	decfsz	(___ftdiv@cntr),f
	goto	u1881
	goto	u1880
u1881:
	goto	l30001987
u1880:
	
l30001992:	
	line	77
	movf	(___ftdiv@f3),w
	movwf	(?___ftpack)
	movf	(___ftdiv@f3+1),w
	movwf	(?___ftpack+1)
	movf	(___ftdiv@f3+2),w
	movwf	(?___ftpack+2)
	movf	(___ftdiv@exp),w
	movwf	0+(?___ftpack)+03h
	movf	(___ftdiv@sign),w
	movwf	0+(?___ftpack)+04h
	fcall	___ftpack
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftdiv+2)^080h
	
l120:	
	return
	opt stack 0
GLOBAL	__end_of___ftdiv
	__end_of___ftdiv:
; =============== function ___ftdiv ends ============

psect	text361,local,class=CODE,delta=2
global __ptext361
__ptext361:
	line	78
	signat	___ftdiv,8315
	global	___ftsub

; *************** function ___ftsub *****************
; Defined at:
;		line 17 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftsub.c"
; Parameters:    Size  Location     Type
;  f1              3   27[BANK1 ] float 
;  f2              3   30[BANK1 ] float 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   27[BANK1 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0       6       0       0
;      Temp:     0
;      Total:    6
; This function calls:
;		___ftadd
; This function is called by:
;		_main
;		_acos
;		_asin
;		_atan2
;		_atan
;		_sin
;		_sqrt
; This function uses a non-reentrant model
; 
psect	text361
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftsub.c"
	line	17
	global	__size_of___ftsub
	__size_of___ftsub	equ	__end_of___ftsub-___ftsub
	
___ftsub:	
	opt stack 3
; Regs used in ___ftsub: [wreg+status,2+status,0+pclath+cstack]
	line	18
	
l30001895:	
	movlw	080h
	xorwf	(___ftsub@f2+2)^080h,f
	
l30001896:	
	line	19
	movf	(___ftsub@f1)^080h,w
	movwf	(?___ftadd)^080h
	movf	(___ftsub@f1+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(___ftsub@f1+2)^080h,w
	movwf	(?___ftadd+2)^080h
	movf	(___ftsub@f2)^080h,w
	movwf	0+(?___ftadd)^080h+03h
	movf	(___ftsub@f2+1)^080h,w
	movwf	1+(?___ftadd)^080h+03h
	movf	(___ftsub@f2+2)^080h,w
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	movwf	(?___ftsub)^080h
	movf	(1+(?___ftadd))^080h,w
	movwf	(?___ftsub+1)^080h
	movf	(2+(?___ftadd))^080h,w
	movwf	(?___ftsub+2)^080h
	
l119:	
	return
	opt stack 0
GLOBAL	__end_of___ftsub
	__end_of___ftsub:
; =============== function ___ftsub ends ============

psect	text362,local,class=CODE,delta=2
global __ptext362
__ptext362:
	line	20
	signat	___ftsub,8315
	global	_fabs

; *************** function _fabs *****************
; Defined at:
;		line 5 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\fabs.c"
; Parameters:    Size  Location     Type
;  d               3   32[BANK0 ] float 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   32[BANK0 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 160/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       3       0       0       0
;      Temp:     0
;      Total:    3
; This function calls:
;		___ftge
;		___ftneg
; This function is called by:
;		_asin
;		_atan2
;		_atan
; This function uses a non-reentrant model
; 
psect	text362
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\fabs.c"
	line	5
	global	__size_of_fabs
	__size_of_fabs	equ	__end_of_fabs-_fabs
	
_fabs:	
	opt stack 3
; Regs used in _fabs: [wreg+status,2+status,0+pclath+cstack]
	line	6
	
l30002036:	
	movf	(fabs@d),w
	movwf	(?___ftge)
	movf	(fabs@d+1),w
	movwf	(?___ftge+1)
	movf	(fabs@d+2),w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u2041
	goto	u2040
u2041:
	goto	l30002039
u2040:
	
l30002037:	
	line	7
	movf	(fabs@d),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(fabs@d+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(fabs@d+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftneg+2)^080h
	fcall	___ftneg
	movf	(0+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftneg))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_fabs+2)
	goto	l34
	
l30002039:	
	line	8
	movf	(fabs@d),w
	movwf	(?_fabs)
	movf	(fabs@d+1),w
	movwf	(?_fabs+1)
	movf	(fabs@d+2),w
	movwf	(?_fabs+2)
	
l34:	
	return
	opt stack 0
GLOBAL	__end_of_fabs
	__end_of_fabs:
; =============== function _fabs ends ============

psect	text363,local,class=CODE,delta=2
global __ptext363
__ptext363:
	line	9
	signat	_fabs,4219
	global	_floor

; *************** function _floor *****************
; Defined at:
;		line 14 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\floor.c"
; Parameters:    Size  Location     Type
;  x               3   29[BANK0 ] float 
; Auto vars:     Size  Location     Type
;  i               3   26[BANK0 ] float 
;  expon           2   24[BANK0 ] int 
; Return value:  Size  Location     Type
;                  3   29[BANK0 ] int 
; Registers used:
;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, status,2, status,0, btemp+0, btemp+1, btemp+2, btemp+3, pclath, cstack
; Tracked objects:
;		On entry : 160/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       8       0       0       0
;      Temp:     0
;      Total:    8
; This function calls:
;		_frexp
;		___ftge
;		___fttol
;		___altoft
;		___ftadd
; This function is called by:
;		_sin
; This function uses a non-reentrant model
; 
psect	text363
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\floor.c"
	line	14
	global	__size_of_floor
	__size_of_floor	equ	__end_of_floor-_floor
	
_floor:	
	opt stack 3
; Regs used in _floor: [allreg]
	line	18
	
l30001914:	
	movf	(floor@x),w
	movwf	(?_frexp)
	movf	(floor@x+1),w
	movwf	(?_frexp+1)
	movf	(floor@x+2),w
	movwf	(?_frexp+2)
	movlw	((floor@expon))&0ffh
	movwf	(0+(?_frexp)+03h)
	fcall	_frexp
	
l30001915:	
	line	19
	btfss	(floor@expon+1),7
	goto	u1661
	goto	u1660
u1661:
	goto	l30001921
u1660:
	
l30001916:	
	line	20
	movf	(floor@x),w
	movwf	(?___ftge)
	movf	(floor@x+1),w
	movwf	(?___ftge+1)
	movf	(floor@x+2),w
	movwf	(?___ftge+2)
	clrf	0+(?___ftge)+03h
	clrf	1+(?___ftge)+03h
	clrf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1671
	goto	u1670
u1671:
	goto	l30001919
u1670:
	
l30001917:	
	line	21
	movlw	0x0
	movwf	(?_floor)
	movlw	0x80
	movwf	(?_floor+1)
	movlw	0xbf
	movwf	(?_floor+2)
	goto	l383
	
l30001919:	
	line	22
	clrf	(?_floor)
	clrf	(?_floor+1)
	clrf	(?_floor+2)
	goto	l383
	
l30001921:	
	line	24
	movlw	high(015h)
	subwf	(floor@expon+1),w
	movlw	low(015h)
	skipnz
	subwf	(floor@expon),w
	skipc
	goto	u1681
	goto	u1680
u1681:
	goto	l30001924
u1680:
	
l30001922:	
	line	25
	movf	(floor@x),w
	movwf	(?_floor)
	movf	(floor@x+1),w
	movwf	(?_floor+1)
	movf	(floor@x+2),w
	movwf	(?_floor+2)
	goto	l383
	
l30001924:	
	line	26
	movf	(floor@x),w
	movwf	(?___fttol)
	movf	(floor@x+1),w
	movwf	(?___fttol+1)
	movf	(floor@x+2),w
	movwf	(?___fttol+2)
	fcall	___fttol
	movf	(3+(?___fttol)),w
	movwf	(?___altoft+3)
	movf	(2+(?___fttol)),w
	movwf	(?___altoft+2)
	movf	(1+(?___fttol)),w
	movwf	(?___altoft+1)
	movf	(0+(?___fttol)),w
	movwf	(?___altoft)

	fcall	___altoft
	movf	(0+(?___altoft)),w
	movwf	(floor@i)
	movf	(1+(?___altoft)),w
	movwf	(floor@i+1)
	movf	(2+(?___altoft)),w
	movwf	(floor@i+2)
	
l30001925:	
	line	27
	movf	(floor@x),w
	movwf	(?___ftge)
	movf	(floor@x+1),w
	movwf	(?___ftge+1)
	movf	(floor@x+2),w
	movwf	(?___ftge+2)
	movf	(floor@i),w
	movwf	0+(?___ftge)+03h
	movf	(floor@i+1),w
	movwf	1+(?___ftge)+03h
	movf	(floor@i+2),w
	movwf	2+(?___ftge)+03h
	fcall	___ftge
	btfsc	status,0
	goto	u1691
	goto	u1690
u1691:
	goto	l30001928
u1690:
	
l30001926:	
	line	28
	movf	(floor@i),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(floor@i+1),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(floor@i+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+2)^080h
	movlw	0x0
	movwf	0+(?___ftadd)^080h+03h
	movlw	0x80
	movwf	1+(?___ftadd)^080h+03h
	movlw	0xbf
	movwf	2+(?___ftadd)^080h+03h
	fcall	___ftadd
	movf	(0+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_floor)
	bsf	status, 5	;RP0=1, select bank1
	movf	(1+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_floor+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(2+(?___ftadd))^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?_floor+2)
	goto	l383
	
l30001928:	
	line	29
	movf	(floor@i),w
	movwf	(?_floor)
	movf	(floor@i+1),w
	movwf	(?_floor+1)
	movf	(floor@i+2),w
	movwf	(?_floor+2)
	
l383:	
	return
	opt stack 0
GLOBAL	__end_of_floor
	__end_of_floor:
; =============== function _floor ends ============

psect	text364,local,class=CODE,delta=2
global __ptext364
__ptext364:
	line	30
	signat	_floor,4219
	global	___ftmul

; *************** function ___ftmul *****************
; Defined at:
;		line 52 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftmul.c"
; Parameters:    Size  Location     Type
;  f1              3   21[BANK1 ] float 
;  f2              3   24[BANK1 ] float 
; Auto vars:     Size  Location     Type
;  f3_as_produc    3   16[BANK1 ] unsigned um
;  sign            1   20[BANK1 ] unsigned char 
;  cntr            1   19[BANK1 ] unsigned char 
;  exp             1   15[BANK1 ] unsigned char 
; Return value:  Size  Location     Type
;                  3   21[BANK1 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       3      12       0       0
;      Temp:     3
;      Total:   15
; This function calls:
;		___ftpack
; This function is called by:
;		_main
;		_asin
;		_atan
;		_eval_poly
;		_sin
;		_sqrt
; This function uses a non-reentrant model
; 
psect	text364
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftmul.c"
	line	52
	global	__size_of___ftmul
	__size_of___ftmul	equ	__end_of___ftmul-___ftmul
	
___ftmul:	
	opt stack 2
; Regs used in ___ftmul: [wreg+status,2+status,0+pclath+cstack]
	line	56
	
l30001930:	
	movf	(___ftmul@f1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f1+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f1+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0+2)
	clrc
	rlf	(??___ftmul+0+1),w
	rlf	(??___ftmul+0+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(___ftmul@exp)^080h
	movf	((___ftmul@exp)^080h)&07fh,f
	skipz
	goto	u1701
	goto	u1700
u1701:
	goto	l30001933
u1700:
	
l30001931:	
	line	57
	clrf	(?___ftmul)^080h
	clrf	(?___ftmul+1)^080h
	clrf	(?___ftmul+2)^080h
	goto	l127
	
l30001933:	
	line	58
	movf	(___ftmul@f2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f2+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f2+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftmul+0+0+2)
	clrc
	rlf	(??___ftmul+0+1),w
	rlf	(??___ftmul+0+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(___ftmul@sign)^080h
	movf	((___ftmul@sign)^080h)&07fh,f
	skipz
	goto	u1711
	goto	u1710
u1711:
	goto	l30001936
u1710:
	
l30001934:	
	line	59
	clrf	(?___ftmul)^080h
	clrf	(?___ftmul+1)^080h
	clrf	(?___ftmul+2)^080h
	goto	l127
	
l30001936:	
	line	60
	movf	(___ftmul@sign)^080h,w
	addlw	07Bh
	addwf	(___ftmul@exp)^080h,f
	
l30001937:	
	line	61
	movf	0+(((___ftmul@f1)^080h)+2),w
	movwf	(___ftmul@sign)^080h
	
l30001938:	
	line	62
	movf	0+(((___ftmul@f2)^080h)+2),w
	xorwf	(___ftmul@sign)^080h,f
	
l30001939:	
	line	63
	movlw	(080h)
	andwf	(___ftmul@sign)^080h,f
	
l30001940:	
	line	64
	bsf	(___ftmul@f1)^080h+(15/8),(15)&7
	
l30001941:	
	line	66
	bsf	(___ftmul@f2)^080h+(15/8),(15)&7
	
l30001942:	
	line	67
	movlw	0FFh
	andwf	(___ftmul@f2)^080h,f
	movlw	0FFh
	andwf	(___ftmul@f2+1)^080h,f
	movlw	0
	andwf	(___ftmul@f2+2)^080h,f
	
l30001943:	
	line	68
	clrf	(___ftmul@f3_as_product)^080h
	clrf	(___ftmul@f3_as_product+1)^080h
	clrf	(___ftmul@f3_as_product+2)^080h
	
l30001944:	
	line	69
	movlw	(07h)
	movwf	(___ftmul@cntr)^080h
	
l30001945:	
	line	71
	btfss	(___ftmul@f1)^080h,(0)&7
	goto	u1721
	goto	u1720
u1721:
	goto	l30001947
u1720:
	
l30001946:	
	line	72
	movf	(___ftmul@f2)^080h,w
	addwf	(___ftmul@f3_as_product)^080h,f
	movf	(___ftmul@f2+1)^080h,w
	clrz
	skipnc
	incf	(___ftmul@f2+1)^080h,w
	skipnz
	goto	u1731
	addwf	(___ftmul@f3_as_product+1)^080h,f
u1731:
	movf	(___ftmul@f2+2)^080h,w
	clrz
	skipnc
	incf	(___ftmul@f2+2)^080h,w
	skipnz
	goto	u1732
	addwf	(___ftmul@f3_as_product+2)^080h,f
u1732:

	
l30001947:	
	line	73
	clrc
	rrf	(___ftmul@f1+2)^080h,f
	rrf	(___ftmul@f1+1)^080h,f
	rrf	(___ftmul@f1)^080h,f
	
l30001948:	
	line	74
	clrc
	rlf	(___ftmul@f2)^080h,f
	rlf	(___ftmul@f2+1)^080h,f
	rlf	(___ftmul@f2+2)^080h,f
	
l30001949:	
	line	75
	decfsz	(___ftmul@cntr)^080h,f
	goto	u1741
	goto	u1740
u1741:
	goto	l30001945
u1740:
	
l30001950:	
	line	76
	movlw	(09h)
	movwf	(___ftmul@cntr)^080h
	
l30001951:	
	line	78
	btfss	(___ftmul@f1)^080h,(0)&7
	goto	u1751
	goto	u1750
u1751:
	goto	l30001953
u1750:
	
l30001952:	
	line	79
	movf	(___ftmul@f2)^080h,w
	addwf	(___ftmul@f3_as_product)^080h,f
	movf	(___ftmul@f2+1)^080h,w
	clrz
	skipnc
	incf	(___ftmul@f2+1)^080h,w
	skipnz
	goto	u1761
	addwf	(___ftmul@f3_as_product+1)^080h,f
u1761:
	movf	(___ftmul@f2+2)^080h,w
	clrz
	skipnc
	incf	(___ftmul@f2+2)^080h,w
	skipnz
	goto	u1762
	addwf	(___ftmul@f3_as_product+2)^080h,f
u1762:

	
l30001953:	
	line	80
	clrc
	rrf	(___ftmul@f1+2)^080h,f
	rrf	(___ftmul@f1+1)^080h,f
	rrf	(___ftmul@f1)^080h,f
	
l30001954:	
	line	81
	clrc
	rrf	(___ftmul@f3_as_product+2)^080h,f
	rrf	(___ftmul@f3_as_product+1)^080h,f
	rrf	(___ftmul@f3_as_product)^080h,f
	
l30001955:	
	line	82
	decfsz	(___ftmul@cntr)^080h,f
	goto	u1771
	goto	u1770
u1771:
	goto	l30001951
u1770:
	
l30001956:	
	line	83
	movf	(___ftmul@f3_as_product)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f3_as_product+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@f3_as_product+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack+2)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@exp)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	0+(?___ftpack)+03h
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftmul@sign)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	0+(?___ftpack)+04h
	fcall	___ftpack
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftmul+2)^080h
	
l127:	
	return
	opt stack 0
GLOBAL	__end_of___ftmul
	__end_of___ftmul:
; =============== function ___ftmul ends ============

psect	text365,local,class=CODE,delta=2
global __ptext365
__ptext365:
	line	84
	signat	___ftmul,8315
	global	___altoft

; *************** function ___altoft *****************
; Defined at:
;		line 43 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\altoft.c"
; Parameters:    Size  Location     Type
;  c               4    8[BANK0 ] long 
; Auto vars:     Size  Location     Type
;  sign            1    6[BANK0 ] unsigned char 
;  exp             1    7[BANK0 ] unsigned char 
; Return value:  Size  Location     Type
;                  3    8[BANK0 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 60/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       6       0       0       0
;      Temp:     0
;      Total:    6
; This function calls:
;		___ftpack
; This function is called by:
;		_main
;		_floor
; This function uses a non-reentrant model
; 
psect	text365
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\altoft.c"
	line	43
	global	__size_of___altoft
	__size_of___altoft	equ	__end_of___altoft-___altoft
	
___altoft:	
	opt stack 2
; Regs used in ___altoft: [wreg+status,2+status,0+pclath+cstack]
	line	45
	
l30001994:	
	clrf	(___altoft@sign)
	
l30001995:	
	line	46
	movlw	(08Eh)
	movwf	(___altoft@exp)
	
l30001996:	
	line	47
	btfss	(___altoft@c+3),7
	goto	u1891
	goto	u1890
u1891:
	goto	l30001999
u1890:
	
l30001997:	
	line	48
	comf	(___altoft@c),f
	comf	(___altoft@c+1),f
	comf	(___altoft@c+2),f
	comf	(___altoft@c+3),f
	incf	(___altoft@c),f
	skipnz
	incf	(___altoft@c+1),f
	skipnz
	incf	(___altoft@c+2),f
	skipnz
	incf	(___altoft@c+3),f
	line	49
	clrf	(___altoft@sign)
	incf	(___altoft@sign),f
	goto	l30001999
	
l30001998:	
	line	53
	clrc
	rrf	(___altoft@c+3),f
	rrf	(___altoft@c+2),f
	rrf	(___altoft@c+1),f
	rrf	(___altoft@c),f
	line	54
	incf	(___altoft@exp),f
	
l30001999:	
	line	52
	movlw	high highword(-16777216)
	andwf	(___altoft@c+3),w
	btfss	status,2
	goto	u1901
	goto	u1900
u1901:
	goto	l30001998
u1900:
	
l30002000:	
	line	56
	movf	(___altoft@c),w
	movwf	(?___ftpack)
	movf	(___altoft@c+1),w
	movwf	(?___ftpack+1)
	movf	(___altoft@c+2),w
	movwf	(?___ftpack+2)
	movf	(___altoft@exp),w
	movwf	0+(?___ftpack)+03h
	movf	(___altoft@sign),w
	movwf	0+(?___ftpack)+04h
	fcall	___ftpack
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___ftpack)),w
	movwf	(?___altoft)
	movf	(1+(?___ftpack)),w
	movwf	(?___altoft+1)
	movf	(2+(?___ftpack)),w
	movwf	(?___altoft+2)
	
l292:	
	return
	opt stack 0
GLOBAL	__end_of___altoft
	__end_of___altoft:
; =============== function ___altoft ends ============

psect	text366,local,class=CODE,delta=2
global __ptext366
__ptext366:
	line	57
	signat	___altoft,4219
	global	___ftadd

; *************** function ___ftadd *****************
; Defined at:
;		line 87 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftadd.c"
; Parameters:    Size  Location     Type
;  f1              3    9[BANK1 ] float 
;  f2              3   12[BANK1 ] float 
; Auto vars:     Size  Location     Type
;  exp1            1    8[BANK1 ] unsigned char 
;  exp2            1    7[BANK1 ] unsigned char 
;  sign            1    6[BANK1 ] unsigned char 
; Return value:  Size  Location     Type
;                  3    9[BANK1 ] float 
; Registers used:
;		wreg, status,2, status,0, pclath, cstack
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       3       9       0       0
;      Temp:     3
;      Total:   12
; This function calls:
;		___ftpack
; This function is called by:
;		_main
;		_atan2
;		_cos
;		_eval_poly
;		___ftsub
;		_floor
; This function uses a non-reentrant model
; 
psect	text366
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftadd.c"
	line	87
	global	__size_of___ftadd
	__size_of___ftadd	equ	__end_of___ftadd-___ftadd
	
___ftadd:	
	opt stack 2
; Regs used in ___ftadd: [wreg+status,2+status,0+pclath+cstack]
	line	90
	
l30001678:	
	movf	(___ftadd@f1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f1+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f1+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0+2)
	clrc
	rlf	(??___ftadd+0+1),w
	rlf	(??___ftadd+0+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(___ftadd@exp1)^080h
	line	91
	movf	(___ftadd@f2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f2+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f2+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0+2)
	clrc
	rlf	(??___ftadd+0+1),w
	rlf	(??___ftadd+0+2),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(___ftadd@exp2)^080h
	
l30001679:	
	line	92
	movf	(___ftadd@exp1)^080h,w
	skipz
	goto	u1120
	goto	l30001682
u1120:
	
l30001680:	
	movf	(___ftadd@exp2)^080h,w
	subwf	(___ftadd@exp1)^080h,w
	skipnc
	goto	u1131
	goto	u1130
u1131:
	goto	l30001684
u1130:
	
l30001681:	
	movf	(___ftadd@exp2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@exp1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	subwf	(??___ftadd+0+0),f
	movlw	(019h)
	subwf	0+(??___ftadd+0+0),w
	skipc
	goto	u1141
	goto	u1140
u1141:
	goto	l30001684
u1140:
	
l30001682:	
	line	93
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f2)^080h,w
	movwf	(?___ftadd)^080h
	movf	(___ftadd@f2+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(___ftadd@f2+2)^080h,w
	movwf	(?___ftadd+2)^080h
	goto	l91
	
l30001684:	
	line	94
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@exp2)^080h,w
	skipz
	goto	u1150
	goto	l30001687
u1150:
	
l30001685:	
	movf	(___ftadd@exp1)^080h,w
	subwf	(___ftadd@exp2)^080h,w
	skipnc
	goto	u1161
	goto	u1160
u1161:
	goto	l30001689
u1160:
	
l30001686:	
	movf	(___ftadd@exp1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(??___ftadd+0+0)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@exp2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	subwf	(??___ftadd+0+0),f
	movlw	(019h)
	subwf	0+(??___ftadd+0+0),w
	skipc
	goto	u1171
	goto	u1170
u1171:
	goto	l30001689
u1170:
	
l30001687:	
	line	95
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f1)^080h,w
	movwf	(?___ftadd)^080h
	movf	(___ftadd@f1+1)^080h,w
	movwf	(?___ftadd+1)^080h
	movf	(___ftadd@f1+2)^080h,w
	movwf	(?___ftadd+2)^080h
	goto	l91
	
l30001689:	
	line	96
	movlw	(06h)
	bsf	status, 5	;RP0=1, select bank1
	movwf	(___ftadd@sign)^080h
	
l30001690:	
	line	97
	btfss	(___ftadd@f1+2)^080h,(23)&7
	goto	u1181
	goto	u1180
u1181:
	goto	l94
u1180:
	
l30001691:	
	line	98
	bsf	(___ftadd@sign)^080h+(7/8),(7)&7
	
l94:	
	line	99
	btfss	(___ftadd@f2+2)^080h,(23)&7
	goto	u1191
	goto	u1190
u1191:
	goto	l95
u1190:
	
l30001692:	
	line	100
	bsf	(___ftadd@sign)^080h+(6/8),(6)&7
	
l95:	
	line	101
	bsf	(___ftadd@f1)^080h+(15/8),(15)&7
	
l30001693:	
	line	102
	movlw	0FFh
	andwf	(___ftadd@f1)^080h,f
	movlw	0FFh
	andwf	(___ftadd@f1+1)^080h,f
	movlw	0
	andwf	(___ftadd@f1+2)^080h,f
	
l30001694:	
	line	103
	bsf	(___ftadd@f2)^080h+(15/8),(15)&7
	line	104
	movlw	0FFh
	andwf	(___ftadd@f2)^080h,f
	movlw	0FFh
	andwf	(___ftadd@f2+1)^080h,f
	movlw	0
	andwf	(___ftadd@f2+2)^080h,f
	line	106
	movf	(___ftadd@exp2)^080h,w
	subwf	(___ftadd@exp1)^080h,w
	skipnc
	goto	u1201
	goto	u1200
u1201:
	goto	l30001700
u1200:
	
l30001695:	
	line	110
	clrc
	rlf	(___ftadd@f2)^080h,f
	rlf	(___ftadd@f2+1)^080h,f
	rlf	(___ftadd@f2+2)^080h,f
	line	111
	decf	(___ftadd@exp2)^080h,f
	
l30001696:	
	line	112
	movf	(___ftadd@exp2)^080h,w
	xorwf	(___ftadd@exp1)^080h,w
	skipnz
	goto	u1211
	goto	u1210
u1211:
	goto	l30001699
u1210:
	
l30001697:	
	decf	(___ftadd@sign)^080h,f
	movf	((___ftadd@sign)^080h)&07fh,w
	andlw	07h
	btfss	status,2
	goto	u1221
	goto	u1220
u1221:
	goto	l30001695
u1220:
	goto	l30001699
	
l30001698:	
	line	114
	clrc
	rrf	(___ftadd@f1+2)^080h,f
	rrf	(___ftadd@f1+1)^080h,f
	rrf	(___ftadd@f1)^080h,f
	line	115
	incf	(___ftadd@exp1)^080h,f
	
l30001699:	
	line	113
	movf	(___ftadd@exp1)^080h,w
	xorwf	(___ftadd@exp2)^080h,w
	skipz
	goto	u1231
	goto	u1230
u1231:
	goto	l30001698
u1230:
	goto	l103
	
l30001700:	
	line	117
	movf	(___ftadd@exp1)^080h,w
	subwf	(___ftadd@exp2)^080h,w
	skipnc
	goto	u1241
	goto	u1240
u1241:
	goto	l103
u1240:
	
l30001701:	
	line	121
	clrc
	rlf	(___ftadd@f1)^080h,f
	rlf	(___ftadd@f1+1)^080h,f
	rlf	(___ftadd@f1+2)^080h,f
	line	122
	decf	(___ftadd@exp1)^080h,f
	
l30001702:	
	line	123
	movf	(___ftadd@exp2)^080h,w
	xorwf	(___ftadd@exp1)^080h,w
	skipnz
	goto	u1251
	goto	u1250
u1251:
	goto	l30001705
u1250:
	
l30001703:	
	decf	(___ftadd@sign)^080h,f
	movf	((___ftadd@sign)^080h)&07fh,w
	andlw	07h
	btfss	status,2
	goto	u1261
	goto	u1260
u1261:
	goto	l30001701
u1260:
	goto	l30001705
	
l30001704:	
	line	125
	clrc
	rrf	(___ftadd@f2+2)^080h,f
	rrf	(___ftadd@f2+1)^080h,f
	rrf	(___ftadd@f2)^080h,f
	line	126
	incf	(___ftadd@exp2)^080h,f
	
l30001705:	
	line	124
	movf	(___ftadd@exp1)^080h,w
	xorwf	(___ftadd@exp2)^080h,w
	skipz
	goto	u1271
	goto	u1270
u1271:
	goto	l30001704
u1270:
	
l103:	
	line	129
	btfss	(___ftadd@sign)^080h,(7)&7
	goto	u1281
	goto	u1280
u1281:
	goto	l30001708
u1280:
	
l30001706:	
	line	131
	movlw	0FFh
	xorwf	(___ftadd@f1)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f1+1)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f1+2)^080h,f
	
l30001707:	
	line	132
	incf	(___ftadd@f1)^080h,f
	skipnz
	incf	(___ftadd@f1+1)^080h,f
	skipnz
	incf	(___ftadd@f1+2)^080h,f
	
l30001708:	
	line	134
	btfss	(___ftadd@sign)^080h,(6)&7
	goto	u1291
	goto	u1290
u1291:
	goto	l30001711
u1290:
	
l30001709:	
	line	136
	movlw	0FFh
	xorwf	(___ftadd@f2)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f2+1)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f2+2)^080h,f
	
l30001710:	
	line	137
	incf	(___ftadd@f2)^080h,f
	skipnz
	incf	(___ftadd@f2+1)^080h,f
	skipnz
	incf	(___ftadd@f2+2)^080h,f
	
l30001711:	
	line	139
	clrf	(___ftadd@sign)^080h
	
l30001712:	
	line	140
	movf	(___ftadd@f1)^080h,w
	addwf	(___ftadd@f2)^080h,f
	movf	(___ftadd@f1+1)^080h,w
	clrz
	skipnc
	incf	(___ftadd@f1+1)^080h,w
	skipnz
	goto	u1301
	addwf	(___ftadd@f2+1)^080h,f
u1301:
	movf	(___ftadd@f1+2)^080h,w
	clrz
	skipnc
	incf	(___ftadd@f1+2)^080h,w
	skipnz
	goto	u1302
	addwf	(___ftadd@f2+2)^080h,f
u1302:

	
l30001713:	
	line	141
	btfss	(___ftadd@f2+2)^080h,(23)&7
	goto	u1311
	goto	u1310
u1311:
	goto	l30001717
u1310:
	
l30001714:	
	line	142
	movlw	0FFh
	xorwf	(___ftadd@f2)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f2+1)^080h,f
	movlw	0FFh
	xorwf	(___ftadd@f2+2)^080h,f
	
l30001715:	
	line	143
	incf	(___ftadd@f2)^080h,f
	skipnz
	incf	(___ftadd@f2+1)^080h,f
	skipnz
	incf	(___ftadd@f2+2)^080h,f
	
l30001716:	
	line	144
	clrf	(___ftadd@sign)^080h
	incf	(___ftadd@sign)^080h,f
	
l30001717:	
	line	146
	movf	(___ftadd@f2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f2+1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack+1)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@f2+2)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	(?___ftpack+2)
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@exp1)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	0+(?___ftpack)+03h
	bsf	status, 5	;RP0=1, select bank1
	movf	(___ftadd@sign)^080h,w
	bcf	status, 5	;RP0=0, select bank0
	movwf	0+(?___ftpack)+04h
	fcall	___ftpack
	bcf	status, 7	;select IRP bank0
	movf	(0+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(1+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+1)^080h
	bcf	status, 5	;RP0=0, select bank0
	movf	(2+(?___ftpack)),w
	bsf	status, 5	;RP0=1, select bank1
	movwf	(?___ftadd+2)^080h
	
l91:	
	return
	opt stack 0
GLOBAL	__end_of___ftadd
	__end_of___ftadd:
; =============== function ___ftadd ends ============

psect	text367,local,class=CODE,delta=2
global __ptext367
__ptext367:
	line	148
	signat	___ftadd,8315
	global	___ftge

; *************** function ___ftge *****************
; Defined at:
;		line 5 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftge.c"
; Parameters:    Size  Location     Type
;  ff1             3    0[COMMON] float 
;  ff2             3    3[COMMON] float 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;		None               void
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 100/40
;		On exit  : 100/40
;		Unchanged: FFEFF/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         6       0       0       0       0
;      Temp:     0
;      Total:    6
; This function calls:
;		Nothing
; This function is called by:
;		_main
;		_asin
;		_atan2
;		_atan
;		_cos
;		_fabs
;		_sin
;		_sqrt
;		_floor
; This function uses a non-reentrant model
; 
psect	text367
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftge.c"
	line	5
	global	__size_of___ftge
	__size_of___ftge	equ	__end_of___ftge-___ftge
	
___ftge:	
	opt stack 2
; Regs used in ___ftge: [wreg+status,2+status,0]
	line	6
	
l30002029:	
	btfss	(___ftge@ff1+2),(23)&7
	goto	u2001
	goto	u2000
u2001:
	goto	l30002031
u2000:
	
l30002030:	
	line	7
	movf	(___ftge@ff1),w
	sublw	low(0800000h)
	movwf	(___ftge@ff1)
	movf	(___ftge@ff1+1),w
	skipc
	incfsz	(___ftge@ff1+1),w
	sublw	high(0800000h)
	movwf	1+(___ftge@ff1)
	movf	(___ftge@ff1+2),w
	skipc
	incfsz	(___ftge@ff1+2),w
	sublw	low highword(0800000h)
	movwf	2+(___ftge@ff1)
	
l30002031:	
	line	8
	btfss	(___ftge@ff2+2),(23)&7
	goto	u2011
	goto	u2010
u2011:
	goto	l30002033
u2010:
	
l30002032:	
	line	9
	movf	(___ftge@ff2),w
	sublw	low(0800000h)
	movwf	(___ftge@ff2)
	movf	(___ftge@ff2+1),w
	skipc
	incfsz	(___ftge@ff2+1),w
	sublw	high(0800000h)
	movwf	1+(___ftge@ff2)
	movf	(___ftge@ff2+2),w
	skipc
	incfsz	(___ftge@ff2+2),w
	sublw	low highword(0800000h)
	movwf	2+(___ftge@ff2)
	
l30002033:	
	line	10
	movlw	080h
	xorwf	(___ftge@ff1+2),f
	
l30002034:	
	line	11
	movlw	080h
	xorwf	(___ftge@ff2+2),f
	line	12
	movf	(___ftge@ff2+2),w
	subwf	(___ftge@ff1+2),w
	skipz
	goto	u2025
	movf	(___ftge@ff2+1),w
	subwf	(___ftge@ff1+1),w
	skipz
	goto	u2025
	movf	(___ftge@ff2),w
	subwf	(___ftge@ff1),w
u2025:
	skipnc
	goto	u2037
	goto	u2038
u2037:
	bsf	status,0
	goto	u2039
u2038:
	bcf	status,0
u2039:
	
l242:	
	return
	opt stack 0
GLOBAL	__end_of___ftge
	__end_of___ftge:
; =============== function ___ftge ends ============

psect	text368,local,class=CODE,delta=2
global __ptext368
__ptext368:
	line	13
	signat	___ftge,8312
	global	___fttol

; *************** function ___fttol *****************
; Defined at:
;		line 45 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\fttol.c"
; Parameters:    Size  Location     Type
;  f1              3    3[COMMON] float 
; Auto vars:     Size  Location     Type
;  lval            4    1[BANK0 ] unsigned long 
;  exp1            1    5[BANK0 ] unsigned char 
;  sign1           1    0[BANK0 ] unsigned char 
; Return value:  Size  Location     Type
;                  4    3[COMMON] long 
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 160/0
;		On exit  : 60/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         7       6       0       0       0
;      Temp:     3
;      Total:   13
; This function calls:
;		Nothing
; This function is called by:
;		_floor
; This function uses a non-reentrant model
; 
psect	text368
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\fttol.c"
	line	45
	global	__size_of___fttol
	__size_of___fttol	equ	__end_of___fttol-___fttol
	
___fttol:	
	opt stack 2
; Regs used in ___fttol: [wreg+status,2+status,0]
	line	49
	
l30002002:	
	movf	(___fttol@f1),w
	movwf	(??___fttol+0+0)
	movf	(___fttol@f1+1),w
	movwf	(??___fttol+0+0+1)
	movf	(___fttol@f1+2),w
	movwf	(??___fttol+0+0+2)
	clrc
	rlf	(??___fttol+0+1),w
	rlf	(??___fttol+0+2),w
	movwf	(___fttol@exp1)
	movf	((___fttol@exp1))&07fh,f
	skipz
	goto	u1911
	goto	u1910
u1911:
	goto	l30002004
u1910:
	
l30002003:	
	line	50
	clrf	(?___fttol)
	clrf	(?___fttol+1)
	clrf	(?___fttol+2)
	clrf	(?___fttol+3)
	goto	l180
	
l30002004:	
	line	51
	movf	(___fttol@f1),w
	movwf	(??___fttol+0+0)
	movf	(___fttol@f1+1),w
	movwf	(??___fttol+0+0+1)
	movf	(___fttol@f1+2),w
	movwf	(??___fttol+0+0+2)
	movlw	017h
u1925:
	clrc
	rrf	(??___fttol+0+2),f
	rrf	(??___fttol+0+1),f
	rrf	(??___fttol+0+0),f
u1920:
	addlw	-1
	skipz
	goto	u1925
	movf	0+(??___fttol+0+0),w
	movwf	(___fttol@sign1)
	
l30002005:	
	line	52
	bsf	(___fttol@f1)+(15/8),(15)&7
	
l30002006:	
	line	53
	movlw	0FFh
	andwf	(___fttol@f1),f
	movlw	0FFh
	andwf	(___fttol@f1+1),f
	movlw	0
	andwf	(___fttol@f1+2),f
	
l30002007:	
	line	54
	movf	(___fttol@f1),w
	movwf	(___fttol@lval)
	movf	(___fttol@f1+1),w
	movwf	((___fttol@lval))+1
	
	movf	(___fttol@f1+2),w
	movwf	((___fttol@lval))+2
	
	clrf	3+(___fttol@lval)
	
l30002008:	
	line	55
	movlw	low(08Eh)
	subwf	(___fttol@exp1),f
	
l30002009:	
	line	56
	btfss	(___fttol@exp1),7
	goto	u1931
	goto	u1930
u1931:
	goto	l30002014
u1930:
	
l30002010:	
	line	57
	movf	(___fttol@exp1),w
	xorlw	80h
	addlw	-((-15)^80h)
	skipnc
	goto	u1941
	goto	u1940
u1941:
	goto	l30002012
u1940:
	goto	l30002003
	
l30002012:	
	line	60
	clrc
	rrf	(___fttol@lval+3),f
	rrf	(___fttol@lval+2),f
	rrf	(___fttol@lval+1),f
	rrf	(___fttol@lval),f
	
l30002013:	
	line	61
	incfsz	(___fttol@exp1),f
	goto	u1951
	goto	u1950
u1951:
	goto	l30002012
u1950:
	goto	l30002017
	
l30002014:	
	line	63
	movlw	(018h)
	subwf	(___fttol@exp1),w
	skipc
	goto	u1961
	goto	u1960
u1961:
	goto	l189
u1960:
	goto	l30002003
	
l30002016:	
	line	66
	clrc
	rlf	(___fttol@lval),f
	rlf	(___fttol@lval+1),f
	rlf	(___fttol@lval+2),f
	rlf	(___fttol@lval+3),f
	line	67
	decf	(___fttol@exp1),f
	
l189:	
	line	65
	movf	(___fttol@exp1),f
	skipz
	goto	u1971
	goto	u1970
u1971:
	goto	l30002016
u1970:
	
l30002017:	
	line	70
	movf	(___fttol@sign1),w
	skipz
	goto	u1980
	goto	l30002019
u1980:
	
l30002018:	
	line	71
	comf	(___fttol@lval),f
	comf	(___fttol@lval+1),f
	comf	(___fttol@lval+2),f
	comf	(___fttol@lval+3),f
	incf	(___fttol@lval),f
	skipnz
	incf	(___fttol@lval+1),f
	skipnz
	incf	(___fttol@lval+2),f
	skipnz
	incf	(___fttol@lval+3),f
	
l30002019:	
	line	72
	movf	(___fttol@lval+3),w
	movwf	(?___fttol+3)
	movf	(___fttol@lval+2),w
	movwf	(?___fttol+2)
	movf	(___fttol@lval+1),w
	movwf	(?___fttol+1)
	movf	(___fttol@lval),w
	movwf	(?___fttol)

	
l180:	
	return
	opt stack 0
GLOBAL	__end_of___fttol
	__end_of___fttol:
; =============== function ___fttol ends ============

psect	text369,local,class=CODE,delta=2
global __ptext369
__ptext369:
	line	73
	signat	___fttol,4220
	global	_frexp

; *************** function _frexp *****************
; Defined at:
;		line 255 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\frexp.c"
; Parameters:    Size  Location     Type
;  value           3    0[BANK0 ] long 
;  eptr            1    3[BANK0 ] PTR int 
;		 -> floor@expon(2), 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3    0[BANK0 ] PTR int 
; Registers used:
;		wreg, fsr0l, fsr0h, status,2, status,0
; Tracked objects:
;		On entry : 160/0
;		On exit  : 160/0
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         4       4       0       0       0
;      Temp:     4
;      Total:    8
; This function calls:
;		Nothing
; This function is called by:
;		_floor
; This function uses a non-reentrant model
; 
psect	text369
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\frexp.c"
	line	255
	global	__size_of_frexp
	__size_of_frexp	equ	__end_of_frexp-_frexp
	
_frexp:	
	opt stack 2
; Regs used in _frexp: [wreg-fsr0h+status,2+status,0]
	line	256
	
l30002021:	
	movf	(frexp@value+2),w
	iorwf	(frexp@value+1),w
	iorwf	(frexp@value),w
	skipz
	goto	u1991
	goto	u1990
u1991:
	goto	l30002024
u1990:
	
l30002022:	
	line	257
	movf	(frexp@eptr),w
	movwf	fsr0
	clrf	indf
	incf	fsr0,f
	clrf	indf
	goto	l390
	
l30002024:	
	line	261
	movf	0+(frexp@value)+02h,w
	andlw	(1<<7)-1
	movwf	(??_frexp+0+0)
	clrf	(??_frexp+0+0+1)
	clrc
	rlf	0+(??_frexp+0+0),w
	movwf	(??_frexp+2+0)
	rlf	1+(??_frexp+0+0),w
	movwf	1+(??_frexp+2+0)
	movf	(frexp@eptr),w
	movwf	fsr0
	movf	0+(??_frexp+2+0),w
	movwf	indf
	incf	fsr0,f
	movf	1+(??_frexp+2+0),w
	movwf	indf
	line	262
	rlf	0+(frexp@value)+01h,w
	rlf	0+(frexp@value)+01h,w
	andlw	1
	movwf	(??_frexp+0+0)
	clrf	(??_frexp+0+0+1)
	movf	(frexp@eptr),w
	movwf	fsr0
	movf	0+(??_frexp+0+0),w
	iorwf	indf,f
	incf	fsr0,f
	movf	1+(??_frexp+0+0),w
	iorwf	indf,f
	
l30002025:	
	line	263
	movf	(frexp@eptr),w
	movwf	fsr0
	movlw	low(-126)
	addwf	indf,f
	incfsz	fsr0,f
	movf	indf,w
	skipnc
	incf	indf,w
	movwf	(??_frexp+0+0)
	movlw	high(-126)
	addwf	(??_frexp+0+0),w
	movwf	indf
	decf	fsr0,f
	
l30002026:	
	line	268
	movf	0+(frexp@value)+02h,w
	andlw	not (((1<<7)-1)<<0)
	iorlw	(03Fh & ((1<<7)-1))<<0
	movwf	0+(frexp@value)+02h
	
l30002027:	
	line	269
	bcf	0+(frexp@value)+01h,7
	
l390:	
	return
	opt stack 0
GLOBAL	__end_of_frexp
	__end_of_frexp:
; =============== function _frexp ends ============

psect	text370,local,class=CODE,delta=2
global __ptext370
__ptext370:
	line	274
	signat	_frexp,8315
	global	___ftneg

; *************** function ___ftneg *****************
; Defined at:
;		line 16 in file "C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftneg.c"
; Parameters:    Size  Location     Type
;  f1              3   33[BANK1 ] float 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3   33[BANK1 ] float 
; Registers used:
;		wreg
; Tracked objects:
;		On entry : 160/20
;		On exit  : 160/20
;		Unchanged: FFE9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         0       0       3       0       0
;      Temp:     0
;      Total:    3
; This function calls:
; This function is called by:
;		_main
;		_asin
;		_atan2
;		_atan
;		_fabs
;		_sin
; This function uses a non-reentrant model
; 
psect	text370
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\ftneg.c"
	line	16
	global	__size_of___ftneg
	__size_of___ftneg	equ	__end_of___ftneg-___ftneg
	
___ftneg:	
	opt stack 2
; Regs used in ___ftneg: [wreg]
	line	17
	
l30002041:	
	movf	(___ftneg@f1+2)^080h,w
	iorwf	(___ftneg@f1+1)^080h,w
	iorwf	(___ftneg@f1)^080h,w
	skipnz
	goto	u2051
	goto	u2050
u2051:
	goto	l220
u2050:
	
l30002042:	
	line	18
	movlw	080h
	xorwf	(___ftneg@f1+2)^080h,f
	
l220:	
	line	19
	movf	(___ftneg@f1)^080h,w
	movwf	(?___ftneg)^080h
	movf	(___ftneg@f1+1)^080h,w
	movwf	(?___ftneg+1)^080h
	movf	(___ftneg@f1+2)^080h,w
	movwf	(?___ftneg+2)^080h
	
l219:	
	return
	opt stack 0
GLOBAL	__end_of___ftneg
	__end_of___ftneg:
; =============== function ___ftneg ends ============

psect	text371,local,class=CODE,delta=2
global __ptext371
__ptext371:
	line	20
	signat	___ftneg,4219
	global	___ftpack

; *************** function ___ftpack *****************
; Defined at:
;		line 63 in file "float.c"
; Parameters:    Size  Location     Type
;  arg             3    0[BANK0 ] unsigned um
;  exp             1    3[BANK0 ] unsigned char 
;  sign            1    4[BANK0 ] unsigned char 
; Auto vars:     Size  Location     Type
;		None
; Return value:  Size  Location     Type
;                  3    0[BANK0 ] float 
; Registers used:
;		wreg, status,2, status,0
; Tracked objects:
;		On entry : 60/0
;		On exit  : 60/0
;		Unchanged: FFF9F/0
; Data sizes:     COMMON   BANK0   BANK1   BANK3   BANK2
;      Locals:         3       5       0       0       0
;      Temp:     3
;      Total:    8
; This function calls:
;		Nothing
; This function is called by:
;		___ftadd
;		___ftdiv
;		___ftmul
;		___altoft
; This function uses a non-reentrant model
; 
psect	text371
	file	"C:\Program Files\HI-TECH Software\PICC\9.70\sources\float.c"
	line	63
	global	__size_of___ftpack
	__size_of___ftpack	equ	__end_of___ftpack-___ftpack
	
___ftpack:	
	opt stack 1
; Regs used in ___ftpack: [wreg+status,2+status,0]
	line	64
	
l30001958:	
	movf	(___ftpack@exp),w
	skipz
	goto	u1780
	goto	l30001960
u1780:
	
l30001959:	
	movf	(___ftpack@arg+2),w
	iorwf	(___ftpack@arg+1),w
	iorwf	(___ftpack@arg),w
	skipz
	goto	u1791
	goto	u1790
u1791:
	goto	l30001963
u1790:
	
l30001960:	
	line	65
	clrf	(?___ftpack)
	clrf	(?___ftpack+1)
	clrf	(?___ftpack+2)
	goto	l400
	
l30001962:	
	line	67
	incf	(___ftpack@exp),f
	line	68
	clrc
	rrf	(___ftpack@arg+2),f
	rrf	(___ftpack@arg+1),f
	rrf	(___ftpack@arg),f
	
l30001963:	
	line	66
	movlw	low highword(0FE0000h)
	andwf	(___ftpack@arg+2),w
	btfss	status,2
	goto	u1801
	goto	u1800
u1801:
	goto	l30001962
u1800:
	goto	l30001965
	
l30001964:	
	line	71
	incf	(___ftpack@exp),f
	line	72
	incf	(___ftpack@arg),f
	skipnz
	incf	(___ftpack@arg+1),f
	skipnz
	incf	(___ftpack@arg+2),f
	line	73
	clrc
	rrf	(___ftpack@arg+2),f
	rrf	(___ftpack@arg+1),f
	rrf	(___ftpack@arg),f
	
l30001965:	
	line	70
	movlw	low highword(0FF0000h)
	andwf	(___ftpack@arg+2),w
	btfss	status,2
	goto	u1811
	goto	u1810
u1811:
	goto	l30001964
u1810:
	goto	l30001967
	
l30001966:	
	line	76
	decf	(___ftpack@exp),f
	line	77
	clrc
	rlf	(___ftpack@arg),f
	rlf	(___ftpack@arg+1),f
	rlf	(___ftpack@arg+2),f
	
l30001967:	
	line	75
	btfss	(___ftpack@arg+1),(15)&7
	goto	u1821
	goto	u1820
u1821:
	goto	l30001966
u1820:
	
l410:	
	line	79
	btfsc	(___ftpack@exp),(0)&7
	goto	u1831
	goto	u1830
u1831:
	goto	l411
u1830:
	
l30001968:	
	line	80
	bcf	(___ftpack@arg)+(15/8),(15)&7
	
l411:	
	line	81
	clrc
	rrf	(___ftpack@exp),f
	
l30001969:	
	line	82
	movf	(___ftpack@exp),w
	movwf	(??___ftpack+0+0+2)
	clrf	(??___ftpack+0+0+1)
	clrf	(??___ftpack+0+0+0)
	movf	0+(??___ftpack+0+0),w
	iorwf	(___ftpack@arg),f
	movf	1+(??___ftpack+0+0),w
	iorwf	(___ftpack@arg+1),f
	movf	2+(??___ftpack+0+0),w
	iorwf	(___ftpack@arg+2),f
	
l30001970:	
	line	83
	movf	(___ftpack@sign),w
	skipz
	goto	u1840
	goto	l412
u1840:
	
l30001971:	
	line	84
	bsf	(___ftpack@arg)+(23/8),(23)&7
	
l412:	
	line	85
	
l400:	
	return
	opt stack 0
GLOBAL	__end_of___ftpack
	__end_of___ftpack:
; =============== function ___ftpack ends ============

psect	text372,local,class=CODE,delta=2
global __ptext372
__ptext372:
	line	86
	signat	___ftpack,12411
	global	btemp
	btemp set 07Eh

	DABS	1,126,2	;btemp
	end
