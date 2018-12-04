.data 
@ Structs are in the format [next][string]
head:	.word	0
curr:	.word	0
next:	.word	0
a:	.asciz	"a"
b:	.asciz	"b"
c:	.asciz	"c"
d:	.asciz	"d"

.text
.global	main
main:
	ldr	r1,=head	@ create reference to head 
	bl	createNode

	ldr	r1,=curr	@ create reference to curr
	bl	createNode

	ldr	r2,=b
	bl	setString
	
	ldr	r1,=head
	ldr	r2,=curr
	
	bl	linkHead

	ldr	r1,[r1,#4] @ used by the debugger to ensure link when stepping


	@ r3 is functionally prev
	ldr	r3,=curr	
	
	ldr	r1,=next
	bl	createNode
	ldr	r2,=c
	bl	setString

	@ trying to make r3 prev
	ldr	r1,[r3]
	ldr	r2,=next

	bl	link


	@ r3 is functionally prev
	ldr	r3,=curr	
	
	ldr	r1,=next
	bl	createNode
	ldr	r2,=d
	bl	setString

	@ trying to make r3 prev
	ldr	r1,[r3]
	ldr	r2,=next

	bl	link


	mov	r0,#0
	mov	r7,#1
	svc	0

loopToAddStrings:
	push	{lr}


	
	pop	{lr}
	bx	lr
	
@ links current = r1
@ to 	new 	= r2
@ then 	r1	= r2
link:
	ldr	r2,[r2]		@ get the malloc address
	str	r2,[r1,#4]	@ store the address of new into curr.next
	ldr	r1,[r1,#4]	@ put current.next into r1
	
	ldr	r2,=curr	@ load a reference to curr
	ldr	r1,=next	@ load a reference to curr.next into curr

	ldr	r1,[r1]
	str	r1,[r2]		@ current = next

	bx	lr

@ links current = r1
@ to 	new 	= r2
linkHead:
	ldr	r1,[r1]
	ldr	r2,[r2]
	str	r2,[r1,#4]	@ store the address of new into head
	bx	lr
@ r1 = node 
@ r2 = string
setString:
	ldr	r2,[r2]		@ Dereference the string
	strb	r2,[r1]		@ Store the string itno the first byte of r1
				@ But this will be an issue because it doesn't store the string
				@ It only stores the character
				@ W hich is not what we want it to do
	bx	lr

@ Node to allocate to is r1
createNode:
	push	{lr}
	@ Allocate space into r1
	mov	r0,#8		@ amount of space to allocate
	push	{r1-r3}
	bl	malloc		@ create the allocated space
	pop	{r1-r3}

	str	r0,[r1]		@ store 8 bytes into head
	ldr	r1,[r1]		@ W ith this we can write into the space allocated by malloc
	pop	{lr}
	bx	lr
