.global main
.equ Buffsize, 256
.text
main:
		bl	openInFile

exit:
		mov	r0,#0
		mov	r7,#1
		svc	#0



.data
strBuffer:	.ds Buffsize
head:		.word 0
next:		.word 0
curr:		.word 0
handle:		.skip 4
fileInName:	.asciz "input.txt"
fileOutName:	.asciz "output.txt"
menuList:	.asciz "1)View Strings \n2)Add Strings \n3)Delete Strings \n"
		.asciz "4)Edit Strings \n5)String Search \n6)Save file \n7)Quit \n"
inputError:	.asciz "\nIncorrect input \n"
fileError:	.asciz "\nInfile error\n"
.text


openInFile:
		ldr	r0,=fileInName
		mov	r1,#00
		ldr	r2,=0101
		mov	r7,#5
		svc	0
@		bcs	InFileError
		b	makeNewList
InFileError:
		ldr	r1,=fileError
		bl	v_ascz
		bx	lr
openOutfile:

		ldr	r0,=fileOutName
		mov	r1,#00
		ldr	r2,=0644
		mov	r7,#5
		svc	0
makeNewList:
		ldr	r1,=handle
		mov	r2,#1024
		mov	r5,r0
		mov	r7,#3
		svc	0
		mov	r0,r5
		b	makeNewList

		bx	lr


viewAll:


addString:


deleteString:


editString:


stringSearch:

saveFile:

gtfo:


@	Subroutine v_ascz will display a string of characters
@		R1: Points to beginning of ASCII string
@		    End of string will be marked by a null byte
@		LR: Contains the return address
@		All register contents will be preserved

v_ascz: push	{R0-R8,LR}	@ Save contents of registers R0 through R8, LR
	sub	R2,R1,#1	@ R2 will be index while searching string for null.
hunt4z:	ldrb	R0,[R2,#1]!	@ Load next character from string (and increment R2 by 1)
	cmp	R0,#0		@ Set Z status bit if null found
	bne	hunt4z		@ If not null, go examine next character.
	sub	R2,R1		@ Get number of bytes in message (not counting null)
	mov	R0,#1		@ Code for stdout (standard output, i.e., monitor display)
	mov	R7,#4		@ Linux service command code to write string.
	svcne	0		@ Issue command to display string on stdout

	pop	{R0-R8,LR}	@ Restore saved register contents
	bx	LR		@ Return to the calling program
.end
