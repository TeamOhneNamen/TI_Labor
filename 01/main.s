;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Thorben Schomacker
;* Author             : Ferdinand Trendelenburg	
;* Version            : V1.0
;* Date               : 18.04.2017
;* Description        : This is a simple main.
;					  : The output is send to UART 1. Open Serial Window when 
;					  : when debugging. Select UART #1 in Serial Window selection.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************

	EXTERN Init_TI_Board		; Initialize the serial line
	EXTERN ADC3_CH7_DMA_Config  ; Initialize the ADC
	;EXTERN	initHW				; Init Timer
	EXTERN	puts				; C output function
	EXTERN	TFT_puts			; TFT output function
	EXTERN  TFT_cls				; TFT clear function
	EXTERN  TFT_gotoxy      	; TFT goto x y function  
	EXTERN  Delay				; Delay (ms) function
	EXTERN GPIO_G_SET			; Set output-LEDs
	EXTERN GPIO_G_CLR			; Clear output-LEDs
	EXTERN GPIO_G_PIN			; Output-LEDs status
	EXTERN GPIO_E_PIN			; Button status
	EXTERN ADC3_DR				; ADC Value (ADC3_CH7_DMA_Config has to be called before)

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 4
	GLOBAL MyData, MeinNumFeld, MeinHaWoFeld, MeinTextFeld, MeinByteFeld, MeinBlock
		
MeinNumFeld 	DCD 	0x33, 2_01111110, -57, 66, 0x70000000, 0x80000000
MeinHaWoFeld 	DCW 	0x1234, 0x5678, 0x9abc, 0xdef0
MeinTextFeld 	DCB 		"ABab0123",0
MeinByteFeld 	DCB 0xef, 0xdc, 0xba, 0x98

						ALIGN 4 ; empfehlenswert für hohe Performance, wenn in MeinBlock
MeinBlock 		SPACE 0x20
	
text	DCB	"Hallo TI-Labor.\n\r",0

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC

		BL	Init_TI_Board	; Initialize the serial line to TTY
							; for compatability to out TI-C-Board
		;BL	initHW			; Timer init
		
		LDR	r0,=text
		BL	puts			; call C output method
		
		LDR r0,=text
		BL	TFT_puts		; call TFT output method
		
		
forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END