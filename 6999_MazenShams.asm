; 8086 subroutine to encrypt/decrypt lower case characters using xlat

name "crypt"

org 100h


jmp start

; string has '$' in the end:    
newline db 13,10,'$' 
greetline db "-------------------------------------------------------------------------------$"  
welcome db "ENCRYPTER AND DECRYPTER BY MAZEN SHAMS ID 6999$"
msg1 db "Enter text to be encrypted:$"  
msg2 db "The text after encryption :$"
msg4 db "The text after decryption :$" 
msg5 db "Decrypting text. $"
msg6 db "."

string2 db '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$'   
string3 db '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$'
string1 db 78,80 DUP("$")


;                       

table1 db 97 dup (' '), '012345678901234567890123456'

table2 db 97 dup (' '), 'abcdefghijklmnopqrstuvwxyz'


start:
    ;greeting 
mov dx, offset greetline
mov ah, 9
int 21h
mov dx, offset newline
mov ah, 9
int 21h
mov dx, offset welcome
mov ah, 9
int 21h 
mov dx, offset newline
mov ah, 9
int 21h
mov dx, offset greetline
mov ah, 9
int 21h
mov dx, offset newline
mov ah, 9
int 21h
    ;greeting

mov dx, offset msg1
mov ah, 9
int 21h  

mov dx, offset string1
mov ah, 0ah
int 21h 

; encrypt:
lea bx, table1
lea si, string1+2 
lea di, string2
call EFUNC 


; show result encryption: 
mov dx, offset newline
mov ah, 9
int 21h
mov dx, offset msg2
mov ah, 9
int 21h
lea dx, string2
; output of a string at ds:dx
mov ah, 09
int 21h 

;decrypt
mov dx, offset newline
mov ah, 9
int 21h

mov dx, offset msg5
mov ah, 9
int 21h

mov dx, offset msg6 
mov ah, 9
int 21h

lea bx, table2
lea si, string2
lea di, string3
call DFUNC

; show result decryption: 
mov dx, offset newline
mov ah, 9
int 21h
mov dx, offset msg4
mov ah, 9
int 21h
lea dx, string3
; output of a string at ds:dx
mov ah, 09
int 21h





ret   ; exit to operating system.

; subroutine to encrypt
; parameters: 
;             si - address of string to encrypt
;             bx - table to use.
EFUNC:
enext_char: 
    mov al, [si]
	cmp al, '$'      ; end of string?
	je Eend_of_string   
	
	cmp al, ' '
	je  ePrintSpace  
	
	cmp al, 'j'
	jb  EncryptAtoI 
	je  EncryptJtoS
	cmp al, 't' 
	jb  EncryptJtoS 
	je  EncryptTtoZ
	cmp al, 'z'
	jb  EncryptTtoZ 
	je  EncryptTtoZ 
	
DFUNC:
dnext_char: 
    mov al, [si]
	cmp al, '$'      ; end of string?
	je Dend_of_string
	                                  
	                 
	mov al, [si]  
	
	cmp al, ' '
	je  dPrintSpace
	   
	
	cmp al, '2'
	je  DecryptTtoZ
	
	cmp al, '1'
	je  DecryptJtoS 
	
	cmp al, '0'
	je  DecryptAtoI

	   
	   
	   
	   
	
	  ;ENCRYPT SUBS
	
ePrintSpace:
    mov [di], ' '   ; print space
    inc di
    jmp eskip	

EncryptAtoI:
	                ; xlat algorithm: al = ds:[bx + unsigned al]           
	mov [di], '0'
	inc di  
	mov al, [si] 
	inc al 
	xlatb  
	mov [di], al
	inc di
	
    jmp eskip   
    
EncryptJtoS:
	                ; xlat algorithm: al = ds:[bx + unsigned al]           
	mov [di], '1'
	inc di  
	mov al, [si] 
	inc al 
	xlatb  
	mov [di], al
	inc di
	
    jmp eskip 

EncryptTtoZ:
	                ; xlat algorithm: al = ds:[bx + unsigned al]           
	mov [di], '2'
	inc di  
	mov al, [si] 
	inc al 
	xlatb  
	mov [di], al
	inc di
	
    jmp eskip 
    
eskip:
	inc si	        ;NEXT CHAR
	jmp enext_char      
                    
Eend_of_string:
    dec di
    dec di
    mov [di],'$'    ;END
    ret 
       
       
       
       
       

        ;DECRYPT SUBS

dPrintSpace:
    mov [di], ' '   ; print space
    inc di
    jmp dskip    

DecryptAtoI:
    
	inc si  
	mov al,[si]
	add al,48    
	xlat  
	mov [di], al
	inc di
	    
    jmp dskip 

DecryptJtoS:
    
	inc si  
	mov al,[si]
	add al,58  
	xlat  
	mov [di], al
	inc di
	
    jmp dskip 
    
DecryptTtoZ:
    
	inc si  
	mov al,[si]
	add al,68    
	xlat  
	mov [di], al
	inc di
	
    jmp dskip    

dskip:
	inc si	        ;NEXT CHAR
	jmp dnext_char

Dend_of_string:
    mov [di],'$'    ;END
    ret 
    



end