.286
.model small
.stack 256
	picxsize  equ 13    
	picysize  equ 14     

.data
x  dw 34;14-for max tavla(9*15)
y  dw 9;9-for max tavla(9*15)
x1 dw ?
y1 dw ?
xb dw 60
yb dw 184
	;     1   2   3   4   5   6   7   8   9  10  11  12  13	    	 	

pic1  db 000,000,000,004,004,004,004,004,004,004,000,000,000	;1
      db 000,000,004,004,004,004,004,004,004,004,004,000,000	;2
      db 000,004,004,004,004,004,004,004,004,004,004,004,000	;3
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;4
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;5
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;6
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;7
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;8
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;9
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;10
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;11
      db 000,004,004,004,004,004,004,004,004,004,004,004,000	;12
      db 000,000,004,004,004,004,004,004,004,004,004,000,000	;13
      db 000,000,000,004,004,004,004,004,004,004,000,000,000	;14

	continue    db 'Wanna play again?',10,13,'       Y/N$',10,13
	ten      db 10
	timepass db 0
	difficulty db 'choose difficulty',10,13,'Easy',10,13,'Normal',10,13,'Hard$',10,13
	msgPoints db'Balls catched:$',10,13
	msgTime   db'Time:   /90$',10,13
	msgControls		 db '                               Catch The Ball',10,13,'Controls:',10,13,'         Move Left - Left Corsur',10,13,10,13,'         Move Right - Right Corsur',10,13,10,13,'         Move Down - Down Corsur',10,13,10,13,'         Move Up - Up Corsur',10,13,10,13,'         Catch the ball - Enter/Space button',10,13,10,13,'         Quit - Esc',10,13,10,13,'                    All Rights Reserved To Galili Or (c)',10,13,10,13,'Press any key to continue$'
	ok       db ?
	points   dw 0
	side     dw 20
	num      dw 5  
	ycol     dw ?
	xcol     dw ?
	yline    dw ?	
	xline    dw ?
	limit    dw ?  
	m_amudot dw ?
	m_shurot dw ?
	orehamud     dw 0
	orehshura    dw 0
	xtop     dw 30;10-for max tavla(9*15)
	ytop     dw 5;5-for max tavla(9*15)
	amudimcolor    db 30
	tavlacolor     db 22
.code
mov ax,@data
mov ds,ax

	call ControlsMenu
	anotherRound:
		call DifficultyMenu

	call BuildGame
	call PlayTheGame
	call YourScore
	call IfContinue
	cmp ok,'Y'
	jz anotherRound
	cmp ok,'y'
	jz anotherRound
	
	mov ax,2
	int 10h

	


mov ah,4ch
int 21h
;----------------------------------------------------------------------------
;in- continue- On-screen message whether the user wants another game.
;out- The function returns a user's answer whether to continue or not.
IfContinue:	pusha
			mov bh,0
			mov dh,1
			mov dl,0
			mov ah,2
			int 10h
			lea dx,continue
			mov ah,09h
			int 21h
		chooseStart:	
			mov ah,07h
			int 21h
			cmp al,'Y'
			jz youChoosed
			cmp al,'N'
			jz youChoosed
			cmp al,'y'
			jz youChoosed
			cmp al,'n'
			jz youChoosed
			jmp chooseStart
		youChoosed:
			mov ok,al
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
YourScore:	pusha
			mov ax,12h
			int 10h
			call ShowPoints
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
PlayTheGame:	
			pusha
			mov ch,0
			mov cl,0
			mov dh,0
			mov dl,0
			mov ah,3
			int 1ah
		Game:	
			call movement
			mov ah,2
			int 1ah
			cmp cl,90		;90 seconds
			mov timepass,dh
			jae finish
			cmp ok,1bh		; escape key
			jnz Game
		finish:
			mov ax,2
			int 10h
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
BuildGame:	pusha
			mov ax,13h
			int 10h
			call ShowTime
			call ShowPoints
			call Temp
			call SizeAmudim ;cheak size of the amudim
			call drawTavla
			call drawAmudim
			call RandomPlace
			popa
			ret
;----------------------------------------------------------------------------
;in- 
;out-
DifficultyMenu:	pusha
				mov xb,60
				mov yb,184
				mov points,0
				mov ax,12h
				int 10h
				call DifficultyText
				call Choose
				popa
				ret
;----------------------------------------------------------------------------
;in- msgControls - A message showing what keys are being played in the game. 
;out-
ControlsMenu:	
			pusha
			mov ax,02h
			int 10h
	
			lea dx,msgControls
			mov ah,09h
			int 21h

			mov ah,0          ;wait for any key from keyboard
			int 16h
			popa
			ret
;----------------------------------------------------------------------------
;in- msgPoints- Message the points accumulated by the user, points- The points earned by the user.
;out- Message on the screen how many points the user has accumulated
ShowPoints:	pusha
			mov bh,0
			mov dh,0
			mov dl,0
			mov ah,2
			int 10h
			lea dx,msgPoints
			mov ah,09h
			int 21h
			mov ax,points
			div ten
			mov bh,ah
			add al,48
			mov dl,al
			mov ah,2
			int 21h
			mov ah,bh
			add ah,48
			mov dl,ah
			mov ah,2
			int 21h
			popa
			ret
;----------------------------------------------------------------------------
;in- msgTime- Time message , timepass- Time left for the game , ten- Divides the remaining time into two digits: tens and ones.
;out- Message on the screen how much time is left until the end of the game.
ShowTime:	pusha
			mov bh,0
			mov dh,0
			mov dl,27
			mov ah,2
			int 10h

			lea dx,msgTime
			mov ah,09h
			int 21h

			mov bh,0
			mov dh,0
			mov dl,33
			mov ah,2
			int 10h
			
			mov al,1
			mul timepass
			div ten
			mov bh,ah
			add al,48
			mov dl,al
			mov ah,2
			int 21h
			mov ah,bh
			add ah,48
			mov dl,ah
			mov ah,2
			int 21h
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
EasyDiff:	pusha
			mov m_amudot,5
			mov m_shurot,5
			mov x,94
			mov y,49
			mov xtop,90
			mov ytop,45
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
NormalDiff:	pusha
			mov m_amudot,9
			mov m_shurot,7
			mov x,74
			mov y,29
			mov xtop,70
			mov ytop,25
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
HardDiff:	pusha
			mov m_amudot,13
			mov m_shurot,9
			mov x,34
			mov y,12
			mov xtop,30
			mov ytop,8
			popa
			ret
;----------------------------------------------------------------------------
;in- xb - Column index , yb - Row index
;out- Drawing a line.
PutpixelLoop:	pusha
				mov cx,xb
				mov dx,yb
				mov bx,cx
				add bx,5
			loopPix:	
				call putpixel
				inc cx
				cmp cx,bx
				jnz loopPix
				popa
				ret
;----------------------------------------------------------------------------
;in- difficulty- levels menu
;out-
DifficultyText:	pusha
				mov bh,0
				mov dh,10
				mov dl,25
				mov ah,2
				int 10h
		
				lea dx,difficulty
				mov ah,09h
				int 21h
			
				mov al,3
				call PutpixelLoop
				popa
				ret
;----------------------------------------------------------------------------
;in-
;out-
moveUp:	pusha
		mov al,0
		call PutpixelLoop
		mov al,3
		cmp yb,184
		jz goDown
		sub yb,16
		call PutpixelLoop
		popa
		ret
		goDown:
			mov yb,216
			call PutpixelLoop
		popa
		ret
;----------------------------------------------------------------------------
;in-
;out-
moveDown:	pusha
			mov al,0
			call PutpixelLoop
			mov al,3
			cmp yb,216
			jz goUp
			add yb,16
			call PutpixelLoop
			popa
			ret
			goUp:
				mov yb,184
				call PutpixelLoop
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
Choose:		pusha
	start:	mov ah,0
			int 16h
			cmp al,' '
			jz ChooseDiff
			cmp al,13
			jz ChooseDiff
			cmp ah,80
			jz mDown
			cmp ah,72
			jz mUp
			jmp start
		mUp:
			call moveUp
			jmp start
		mDown:
			call moveDown
			jmp start
		ChooseDiff:
			cmp yb,184
			jz Easy 
			cmp yb,200
			jz Normal
			cmp yb,216
			jz Hard
			Easy:
				call EasyDiff
				jmp theEnd
			Normal:
				call NormalDiff
				jmp theEnd
			Hard:
				call HardDiff
	theEnd:	popa
			ret
;----------------------------------------------------------------------------
;in-   x- Column image , y- Row image.
;out-  x1=x , y1=y
Temp:	pusha
		mov bx,x
		mov x1,bx
		mov bx,y
		mov y1,bx
		popa
		ret	
;----------------------------------------------------------------------------
;in-  m_shurot- Number of lines , m_amudot- Number of columns.
;out- row length, column length.
SizeAmudim:	pusha
			mov ax,m_shurot
			mul side
			add ax,ytop
			mov orehamud,ax
			mov ax,m_amudot
			mul side
			add ax,xtop
			mov orehshura,ax
			popa
			ret
;----------------------------------------------------------------------------
;in- m_shurot- number of lines , m_amudot-Number of columns , ytop- The end of the table row , xtop-The end of the table column , tavlacolor- table color, side- distance from row to row or column to column
;out- table.
drawTavla:	pusha
			mov bx,0
			mov dx,ytop
			mov cx,xtop
		loopShura:
				mov al,tavlacolor
				call drawRow
				inc bx
				add dx,side
				cmp bx,m_shurot
				jbe loopShura
			mov bx,0
			mov dx,ytop
			mov cx,xtop
		loopAmuda:
				mov al,tavlacolor
				call drawCol
				inc bx
				add cx,side
				cmp bx,m_amudot
				jbe loopamuda
			popa
			ret
;----------------------------------------------------------------------------
;in-  ytop- end row ,xtop- end column.
;out-
drawAmudim:	pusha
			mov dx,ytop
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov cx,xtop
			mov al,amudimcolor
			call drawRow
		
			mov xline,cx
			mov yline,dx
			mov dx,ytop
			mov cx,xtop
		
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov dx,ytop
			mov al,amudimcolor
			call drawCol

			mov xcol,cx
			mov ycol,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in-ytop- end of row column , tavlacolor- table color , orehamud- length of column , amudimcolor- columns color , side- distance between columns ,yline- last index of row columns.
;out- delete column.
deleteCol:	pusha
			mov al,tavlacolor
			mov dx,orehamud
		deleteC:	
			call putpixel
			dec dx
			cmp dx,ytop
			jae deleteC 
			mov al,amudimcolor
			mov dx,yline
			call putpixel	
			sub dx,side
			call putpixel
			mov dx,ytop
			popa
			ret
;-----------------------------------------------------------------------------
;in- tavlacolor- table color , orehshura- row length , amudimcolor- columns color , xtop- end column , xcol- last index of columns of columns.
;out- delete row.
deleteRow:	pusha
			mov al,tavlacolor
			mov cx,orehshura
		deleteR:
			call putpixel
			dec cx
			cmp cx,xtop
			jae deleteR
			mov al,amudimcolor
			mov cx,xcol
			call putpixel
			sub cx,side
			call putpixel
			mov cx,xtop
			popa
			ret									
;-----------------------------------------------------------------------------
;in- ytop- end line of columns , orehamud- column length.
;out- draw a column.
drawCol:	mov dx,ytop
		drawC:
			call putpixel
			inc dx
			cmp orehamud,dx
			jae drawC
			ret
;-----------------------------------------------------------------------------
;in- xtop- end of columns , orehshura- row length.
;out- îöééø ùåøä
drawRow:	mov cx,xtop
		drawR:
			call putpixel
			inc cx
			cmp cx,orehshura
			jbe drawR
			ret
;-----------------------------------------------------------------------------
;in- xcol- last index of column , side- distance between column to column , x- picture column , y- picture row ,yline- last index of column rows , points- points accumulated by the user.
;out- return if the ball catched.
cheakPlace: pusha
			mov bx,xcol
			cmp x,bx
			jns finishFunc
			sub bx,side
			cmp x,bx
			jbe finishFunc
			mov bx,yline
			cmp y,bx
			jns finishFunc
			sub bx,side
			cmp y,bx
			jbe finishFunc
			inc points
			mov ok,1
			call ShowPoints
	finishFunc:popa
			ret
;-----------------------------------------------------------------------------
;in- side- distance between column to column , orehamud- column length , orehshura- row length , amudimcolor- color of columns.
;out- delete the two columns on the left and draw two new ones at the beginning of the right.
Rightstart:	pusha
			call deleteCol
			add cx,side
			mov dx,orehamud
			call deleteCol
			mov cx,orehshura
			mov al,amudimcolor
			call drawCol
			sub cx,side
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov xcol,cx
			mov ycol,dx
			popa
			ret	
;-----------------------------------------------------------------------------
;in- xcol- last index of columns , ycol- last index of row of columns , side- distance between column to column , xtop- ÷öä òîåãú äòîåãéí , amudimcolor- öáò äòîåãéí
;out- delete column and draw new column elsewhere. 
Left:	pusha
		mov cx,xcol
		mov dx,ycol
		sub cx,side
		cmp cx,xtop
		jz Rside
		add cx,side
		call deleteCol
		sub cx,side
		sub cx,side
		mov al,amudimcolor
		call drawCol
		add cx,side
		mov xcol,cx
		mov ycol,dx
		popa
		ret
	Rside:
		call Rightstart
		popa
		ret
;-----------------------------------------------------------------------------
;in- side- distance between column to column , orehamud- column length , amudimcolor- columns color , xtop- end column of columns.
;out- delete the two pages on the right side and draws two new ones at the beginning of the left side.
leftstart:	pusha
			call deleteCol
			sub cx,side
			mov dx,orehamud
			call deleteCol
			mov cx,xtop
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov al,amudimcolor
			call drawCol
			mov xcol,cx 
			mov ycol,dx
			popa	
			ret
;-----------------------------------------------------------------------------
;in- yline- the row point of the row columns , xline- the column point of the row columns , orehamud- column length , side- distance between column to column , amudimcolor- columns color.  
;out- delte row and draw a new one elsewhere.
Down:	pusha
		mov dx,yline
		mov cx,xline
		cmp dx,orehamud
		jz Uside
		sub dx,side
		call deleteRow
		add dx,side
		add dx,side
		mov al,amudimcolor
		call drawRow
		mov yline,dx
		mov xline,cx
		popa
		ret
	Uside:
		call Upstart
		popa
		ret
;-----------------------------------------------------------------------------
;in-orehshura- row length , side- distance between column to column , amudimcolor- columns color , ytop- start point of columns.
;out- delete two down top columns and draw up top columns. 
Upstart:	pusha
			call deleteRow
			mov cx,orehshura
			sub dx,side
			call deleteRow
			mov dx,ytop
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov al,amudimcolor
			call drawRow
			mov xline,cx
			mov yline,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in- orehshura- row length , side- distance between column to column , amudimcolor- columns color , orehamud- column length.
;out- delete up down top columns and draw down top columns. 
DownStart:	pusha
			call deleteRow
			mov cx,orehshura
			add dx,side
			call deleteRow
			mov dx,orehamud
			mov al,amudimcolor
			call drawRow
			sub dx,side
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov xline,cx
			mov yline,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in- yline- the row point of the row columns , xline- the column point of the row columns , ytop- start of row columns , side- distance between column to column , amudimcolor- columns color.  
;out- delete one row and draw another elsewhere.
Up:	pusha
	mov dx,yline
	mov cx,xline
	sub dx,side
	cmp dx,ytop
	jz Dside
	add dx,side
	call deleteRow
	sub dx,side			
	sub dx,side
	mov al,amudimcolor
	call drawRow
	add dx,side
	mov xline,cx
	mov yline,dx
	popa
	ret
	Dside:
		call DownStart
		popa 
		ret		
;-----------------------------------------------------------------------------
;in- xcol- last index of columns , ycol- last y index of columns , side- distance between column to column , orehshura- row length , amudimcolor- columns color.
;out- delete column and draw new one elsewhere. 
Right:	pusha
		mov cx,xcol
		mov dx,ycol
		cmp cx,orehshura
		jz LSide
		sub cx,side
		call deleteCol
		add cx,side
		add cx,side
		mov al,amudimcolor
		call drawCol
		mov xcol,cx
		mov ycol,dx
		popa
		ret
	LSide:
		call leftstart
		popa
		ret
;-----------------------------------------------------------------------------
;in al- movement direction.
;out
movement:	
		pusha
		mov ah,0
		int 16h
		mov ok,al
		cmp al,' '
		jz cheak
		cmp al,13
		jz cheak
		cmp ah,75
		jz l
		cmp ah,77
		jz R
		cmp ah,80
		jz D
		cmp ah,72
		jz U
		jmp return
	cheak:	;Cheak if the ball is in there
		call cheakPlace
		cmp ok,1
		jnz noRand
		call delPic
		call RandomPlace
	noRand:	
		jmp return
	R:		;move Right
		call ifRandPlace	
		call Right
		jmp return
	l:      ;move Left
		call ifRandPlace
		call Left
		jmp return
	D:      ;move Down 
		call ifRandPlace
		call Down
		jmp return 
	U:		;move up
		call ifRandPlace
		call Up
	return:
		call showTime
		popa
		ret
;-----------------------------------------------------------------------------
;in- num- number , ax- random number.
;out-check if should rplace the image. if yes then delete the previous image and draw the image in the random new location. else do nothing.
ifRandPlace:pusha
			mov dx,0
			in al,40h
			div num
			mov bx,dx
			mov dx,0
			in al,40h
			div num
			cmp dx,bx
			jnz sof
			call delPic
			call RandomPlace
		sof:
			popa
			ret
;-----------------------------------------------------------------------------
;in- (x1,y1)- top left coordinate , m_amudot- number of columns , m_shurot-number of rows , side- distance between column to column.
;out- draw picture in random place.
RandomPlace:pusha
			mov bx,x1
			mov x,bx
			mov bx,y1
			mov y,bx
			mov dx,0
			in al,40h
			div m_amudot
			mov ax,dx
			mul side
			add x,ax
			in al,40h
			div m_shurot
			mov ax,dx
			mul side
			add y,ax
			call loadpic
			call drawpic
			popa
			ret	
;-----------------------------------------------------------------------------
;in-
;out-
delPic:
		pusha
		mov dx,y
		mov al,0
		mov cx,x
	delLines:
		call putpixel
		inc cx
		cmp cx,xb
		jnz delLines
		mov cx,x
		inc dx
		cmp dx,yb
		jnz delLines
		popa
		ret
;------------------------------------------------------------------------
; in: al-the number of the picture to draw
; out: lea the right picture
	loadpic:
				cmp al,'1'
				lea si,pic1
				ret			
;------------------------------------------------------------------------
;in:
;out:	
	drawpic:       ;in: (x,y) , si
	pusha
			mov dx,y			; xb=x+ysize
			mov cx,x			; yb=y+xsize
			mov yb,dx
			mov xb,cx
			mov bx,picysize
			add yb,bx
			mov bx,picxsize
			add xb,bx
	cycle:
			mov al,[si]			;lokhim zeva mesauyam be makom si memaarah shel zvaim shel solder
			call putpixel		;in: (dx,cx), al-collor; out: pixel
			inc si				;zeva haba memaarah zvaim shel pic
			inc cx				;raz lefi amudot be kol shura
			cmp cx,xb			;bdika haim siem shura
			js cycle
			sub cx,picxsize		;makem et cx be thilat ha shura ha baa
			inc dx				;laavor shura
			cmp dx,yb			;bdika im siem picture
			js cycle
	popa
	ret
;------------------------------------------------------------------------------------	
		putpixel:   ; *** the proc need al=color , cx=col, dx= row ***
	pusha
		mov ah,0ch  ;**   ah=0c -> the interupt number    **;
		int 10h
	popa
	ret
end
